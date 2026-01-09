require('dotenv').config();
const app = require("./app")

const PORT = process.env.PORT || 3000;
const HOST = process.env.HOST || '0.0.0.0'; // Bind to all interfaces for mobile access

app.listen(PORT, HOST, () => {
    console.log(`### Backend running on http://${HOST}:${PORT}`)
    console.log(`### For mobile devices, use your PC's IP address`)
});
