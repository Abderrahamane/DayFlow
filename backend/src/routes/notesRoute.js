const express = require("express");
const router = express.Router();

const auth = require("../middlewares/auth.middleware");
const {
	listNotes,
	createNote,
	updateNote,
	deleteNote,
	togglePin,
	lockNote,
	unlockNote,
} = require("../controllers/notesControllers");

router.use(auth);

router.get("/", listNotes);
router.post("/", createNote);
router.put("/:id", updateNote);
router.delete("/:id", deleteNote);
router.post("/:id/toggle-pin", togglePin);
router.post("/:id/lock", lockNote);
router.post("/:id/unlock", unlockNote);

module.exports = router;
