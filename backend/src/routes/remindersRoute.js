const express = require("express");
const router = express.Router();

const auth = require("../middlewares/auth.middleware");
const { notImplemented } = require("../controllers/remindersController");

router.use(auth);
router.all("/", notImplemented);

module.exports = router;
