const admin = require("firebase-admin");
const path = require("path");

const serviceAccount = require(
    path.join(__dirname, "../../serviceAccountKey.json")
);

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    storageBucket: `${serviceAccount.project_id}.firebasestorage.app`,
});

module.exports = admin;
