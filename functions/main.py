import os
import json
import openai
import logging
import requests
from dotenv import load_dotenv
from firebase_functions import https_fn
from firebase_admin import initialize_app, firestore, credentials


# Load environment variables
load_dotenv()

# Debugging: Check if the environment variable is loaded
credentials_json = os.getenv("GOOGLE_APPLICATION_CREDENTIALS_JSON")
credentials_info = json.loads(credentials_json)

# Create credentials from the JSON key
google_credentials = credentials.Certificate(credentials_info)

# Initialize Firebase Admin SDK
initialize_app(google_credentials)

db = firestore.client()

# Initialize OpenAI API client
openai_api_key = os.getenv("OPENAI_API_KEY")
client = openai.OpenAI(api_key=openai_api_key)
centersByCategoryAPI = os.getenv("CENTERS_API")

# Set up logging
logging.basicConfig(level=logging.INFO)

def process_message_to_assistant(data: dict) -> dict:
    """Helper function to process messages sent to the assistant."""
    try:
        # Validate the request data
        if 'openai_thread_id' not in data or 'message_content' not in data:
            logging.warning("Missing openai_thread_id or message_content in the request data")
            return {"error": "Missing openai_thread_id or message_content"}

        # Extract data
        openai_thread_id = data['openai_thread_id']
        user_message = data['message_content']

        # Step 1: Check if openai_thread_id is None or empty
        if not openai_thread_id:
            # If no openai_thread_id is provided, create a new thread
            logging.info("No existing thread ID provided, creating a new thread.")
            new_thread = client.beta.threads.create(
                messages=[{"role": "user", "content": user_message}]
            )
            openai_thread_id = new_thread.id
            logging.info(f"Created new thread with OpenAI ID: {openai_thread_id}")
        else:
            # Add the new user message to the existing thread
            logging.info(f"Using existing OpenAI thread ID: {openai_thread_id}")
            
            client.beta.threads.messages.create(
                thread_id=openai_thread_id,
                role="user",
                content=user_message
            )
            thread_messages = client.beta.threads.messages.list(openai_thread_id)
            
            logging.info("Getting all messages from existing thread")
            logging.info(thread_messages)

        # Step 2: Run the assistant in the thread
        run = client.beta.threads.runs.create(
            thread_id=openai_thread_id,
            assistant_id="asst_KqWQr6PQAe8fu6wJuiycuaEv"
        )

        # Wait for the run to complete
        while run.status != "completed":
            run = client.beta.threads.runs.retrieve(thread_id=openai_thread_id, run_id=run.id)

            if run.status == "requires_action":
                # Handle tool calls
                tool_calls = run.required_action.submit_tool_outputs.tool_calls
                tool_outputs = []

                for tool in tool_calls:
                    if tool.function.name == "get_help_centers_by_category":
                        tool_args = json.loads(tool.function.arguments)
                        category = tool_args.get("category")

                        # Call your Firebase function to fetch help centers
                        response = requests.post(
                            centersByCategoryAPI,
                            json={"category": category}
                        )

                        if response.status_code == 200:
                            tool_output = {"tool_call_id": tool.id, "output": response.text}
                        else:
                            tool_output = {
                                "tool_call_id": tool.id,
                                "output": json.dumps({"error": "Failed to fetch help centers"})
                            }

                        tool_outputs.append(tool_output)

                # Submit tool outputs back to the assistant
                client.beta.threads.runs.submit_tool_outputs(
                    thread_id=openai_thread_id,
                    run_id=run.id,
                    tool_outputs=tool_outputs
                )


        # Step 3: Retrieve only the latest assistant message after the run completes
        messages = sorted(
            client.beta.threads.messages.list(thread_id=openai_thread_id).data,
            key=lambda x: x.created_at
        )   

        # Get the last message, which should be the assistant's response
        latest_assistant_message = messages[-1] if messages else None

        # Extract content from the latest assistant message
        if latest_assistant_message:
            content_blocks = latest_assistant_message.content
            assistant_response = next(
                (block.text.value for block in content_blocks if block.type == 'text'), None
            )
        else:
            assistant_response = "No assistant response found."

        # Return thread ID if newly created, otherwise just the response
        if 'openai_thread_id' not in data or not data['openai_thread_id']:
            return {"openai_thread_id": openai_thread_id, "response": assistant_response}
        else:
            return {"response": assistant_response}

    except Exception as e:
        logging.error(f"Internal Error: {str(e)}", exc_info=True)
        return {"error": f"Internal Error: {str(e)}"}

# Production version for firebase SDK
@https_fn.on_call()
def send_message_to_assistant(req: https_fn.CallableRequest) -> dict:
    # Process the message and return a dictionary response
    return process_message_to_assistant(req.data)


# Testing version for Postman
@https_fn.on_request()
def test_send_message_to_assistant(req: https_fn.Request) -> https_fn.Response:
    data = req.get_json(silent=True)
    result = process_message_to_assistant(data) 
    return https_fn.Response(json.dumps(result), status=200, mimetype="application/json")

@https_fn.on_request()
def get_help_centers_by_category(req: https_fn.Request) -> https_fn.Response:
    try:
        # Parse the request for the category
        body_data = req.get_json(silent=True)
        logging.info(f"Request headers: {req.headers}")
        
        category = body_data.get("category")

        if not category:
            return https_fn.Response(
                json.dumps({"error": "Category is required."}),
                status=400,
                mimetype="application/json",
            )

        categories = ['alimentacion', 'refugio', 'salud', 'vestimenta']

        if category not in categories:
            return https_fn.Response(
                json.dumps({"error": f"Invalid category. Allowed categories are: {', '.join(categories)}."}),
                status=400,
                mimetype="application/json",
            )
            
        # Query Firestore for help centers by category
        help_centers = (
            db.collection("help_centers")
            .where("category", "==", category)
            .stream()
        )

        # Prepare the results
        result = []
        for center in help_centers:
            center_data = center.to_dict()
            location = center_data.get("location", {})
            address = location.get("address", "No Address Provided")
            result.append({
                "id": center.id,
                "name": center_data.get("name", "Unknown Name"),
                "address": address,  
                "contact_number": center_data.get("contact_number", "No Contact Info"),
                "category": center_data.get("category", "Unknown Category"),
            })

        # Respond with the list of help centers
        return https_fn.Response(
            json.dumps({"help_centers": result}),
            status=200,
            mimetype="application/json",
        )

    except Exception as e:
        logging.error(f"Error fetching help centers: {str(e)}", exc_info=True)
        return https_fn.Response(
            json.dumps({"error": f"Internal Server Error: {str(e)}"}),
            status=500,
            mimetype="application/json",
        )
