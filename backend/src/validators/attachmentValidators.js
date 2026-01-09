const presignUpload = {
  body: {
    filename: { required: true, type: "string" },
    contentType: { type: "string" },
  },
};

const deleteAttachment = {
  body: {
    path: { type: "string" },
    url: { type: "string" },
  },
};

module.exports = {
  presignUpload,
  deleteAttachment,
};
