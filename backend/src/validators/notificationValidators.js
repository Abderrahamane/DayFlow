const notificationCreate = {
  body: {
    title: { required: true, type: "string" },
    body: { required: true, type: "string" },
    timestamp: { type: "string" },
    isRead: { type: "boolean" },
    payload: { type: "object" },
  },
};

module.exports = {
  notificationCreate,
};
