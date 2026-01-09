const express = require('express');
const router = express.Router();
const fcmController = require('../controllers/fcmController');

router.post('/token', fcmController.saveToken);

router.post('/activity', fcmController.updateActivity);

router.get('/preferences', fcmController.getPreferences);

router.put('/preferences', fcmController.updatePreferences);

module.exports = router;
