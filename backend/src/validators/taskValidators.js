const taskCreate = {
  body: {
    title: { required: true, type: "string" },
    description: { type: "string" },
    priority: { type: "string", enum: ["none", "low", "medium", "high"] },
    dueDate: { type: "string" },
    tags: { type: "object" }, // arrays are typeof 'object'
    isCompleted: { type: "boolean" },
  },
};

const taskUpdate = {
  body: {
    title: { type: "string" },
    description: { type: "string" },
    priority: { type: "string", enum: ["none", "low", "medium", "high"] },
    dueDate: { type: "string" },
    tags: { type: "object" },
    isCompleted: { type: "boolean" },
    subtasks: { type: "object" },
    attachments: { type: "object" },
  },
};

module.exports = {
  taskCreate,
  taskUpdate,
};
