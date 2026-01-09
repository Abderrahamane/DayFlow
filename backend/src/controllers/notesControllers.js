const asyncHandler = require("../utils/asyncHandler");
const { notesRepo } = require("../services/userRepos");

exports.listNotes = asyncHandler(async (req, res) => {
	const { tag, category } = req.query;

	const notes = await notesRepo.list(req.user.uid, { tag, category });

	return res.status(200).json({ notes });
});

exports.createNote = asyncHandler(async (req, res) => {
	const { id, ...data } = req.body || {};
	const note = await notesRepo.upsert(req.user.uid, id, data);
	return res.status(201).json(note);
});

exports.updateNote = asyncHandler(async (req, res) => {
	const noteId = req.params.id;
	const updated = await notesRepo.upsert(req.user.uid, noteId, {
		...req.body,
		updatedAt: new Date().toISOString(),
	});
	return res.status(200).json(updated);
});

exports.deleteNote = asyncHandler(async (req, res) => {
	const noteId = req.params.id;
	const deleted = await notesRepo.delete(req.user.uid, noteId);

	if (!deleted) {
		return res.status(404).json({
			error: {
				code: "NOT_FOUND",
				message: "Note not found",
			},
		});
	}
	return res.status(204).send();
});

exports.togglePin = asyncHandler(async (req, res) => {
	const noteId = req.params.id;
	const result = await notesRepo.togglePin(req.user.uid, noteId);

	if (!result) {
		return res.status(404).json({
			error: {
				code: "NOT_FOUND",
				message: "Note not found",
			},
		});
	}

	return res.status(200).json(result);
});

exports.lockNote = asyncHandler(async (req, res) => {
	const noteId = req.params.id;
	const { lockPin, useBiometric } = req.body || {};

	if (!lockPin && !useBiometric) {
		return res.status(400).json({
			error: {
				code: "VALIDATION_ERROR",
				message: "lockPin or useBiometric is required",
				details: [{ field: "lockPin", message: "Provide lockPin or useBiometric" }],
			},
		});
	}

	const updated = await notesRepo.lock(req.user.uid, noteId, { lockPin, useBiometric });
	if (!updated) {
		return res.status(404).json({
			error: {
				code: "NOT_FOUND",
				message: "Note not found",
			},
		});
	}
	return res.status(200).json(updated);
});

exports.unlockNote = asyncHandler(async (req, res) => {
	const noteId = req.params.id;
	const updated = await notesRepo.unlock(req.user.uid, noteId);
	if (!updated) {
		return res.status(404).json({
			error: {
				code: "NOT_FOUND",
				message: "Note not found",
			},
		});
	}
	return res.status(200).json(updated);
});
