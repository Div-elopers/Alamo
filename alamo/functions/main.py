from firebase_functions import https_fn
from firebase_admin import firestore, initialize_app
import openai
import os
from dotenv import find_dotenv, load_dotenv



load_dotenv()

# Now you can access the API key using os.environ
openai_api_key = os.getenv("OPENAI_API_KEY")

# Set the OpenAI API key for the client
openai.api_key = openai_api_key

client = openai.OpenAI()
model = "gpt-3.5-turbo-16k"

initialize_app()


@https_fn.on_call()
def send_message_to_assistant(req: https_fn.Request) -> https_fn.Response:
    try:
        data = req.data
        thread_id = data['threadId']
        user_message = data['messageContent']
        
        assistant_id = "asst_KqWQr6PQAe8fu6wJuiycuaEv"
        

        
        openai.Threads.create_message(
            thread_id=thread_id,
            role="user",
            content=user_message
        )
    
        run = openai.Threads.create_run(
            thread_id=thread_id,
            assistant_id=assistant_id,
        )

        # Wait for the assistant to finish processing the message
        while run.status != "completed":
            run = openai.Threads.retrieve_run(thread_id=thread_id, run_id=run.id)

        # Retrieve the assistant's response
        messages = openai.Threads.list_messages(thread_id=thread_id)
        assistant_response = [
            message for message in messages if message['role'] == 'assistant'
        ][-1]['content']

        # Save the assistant's response to Firestore
        assistant_message = {
            'userIsSender': False,
            'content': assistant_response,
            'timestamp': firestore.SERVER_TIMESTAMP,
            'type': 'text',
        }
        
        db = firestore.client()
        thread_ref = db.collection('chat').document(thread_id)
        
        thread_ref.update({
            'messages': firestore.ArrayUnion([assistant_message])
        })
        
    except Exception as e:
        return https_fn.Response(f"Error: {str(e)}", status=500)
 