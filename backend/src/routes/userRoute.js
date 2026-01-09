const express = require("express");
const router = express.Router();
const auth = require("../middlewares/auth.middleware");

const {
    getMe
} = require("../controllers/userController");

router.get("/me", auth, getMe);

module.exports = router;
