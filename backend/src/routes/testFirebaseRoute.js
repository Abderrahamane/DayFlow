const express = require("express");
const router = express.Router();

const {
    testFirebase,
} = require("../controllers/testFirebaseController");

router.get("/", testFirebase);

module.exports = router;
