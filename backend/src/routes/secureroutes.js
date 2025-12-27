const express = require("express");
const router = express.Router();

const auth = require("../middlewares/auth.middleware");

router.get("/", auth, (req, res) => {
    res.status(200).json({
        message: "Firebase auth working",
        uid: req.user.uid,
        email: req.user.email,
    });
});

module.exports = router;
