const asyncHandler = require("../utils/asyncHandler");
const { tasksRepo } = require("../services/userRepos");

exports.listTasks = asyncHandler(async (req, res) => {
	const tasks = await tasksRepo.list(req.user.uid);
	return res.status(200).json({ tasks });
});

exports.createTask = asyncHandler(async (req, res) => {
	const { id, ...taskData } = req.body || {};
	const task = await tasksRepo.upsert(req.user.uid, id, taskData);
	return res.status(201).json(task);
});

exports.updateTask = asyncHandler(async (req, res) => {
	const taskId = req.params.id;
	const updated = await tasksRepo.upsert(req.user.uid, taskId, req.body);
	return res.status(200).json(updated);
});

exports.deleteTask = asyncHandler(async (req, res) => {
	const taskId = req.params.id;
	const deleted = await tasksRepo.delete(req.user.uid, taskId);

	if (!deleted) {
		return res.status(404).json({
			error: {
				code: "NOT_FOUND",
				message: "Task not found",
			},
		});
	}
	return res.status(204).send();
});

exports.toggleTaskCompletion = asyncHandler(async (req, res) => {
	const taskId = req.params.id;
	const result = await tasksRepo.toggleComplete(req.user.uid, taskId);

	if (!result) {
		return res.status(404).json({
			error: {
				code: "NOT_FOUND",
				message: "Task not found",
			},
		});
	}

	return res.status(200).json(result);
});

exports.toggleSubtaskCompletion = asyncHandler(async (req, res) => {
	const { taskId, subtaskId } = req.params;
	const result = await tasksRepo.toggleSubtask(req.user.uid, taskId, subtaskId);

	if (result?.error === "task") {
		return res.status(404).json({
			error: {
				code: "NOT_FOUND",
				message: "Task not found",
			},
		});
	}
	if (result?.error === "subtask") {
		return res.status(404).json({
			error: {
				code: "NOT_FOUND",
				message: "Subtask not found",
			},
		});
	}

	return res.status(200).json(result);
});
