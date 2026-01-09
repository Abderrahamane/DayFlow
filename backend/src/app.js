const express = require("express");
const cors = require("cors");

const app = express();

app.use(cors());
app.use(express.json());

//here add app.use() for all controllers
app.use("/api/health", require("./routes/healthRoute"));
app.use("/api/testFirebase", require("./routes/testFirebaseRoute"));
app.use("/api/secure", require("./routes/secureroutes"));
app.use("/api/user", require("./routes/userRoute"));
app.use("/api/tasks", require("./routes/tasksRoute"));
app.use("/api/habits", require("./routes/habitsRoute"));
app.use("/api/notes", require("./routes/notesRoute"));
app.use("/api/notifications", require("./routes/notificationsRoute"));
app.use("/api/attachments", require("./routes/attachmentsRoute"));
app.use("/api/reminders", require("./routes/remindersRoute"));
app.use("/api/fcm", require("./middlewares/auth.middleware"), require("./routes/fcm"));
app.use("/api/admin", require("./middlewares/auth.middleware"), require("./routes/adminRoute"));

//last adding
app.use(require("./middlewares/error.middleware"));

module.exports = app;