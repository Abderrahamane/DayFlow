const admin = require("../config/firebase");

module.exports = async (req, res, next) => {
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        return res.status(401).json({
            error: {
                code: "UNAUTHORIZED",
                message: "Unauthorized: missing Bearer token",
            },
        });
    }

    const token = authHeader.split(" ")[1];

    try {
        const decodedToken = await admin.auth().verifyIdToken(token);
        req.user = {
            uid: decodedToken.uid,
            email: decodedToken.email || null,
        };
        return next();
    } catch (err) {
        return res.status(401).json({
            error: {
                code: "UNAUTHORIZED",
                message: "Unauthorized: invalid or expired token",
            },
        });
    }
};
