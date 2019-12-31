const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendNotification = functions.firestore
    .document('messages/{message}')
    .onCreate((snap, context) => {
        const doc = snap.data();
        if(doc.receiverToken == '' || doc.receiverToken == null) return;
        payload = {};
        console.log(doc);
        if(doc.text == '') {
            payload = {
                notification: {
                    title: doc.senderName + " has sent you an image",
                    body: '',
                    sound: 'default',
                    image: doc.imageURL,
                }
            };
        } else {
            payload = {
                notification: {
                    title: 'Message from ' + doc.senderName,
                    body: doc.text,
                    sound: 'default',
                }
            };
        }
        console.log(payload);
        admin.messaging().sendToDevice(doc.receiverToken, payload);
    });