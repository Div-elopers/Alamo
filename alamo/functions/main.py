import logging
from firebase_functions import https_fn
from firebase_admin import initialize_app
import openai
import os
from dotenv import load_dotenv
import json

# Initialize Firebase Admin SDK
initialize_app()

# Load environment variables
load_dotenv()

# Initialize OpenAI API client
openai_api_key = os.getenv("OPENAI_API_KEY")
client = openai.OpenAI(api_key=openai_api_key)

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

        # Step 3: Retrieve only the latest assistant message after the run completes
        # Retrieve messages from the thread after the run completes
        messages = sorted(
            client.beta.threads.messages.list(thread_id=openai_thread_id).data,
            key=lambda x: x.created_at
        )

        logging.info("Getting all messages after run")
        logging.info(messages)

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
