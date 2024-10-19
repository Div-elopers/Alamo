const functions = require('firebase-functions');
const admin = require('firebase-admin');
const axios = require('axios');

admin.initializeApp();

exports.getHelpCenters = functions.https.onRequest(async (request, response) => {
    const category = request.body.queryResult.parameters.category;

    try {
        const snapshot = await admin.firestore().collection('help_centers')
            .where('category', '==', category)
            .get();

        const helpCenters = [];
        snapshot.forEach((doc) => {
            helpCenters.push({
                id: doc.id,
                ...doc.data(),
            });
        });

        response.json({ fulfillmentText: `Encontré ${helpCenters.length} centros de ayuda.`, helpCenters });
    } catch (error) {
        console.error('Error obteniendo los centros de ayuda: ', error.message);
        // Registrar el error en Firestore para análisis futuros
        await admin.firestore().collection('error_logs').add({
            error: error.message,
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
            function: 'getHelpCenters',
        });
        response.status(500).send('Error al obtener los centros de ayuda');
    }
});

exports.chatGPTFunction = functions.https.onCall(async (data, context) => {
    const { threadId, messages } = data;

    const conversation = messages.map((message) => {
        return {
            role: message.senderId === 'chatbot' ? 'assistant' : 'user',
            content: message.content
        };
    });

    try {
        // To-Do Call ChatGPT API 
        const response = await axios.post('https://api.openai.com/v1/chat/completions', {
            model: "gpt-3.5-turbo",
            messages: conversation,
        }, {
            headers: {
                Authorization: `Bearer YOUR_OPENAI_API_KEY`
            }
        });

        const reply = response.data.choices[0].message.content;
        return { reply };

    } catch (error) {
        console.error("Error calling ChatGPT API: ", error);
        throw new functions.https.HttpsError('internal', 'Unable to process chat');
    }
});
