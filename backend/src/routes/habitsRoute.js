const express = require("express");
const router = express.Router();

const auth = require("../middlewares/auth.middleware");
const validate = require("../middlewares/validate");
const {
	listHabits,
	createHabit,
	updateHabit,
	deleteHabit,
	toggleHabitCompletion,
} = require("../controllers/habitsControllers");

router.use(auth);

router.get("/", listHabits);
router.post("/", createHabit);
router.put("/:id", updateHabit);
router.delete("/:id", deleteHabit);
router.post(
	"/:id/toggle-completion",
	validate({ body: { dateKey: { required: true, type: "string" } } }),
	toggleHabitCompletion
);

module.exports = router;
