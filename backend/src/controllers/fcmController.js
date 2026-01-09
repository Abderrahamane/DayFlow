//Handles push notification token management and user preferences
const fcmService = require('../services/fcmService');

exports.saveToken = async (req, res, next) => {
    try {
        const { token } = req.body;
        const uid = req.user?.uid;

        if (!token) {
            return res.status(400).json({ error: 'Token is required' });
        }

        if (!uid) {
            return res.status(401).json({ error: 'User not authenticated' });
        }

        await fcmService.saveToken(uid, token);

        res.json({ success: true, message: 'Token saved successfully' });
    } catch (err) {
        next(err);
    }
};


exports.updateActivity = async (req, res, next) => {
    try {
        const uid = req.user?.uid;
        if (!uid) {
            return res.status(401).json({ error: 'User not authenticated' });
        }

        await fcmService.updateLastActive(uid);

        res.json({ success: true });
    } catch (err) {
        next(err);
    }
};

exports.getPreferences = async (req, res, next) => {
    try {
        const uid = req.user?.uid;
        if (!uid) {
            return res.status(401).json({ error: 'User not authenticated' });
        }

        const preferences = await fcmService.getPreferences(uid);

        res.json(preferences);
    } catch (err) {
        next(err);
    }
};

exports.updatePreferences = async (req, res, next) => {
    try {
        const uid = req.user?.uid;
        if (!uid) {
            return res.status(401).json({ error: 'User not authenticated' });
        }

        const { holidayGreetings, reEngagement, appUpdates } = req.body;

        const updated = await fcmService.updatePreferences(uid, {
            holidayGreetings,
            reEngagement,
            appUpdates,
        });

        res.json(updated);
    } catch (err) {
        next(err);
    }
};
