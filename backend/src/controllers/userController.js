exports.getMe = (req, res) => {
    return res.status(200).json({
        uid: req.user.uid,
        email: req.user.email,
    });
};