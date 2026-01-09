const express = require("express");
const router = express.Router();

const auth = require("../middlewares/auth.middleware");
const validate = require("../middlewares/validate");
const {
  listNotifications,
  createNotification,
  markNotificationRead,
  markAllNotificationsRead,
  deleteNotification,
  getUnreadCount,
} = require("../controllers/notificationsController");

router.use(auth);

router.get("/", listNotifications);
router.get("/unread-count", getUnreadCount);
router.post(
  "/",
  validate({
    body: {
      title: { required: true, type: "string" },
      body: { required: true, type: "string" },
      timestamp: { type: "string" },
      isRead: { type: "boolean" },
      payload: { type: "object" },
    },
  }),
  createNotification
);
router.post("/read-all", markAllNotificationsRead);
router.post("/:id/read", markNotificationRead);
router.delete("/:id", deleteNotification);

module.exports = router;
