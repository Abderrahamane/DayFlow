const habitCreate = {
  body: {
    name: { required: true, type: "string" },
    description: { type: "string" },
    icon: { type: "string" },
    frequency: { type: "string", enum: ["daily", "weekly", "custom"] },
    goalCount: { type: "number" },
    linkedTaskTags: { type: "object" },
    colorValue: { type: "number" },
  },
};

const habitUpdate = {
  body: {
    name: { type: "string" },
    description: { type: "string" },
    icon: { type: "string" },
    frequency: { type: "string", enum: ["daily", "weekly", "custom"] },
    goalCount: { type: "number" },
    linkedTaskTags: { type: "object" },
    colorValue: { type: "number" },
    completionHistory: { type: "object" },
  },
};

const habitToggleCompletion = {
  body: {
    dateKey: { required: true, type: "string", regex: /^\d{4}-\d{2}-\d{2}$/ },
  },
};

module.exports = {
  habitCreate,
  habitUpdate,
  habitToggleCompletion,
};
