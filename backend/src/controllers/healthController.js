exports.health = (req, res) => {
    res.status(200).json({
        status: "Node backend working",
        timestamp: new Date(),
    });
};
