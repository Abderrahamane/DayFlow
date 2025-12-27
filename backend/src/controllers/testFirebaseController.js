const admin = require("../config/firebase");
const asyncHandler = require("../utils/asyncHandler");

exports.testFirebase = asyncHandler(async (req, res) => {
    const users = await admin.auth().listUsers(5);
    res.status(200).json({
        message: "Firebase connected",
        users: users.users.length,
    });
});
