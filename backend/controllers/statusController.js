// backend/controllers/statusController.js
// Controller for status endpoint

const mongoose = require('mongoose');

/**
 * Get server status
 * GET /api/status
 */
exports.getStatus = (req, res) => {
  const dbStatus = mongoose.connection.readyState === 1 ? 'connected' : 'disconnected';
  
  res.json({
    ok: true,
    message: 'DayFlow backend is running',
    timestamp: new Date().toISOString(),
    database: {
      status: dbStatus,
      name: mongoose.connection.name
    },
    environment: process.env.NODE_ENV || 'development'
  });
};
