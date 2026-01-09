module.exports = (err, req, res, next) => {
    console.error(err);

    const status = err.status || 500;
    const code = err.code || (status === 400 ? "VALIDATION_ERROR" : "INTERNAL_ERROR");

    res.status(status).json({
        error: {
            code,
            message: err.message || "Internal Server Error",
            details: err.details,
        },
    });
};
