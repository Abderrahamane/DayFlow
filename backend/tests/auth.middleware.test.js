const mockVerifyIdToken = jest.fn();

jest.mock("../src/config/firebase", () => ({
  auth: () => ({
    verifyIdToken: mockVerifyIdToken,
  }),
}));

const authMiddleware = require("../src/middlewares/auth.middleware");

describe("Auth Middleware", () => {
  let req, res, next;

  beforeEach(() => {
    req = {
      headers: {},
    };
    res = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn().mockReturnThis(),
    };
    next = jest.fn();
    jest.clearAllMocks();
  });

  describe("Missing or Invalid Authorization Header", () => {
    it("should return 401 when Authorization header is missing", async () => {
      await authMiddleware(req, res, next);

      expect(res.status).toHaveBeenCalledWith(401);
      expect(res.json).toHaveBeenCalledWith({
        error: {
          code: "UNAUTHORIZED",
          message: "Unauthorized: missing Bearer token",
        },
      });
      expect(next).not.toHaveBeenCalled();
    });

    it("should return 401 when Authorization header does not start with Bearer", async () => {
      req.headers.authorization = "Basic sometoken";

      await authMiddleware(req, res, next);

      expect(res.status).toHaveBeenCalledWith(401);
      expect(res.json).toHaveBeenCalledWith({
        error: {
          code: "UNAUTHORIZED",
          message: "Unauthorized: missing Bearer token",
        },
      });
      expect(next).not.toHaveBeenCalled();
    });

    it("should return 401 when Bearer token is empty", async () => {
      req.headers.authorization = "Bearer ";

      mockVerifyIdToken.mockRejectedValue(new Error("Invalid token"));

      await authMiddleware(req, res, next);

      expect(res.status).toHaveBeenCalledWith(401);
      expect(next).not.toHaveBeenCalled();
    });
  });

  describe("Valid Token", () => {
    it("should call next and attach user when token is valid", async () => {
      const mockDecodedToken = {
        uid: "test-user-123",
        email: "test@example.com",
      };

      req.headers.authorization = "Bearer valid-token";
      mockVerifyIdToken.mockResolvedValue(mockDecodedToken);

      await authMiddleware(req, res, next);

      expect(mockVerifyIdToken).toHaveBeenCalledWith("valid-token");
      expect(req.user).toEqual({
        uid: "test-user-123",
        email: "test@example.com",
      });
      expect(next).toHaveBeenCalled();
      expect(res.status).not.toHaveBeenCalled();
    });

    it("should handle missing email in decoded token", async () => {
      const mockDecodedToken = {
        uid: "test-user-456",
      };

      req.headers.authorization = "Bearer valid-token-no-email";
      mockVerifyIdToken.mockResolvedValue(mockDecodedToken);

      await authMiddleware(req, res, next);

      expect(req.user).toEqual({
        uid: "test-user-456",
        email: null,
      });
      expect(next).toHaveBeenCalled();
    });
  });

  describe("Invalid Token", () => {
    it("should return 401 when token verification fails", async () => {
      req.headers.authorization = "Bearer invalid-token";
      mockVerifyIdToken.mockRejectedValue(new Error("Token expired"));

      await authMiddleware(req, res, next);

      expect(res.status).toHaveBeenCalledWith(401);
      expect(res.json).toHaveBeenCalledWith({
        error: {
          code: "UNAUTHORIZED",
          message: "Unauthorized: invalid or expired token",
        },
      });
      expect(next).not.toHaveBeenCalled();
    });

    it("should return 401 when token is malformed", async () => {
      req.headers.authorization = "Bearer malformed.token.here";
      mockVerifyIdToken.mockRejectedValue(new Error("Decoding Firebase ID token failed"));

      await authMiddleware(req, res, next);

      expect(res.status).toHaveBeenCalledWith(401);
      expect(next).not.toHaveBeenCalled();
    });
  });
});
