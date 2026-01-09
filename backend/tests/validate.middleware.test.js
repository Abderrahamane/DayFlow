const validate = require("../src/middlewares/validate");

describe("Validate Middleware", () => {
  let req, res, next;

  beforeEach(() => {
    req = { body: {} };
    res = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn().mockReturnThis(),
    };
    next = jest.fn();
  });

  describe("Required Fields", () => {
    it("should pass when required field is present", () => {
      const schema = {
        body: {
          title: { required: true, type: "string" },
        },
      };

      req.body = { title: "Test Title" };

      validate(schema)(req, res, next);

      expect(next).toHaveBeenCalled();
      expect(res.status).not.toHaveBeenCalled();
    });

    it("should fail when required field is missing", () => {
      const schema = {
        body: {
          title: { required: true, type: "string" },
        },
      };

      req.body = {};

      validate(schema)(req, res, next);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(res.json).toHaveBeenCalledWith({
        error: {
          code: "VALIDATION_ERROR",
          message: "Invalid request",
          details: [{ field: "title", message: "is required" }],
        },
      });
      expect(next).not.toHaveBeenCalled();
    });

    it("should fail when required field is empty string", () => {
      const schema = {
        body: {
          title: { required: true, type: "string" },
        },
      };

      req.body = { title: "" };

      validate(schema)(req, res, next);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(next).not.toHaveBeenCalled();
    });

    it("should fail when required field is null", () => {
      const schema = {
        body: {
          title: { required: true, type: "string" },
        },
      };

      req.body = { title: null };

      validate(schema)(req, res, next);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(next).not.toHaveBeenCalled();
    });
  });

  describe("Type Validation", () => {
    it("should pass when type matches", () => {
      const schema = {
        body: {
          count: { type: "number" },
        },
      };

      req.body = { count: 42 };

      validate(schema)(req, res, next);

      expect(next).toHaveBeenCalled();
    });

    it("should fail when type does not match", () => {
      const schema = {
        body: {
          count: { type: "number" },
        },
      };

      req.body = { count: "not a number" };

      validate(schema)(req, res, next);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(res.json).toHaveBeenCalledWith({
        error: {
          code: "VALIDATION_ERROR",
          message: "Invalid request",
          details: [{ field: "count", message: "must be of type number" }],
        },
      });
    });

    it("should skip type check for undefined optional fields", () => {
      const schema = {
        body: {
          count: { type: "number" },
        },
      };

      req.body = {};

      validate(schema)(req, res, next);

      expect(next).toHaveBeenCalled();
    });
  });

  describe("Enum Validation", () => {
    it("should pass when value is in enum", () => {
      const schema = {
        body: {
          priority: { enum: ["low", "medium", "high"] },
        },
      };

      req.body = { priority: "medium" };

      validate(schema)(req, res, next);

      expect(next).toHaveBeenCalled();
    });

    it("should fail when value is not in enum", () => {
      const schema = {
        body: {
          priority: { enum: ["low", "medium", "high"] },
        },
      };

      req.body = { priority: "urgent" };

      validate(schema)(req, res, next);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(res.json).toHaveBeenCalledWith({
        error: {
          code: "VALIDATION_ERROR",
          message: "Invalid request",
          details: [{ field: "priority", message: "must be one of: low, medium, high" }],
        },
      });
    });
  });

  describe("Regex Validation", () => {
    it("should pass when value matches regex", () => {
      const schema = {
        body: {
          dateKey: { regex: /^\d{4}-\d{2}-\d{2}$/ },
        },
      };

      req.body = { dateKey: "2025-12-31" };

      validate(schema)(req, res, next);

      expect(next).toHaveBeenCalled();
    });

    it("should fail when value does not match regex", () => {
      const schema = {
        body: {
          dateKey: { regex: /^\d{4}-\d{2}-\d{2}$/ },
        },
      };

      req.body = { dateKey: "12-31-2025" };

      validate(schema)(req, res, next);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(res.json).toHaveBeenCalledWith({
        error: {
          code: "VALIDATION_ERROR",
          message: "Invalid request",
          details: [{ field: "dateKey", message: "is invalid" }],
        },
      });
    });
  });

  describe("Multiple Validations", () => {
    it("should collect all errors", () => {
      const schema = {
        body: {
          title: { required: true, type: "string" },
          body: { required: true, type: "string" },
          count: { type: "number" },
        },
      };

      req.body = { count: "not a number" };

      validate(schema)(req, res, next);

      expect(res.status).toHaveBeenCalledWith(400);
      const jsonCall = res.json.mock.calls[0][0];
      expect(jsonCall.error.details).toHaveLength(3);
    });
  });
});
