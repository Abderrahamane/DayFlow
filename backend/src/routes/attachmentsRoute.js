const express = require("express");
const router = express.Router();
const auth = require("../middlewares/auth.middleware");
const validate = require("../middlewares/validate");
const { presignUpload, deleteAttachment } = require("../controllers/attachmentsController");

router.use(auth);
router.post(
	"/presign",
	validate({
		body: {
			filename: { required: true, type: "string" },
			contentType: { type: "string" },
		},
	}),
	presignUpload
);
router.delete("/", deleteAttachment);

module.exports = router;
