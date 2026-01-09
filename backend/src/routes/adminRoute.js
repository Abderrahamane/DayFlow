/**
 * Admin Routes
 * Protected routes for administrative actions
 * In production, add additional admin verification middleware
 */

const express = require('express');
const router = express.Router();
const scheduledNotifications = require('../services/scheduledNotifications');
const fcmService = require('../services/fcmService');

//Trigger holiday greeting check
router.post('/notifications/holiday-greeting', async (req, res, next) => {
    try {
        const result = await scheduledNotifications.sendHolidayGreetings();
        res.json(result);
    } catch (err) {
        next(err);
    }
});

//Trigger re-engagement notifications
router.post('/notifications/reengagement', async (req, res, next) => {
    try {
        const daysInactive = req.body.daysInactive || 30;
        const result =
            await scheduledNotifications.sendReengagementNotifications(
                daysInactive
            );
        res.json(result);
    } catch (err) {
        next(err);
    }
});

//Send announcement to all users
router.post('/notifications/announcement', async (req, res, next) => {
    try {
        const { title, body, data } = req.body;

        if (!title || !body) {
            return res
                .status(400)
                .json({ error: 'Title and body are required' });
        }

        const result = await scheduledNotifications.sendAnnouncement(
            title,
            body,
            data
        );
        res.json(result);
    } catch (err) {
        next(err);
    }
});

//Send push notification to a specific user
router.post('/notifications/send', async (req, res, next) => {
    try {
        const { uid, title, body, data } = req.body;

        if (!uid || !title || !body) {
            return res
                .status(400)
                .json({ error: 'uid, title, and body are required' });
        }

        const result = await fcmService.sendToUser(uid, { title, body, data });
        res.json(result);
    } catch (err) {
        next(err);
    }
});

//Get inactive users list
router.get('/users/inactive', async (req, res, next) => {
    try {
        const days = parseInt(req.query.days) || 30;
        const users = await fcmService.getInactiveUsers(days);

        res.json({
            count: users.length,
            daysInactive: days,
            users: users.map((u) => ({
                uid: u.uid,
                lastActive: u.lastActive?.toDate?.() || u.lastActive,
            })),
        });
    } catch (err) {
        next(err);
    }
});

module.exports = router;
