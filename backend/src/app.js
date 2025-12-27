const express = require("express");
const cors = require("cors");

const app = express();

app.use(cors());
app.use(express.json());

//here add app.use() for all controllers
app.use("/api/health", require("./routes/healthRoute"));
app.use("/api/testFirebase", require("./routes/testFirebaseRoute"));
app.use("/api/secure", require("./routes/secureroutes"));

//last adding
app.use(require("./middlewares/error.middleware"));

module.exports = app;