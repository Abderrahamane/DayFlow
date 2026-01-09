const admin = require("../config/firebase");

const db = admin.firestore();

const getUserCollection = (uid, collection) =>
  db.collection("users").doc(uid).collection(collection);

const withId = (doc) => ({ id: doc.id, ...doc.data() });

module.exports = {
  db,
  getUserCollection,
  withId,
};
