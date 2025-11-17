// backend/routes/status.js
// Status route to check if server is running

const express = require('express');
const router = express.Router();
const statusController = require('../controllers/statusController');

// GET /api/status
router.get('/status', statusController.getStatus);

module.exports = router;
