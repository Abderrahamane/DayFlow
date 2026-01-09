const noteCreate = {
  body: {
    title: { required: true, type: "string" },
    content: { type: "string" },
    type: { type: "string", enum: ["text", "checklist", "richText"] },
    tags: { type: "object" },
    isPinned: { type: "boolean" },
    colorValue: { type: "number" },
    category: { type: "string" },
  },
};

const noteUpdate = {
  body: {
    title: { type: "string" },
    content: { type: "string" },
    type: { type: "string", enum: ["text", "checklist", "richText"] },
    tags: { type: "object" },
    isPinned: { type: "boolean" },
    colorValue: { type: "number" },
    category: { type: "string" },
    checklistItems: { type: "object" },
    attachments: { type: "object" },
  },
};

const noteLock = {
  body: {
    lockPin: { type: "string" },
    useBiometric: { type: "boolean" },
  },
};

module.exports = {
  noteCreate,
  noteUpdate,
  noteLock,
};
