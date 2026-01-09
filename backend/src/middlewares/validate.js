module.exports = (schema) => (req, res, next) => {
  const errors = [];

  const addError = (field, msg) => {
    errors.push({ field, message: msg });
  };

  if (schema.body) {
    const body = req.body || {};
    for (const [field, rule] of Object.entries(schema.body)) {
      const value = body[field];
      if (rule.required && (value === undefined || value === null || value === "")) {
        addError(field, "is required");
        continue;
      }
      if (value !== undefined && rule.type && typeof value !== rule.type) {
        addError(field, `must be of type ${rule.type}`);
      }
      if (value !== undefined && rule.enum && !rule.enum.includes(value)) {
        addError(field, `must be one of: ${rule.enum.join(", ")}`);
      }
      if (value !== undefined && rule.regex && !rule.regex.test(value)) {
        addError(field, "is invalid");
      }
    }
  }

  if (errors.length) {
    return res.status(400).json({
      error: {
        code: "VALIDATION_ERROR",
        message: "Invalid request",
        details: errors,
      },
    });
  }

  return next();
};
