// firebase.js
const admin = require('firebase-admin');
const serviceAccount = require('./resolute-e8cac-firebase-adminsdk-2po81-ef86825ca8.json'); // Update the path

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  storageBucket: 'gs://resolute-e8cac.appspot.com' // Replace with your bucket name
});

const bucket = admin.storage().bucket();

module.exports = { bucket };
