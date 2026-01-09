const asyncHandler = require("../utils/asyncHandler");
const admin = require("../config/firebase");

const bucket = admin.storage().bucket();
const ALLOWED_EXT = ["png", "jpg", "jpeg", "gif", "pdf", "txt", "doc", "docx"];
const MAX_SIZE_MB = 10; // client should enforce; backend validates on delete path scope only

const buildPath = (uid, filename) => {
  const safeName = filename.replace(/[^a-zA-Z0-9._-]/g, "_");
  return `users/${uid}/attachments/${Date.now()}-${safeName}`;
};

const isAllowedExt = (filename) => {
  const parts = filename.split(".");
  if (parts.length < 2) return false;
  const ext = parts.pop().toLowerCase();
  return ALLOWED_EXT.includes(ext);
};

exports.presignUpload = asyncHandler(async (req, res) => {
  const { filename, contentType } = req.body || {};
  if (!filename || !isAllowedExt(filename)) {
    return res.status(400).json({
      error: {
        code: "VALIDATION_ERROR",
        message: "Invalid filename",
        details: [{ field: "filename", message: "Filename is required and must have an allowed extension" }],
      },
    });
  }

  const path = buildPath(req.user.uid, filename);
  const expires = Date.now() + 15 * 60 * 1000;

  const [uploadUrl] = await bucket.file(path).getSignedUrl({
    version: "v4",
    action: "write",
    expires,
    contentType: contentType || "application/octet-stream",
  });

  const downloadUrl = `https://storage.googleapis.com/${bucket.name}/${path}`;

  return res.status(200).json({
    uploadUrl,
    downloadUrl,
    path,
    expiresAt: new Date(expires).toISOString(),
    maxSizeMB: MAX_SIZE_MB,
    allowedExtensions: ALLOWED_EXT,
  });
});

exports.deleteAttachment = asyncHandler(async (req, res) => {
  const { path, url } = req.body || {};
  const targetPath = path || (url ? url.split(`${bucket.name}/`)[1] : null);

  if (!targetPath) {
    return res.status(400).json({
      error: {
        code: "VALIDATION_ERROR",
        message: "path or url is required",
        details: [{ field: "path", message: "Provide path or url" }],
      },
    });
  }

  if (!targetPath.startsWith(`users/${req.user.uid}/attachments/`)) {
    return res.status(403).json({
      error: {
        code: "FORBIDDEN",
        message: "Cannot delete attachments outside your scope",
      },
    });
  }

  const file = bucket.file(targetPath);
  await file.delete({ ignoreNotFound: true });
  return res.status(204).send();
});
