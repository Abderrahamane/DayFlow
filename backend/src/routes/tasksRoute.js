const express = require("express");
const router = express.Router();

const auth = require("../middlewares/auth.middleware");
const {
	listTasks,
	createTask,
	updateTask,
	deleteTask,
	toggleTaskCompletion,
	toggleSubtaskCompletion,
} = require("../controllers/tasksController");

router.use(auth);

router.get("/", listTasks);
router.post("/", createTask);
router.put("/:id", updateTask);
router.delete("/:id", deleteTask);
router.post("/:id/toggle-complete", toggleTaskCompletion);
router.post("/:taskId/subtasks/:subtaskId/toggle", toggleSubtaskCompletion);

module.exports = router;
