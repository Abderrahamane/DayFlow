exports.notImplemented = (req, res) => {
	return res.status(501).json({
		error: {
			code: "NOT_IMPLEMENTED",
			message: "Reminders API not implemented",
		},
	});
};
