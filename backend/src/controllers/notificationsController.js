const { randomUUID } = require("crypto");
const asyncHandler = require("../utils/asyncHandler");
const { notificationsRepo } = require("../services/userRepos");

exports.listNotifications = asyncHandler(async (req, res) => {
  const limit = Math.min(parseInt(req.query.limit, 10) || 20, 100);
  const cursor = req.query.cursor;

  const { notifications, nextCursor } = await notificationsRepo.list(req.user.uid, { limit, cursor });
  return res.status(200).json({ notifications, nextCursor });
});

exports.createNotification = asyncHandler(async (req, res) => {
  const { id, ...data } = req.body || {};
  const payload = {
    title: data.title,
    body: data.body,
    timestamp: data.timestamp,
    isRead: data.isRead,
    payload: data.payload,
  };

  if (!payload.title || !payload.body) {
    return res.status(400).json({
      error: {
        code: "VALIDATION_ERROR",
        message: "title and body are required",
        details: [
          { field: "title", message: "title is required" },
          { field: "body", message: "body is required" },
        ],
      },
    });
  }

  const notification = await notificationsRepo.upsert(req.user.uid, id, payload);
  return res.status(201).json(notification);
});

exports.markNotificationRead = asyncHandler(async (req, res) => {
  const notificationId = req.params.id;
  const updated = await notificationsRepo.markRead(req.user.uid, notificationId);

  if (!updated) {
    return res.status(404).json({
      error: {
        code: "NOT_FOUND",
        message: "Notification not found",
      },
    });
  }

  return res.status(200).json(updated);
});

exports.markAllNotificationsRead = asyncHandler(async (req, res) => {
  const count = await notificationsRepo.markAllRead(req.user.uid);
  return res.status(200).json({ success: true, updatedCount: count });
});

exports.deleteNotification = asyncHandler(async (req, res) => {
  const notificationId = req.params.id;
  const deleted = await notificationsRepo.delete(req.user.uid, notificationId);

  if (!deleted) {
    return res.status(404).json({
      error: {
        code: "NOT_FOUND",
        message: "Notification not found",
      },
    });
  }

  return res.status(204).send();
});

exports.getUnreadCount = asyncHandler(async (req, res) => {
  const count = await notificationsRepo.getUnreadCount(req.user.uid);
  return res.status(200).json({ unreadCount: count });
});
