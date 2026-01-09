const asyncHandler = require("../utils/asyncHandler");
const { habitsRepo } = require("../services/userRepos");

exports.listHabits = asyncHandler(async (req, res) => {
		const habits = await habitsRepo.list(req.user.uid);
	return res.status(200).json({ habits });
});

exports.createHabit = asyncHandler(async (req, res) => {
		const { id, ...data } = req.body || {};
		const habit = await habitsRepo.upsert(req.user.uid, id, data);
		return res.status(201).json(habit);
});

exports.updateHabit = asyncHandler(async (req, res) => {
		const habitId = req.params.id;
		const updated = await habitsRepo.upsert(req.user.uid, habitId, req.body);
		return res.status(200).json(updated);
});

exports.deleteHabit = asyncHandler(async (req, res) => {
	const habitId = req.params.id;
		const deleted = await habitsRepo.delete(req.user.uid, habitId);

		if (!deleted) {
		return res.status(404).json({ message: "Habit not found" });
	}
	return res.status(204).send();
});

exports.toggleHabitCompletion = asyncHandler(async (req, res) => {
	const habitId = req.params.id;
	const { dateKey } = req.body || {};

	if (!dateKey) {
		return res.status(400).json({
			error: {
				code: "VALIDATION_ERROR",
				message: "dateKey is required",
				details: [{ field: "dateKey", message: "dateKey is required" }],
			},
		});
	}

	const result = await habitsRepo.toggleCompletion(req.user.uid, habitId, dateKey);

	if (!result) {
		return res.status(404).json({
			error: {
				code: "NOT_FOUND",
				message: "Habit not found",
			},
		});
	}

	return res.status(200).json(result);
});
