const mockVerifyIdToken = jest.fn();
const mockCollection = jest.fn();
const mockDoc = jest.fn();
const mockGet = jest.fn();
const mockSet = jest.fn();
const mockDelete = jest.fn();
const mockOrderBy = jest.fn();
const mockRunTransaction = jest.fn();

jest.mock("../src/config/firebase", () => ({
  auth: () => ({
    verifyIdToken: mockVerifyIdToken,
  }),
  firestore: () => ({
    collection: mockCollection,
    doc: mockDoc,
    runTransaction: mockRunTransaction,
  }),
  storage: () => ({
    bucket: () => ({
      file: () => ({
        getSignedUrl: jest.fn(),
        delete: jest.fn(),
      }),
      name: "test-bucket",
    }),
  }),
}));

// Mock the firestoreCollections utility
jest.mock("../src/utils/firestoreCollections", () => {
  const mockDocRef = {
    get: mockGet,
    set: mockSet,
    delete: mockDelete,
  };
  
  return {
    db: {
      collection: mockCollection,
      runTransaction: mockRunTransaction,
    },
    getUserCollection: jest.fn(() => ({
      orderBy: mockOrderBy.mockReturnValue({
        get: mockGet,
      }),
      doc: jest.fn(() => mockDocRef),
    })),
    withId: (doc) => ({ id: doc.id, ...doc.data() }),
  };
});

const request = require("supertest");
const app = require("../src/app");

describe("Tasks API", () => {
  const mockUser = { uid: "test-user-123", email: "test@example.com" };
  const validToken = "valid-firebase-token";

  beforeEach(() => {
    jest.clearAllMocks();
    // Setup valid token verification
    mockVerifyIdToken.mockResolvedValue(mockUser);
  });

  describe("GET /api/tasks", () => {
    it("should return 401 without auth token", async () => {
      const response = await request(app).get("/api/tasks");

      expect(response.status).toBe(401);
      expect(response.body.error.code).toBe("UNAUTHORIZED");
    });

    it("should return tasks list for authenticated user", async () => {
      const mockTasks = [
        { id: "task-1", title: "Task 1", isCompleted: false },
        { id: "task-2", title: "Task 2", isCompleted: true },
      ];

      const mockSnapshot = {
        docs: mockTasks.map((task) => ({
          id: task.id,
          data: () => ({ title: task.title, isCompleted: task.isCompleted }),
        })),
      };

      mockGet.mockResolvedValue(mockSnapshot);

      const response = await request(app)
        .get("/api/tasks")
        .set("Authorization", `Bearer ${validToken}`);

      expect(response.status).toBe(200);
      expect(response.body).toHaveProperty("tasks");
      expect(Array.isArray(response.body.tasks)).toBe(true);
    });
  });

  describe("POST /api/tasks", () => {
    it("should create a new task", async () => {
      const newTask = {
        title: "New Task",
        description: "Task description",
        priority: "high",
      };

      // Mock for preserveCreatedAt check
      mockGet.mockResolvedValueOnce({ exists: false });
      mockSet.mockResolvedValue({});
      // Mock for returning saved doc
      mockGet.mockResolvedValueOnce({
        id: "generated-id",
        exists: true,
        data: () => ({
          ...newTask,
          createdAt: new Date().toISOString(),
        }),
      });

      const response = await request(app)
        .post("/api/tasks")
        .set("Authorization", `Bearer ${validToken}`)
        .send(newTask);

      expect(response.status).toBe(201);
      expect(response.body).toHaveProperty("id");
    });
  });

  describe("DELETE /api/tasks/:id", () => {
    it("should return 404 for non-existent task", async () => {
      mockGet.mockResolvedValue({ exists: false });

      const response = await request(app)
        .delete("/api/tasks/non-existent-id")
        .set("Authorization", `Bearer ${validToken}`);

      expect(response.status).toBe(404);
      expect(response.body.error.code).toBe("NOT_FOUND");
    });

    it("should delete existing task and return 204", async () => {
      mockGet.mockResolvedValue({ exists: true, data: () => ({}) });
      mockDelete.mockResolvedValue({});

      const response = await request(app)
        .delete("/api/tasks/existing-task-id")
        .set("Authorization", `Bearer ${validToken}`);

      expect(response.status).toBe(204);
    });
  });
});

describe("Health API", () => {
  describe("GET /api/health", () => {
    it("should return status ok without authentication", async () => {
      const response = await request(app).get("/api/health");

      expect(response.status).toBe(200);
      expect(response.body).toEqual({ status: "ok" });
    });
  });
});

describe("User API", () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  describe("GET /api/user/me", () => {
    it("should return user identity for authenticated request", async () => {
      const mockUser = { uid: "user-123", email: "user@test.com" };
      mockVerifyIdToken.mockResolvedValue(mockUser);

      const response = await request(app)
        .get("/api/user/me")
        .set("Authorization", "Bearer valid-token");

      expect(response.status).toBe(200);
      expect(response.body).toEqual({
        uid: "user-123",
        email: "user@test.com",
      });
    });

    it("should return 401 without token", async () => {
      const response = await request(app).get("/api/user/me");

      expect(response.status).toBe(401);
    });
  });
});
