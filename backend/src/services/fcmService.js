const admin = require('firebase-admin');
const crypto = require('crypto');
const db = admin.firestore();

//Generate a short hash of the FCM token for use as document ID
function hashToken(token) {
    return crypto.createHash('sha256').update(token).digest('hex').substring(0, 20);
}

//Save or update FCM token for a user
exports.saveToken = async (uid, token) => {
    if (!uid || !token) {
        throw new Error('uid and token are required');
    }

    const userRef = db.collection('users').doc(uid);
    const tokenId = hashToken(token);
    const tokensRef = userRef.collection('fcmTokens').doc(tokenId);

    await tokensRef.set({
        token,
        tokenId,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        lastUsed: admin.firestore.FieldValue.serverTimestamp(),
        active: true,
    });

    await userRef.set(
        {
            lastActive: admin.firestore.FieldValue.serverTimestamp(),
        },
        { merge: true }
    );

    return { success: true };
};

//Update user's last activity timestamp
exports.updateLastActive = async (uid) => {
    const userRef = db.collection('users').doc(uid);

    await userRef.set(
        {
            lastActive: admin.firestore.FieldValue.serverTimestamp(),
        },
        { merge: true }
    );

    return { success: true };
};

//Get user's notification preferences
exports.getPreferences = async (uid) => {
    const userRef = db.collection('users').doc(uid);
    const doc = await userRef.get();

    const data = doc.data() || {};

    // Return preferences with defaults
    return {
        holidayGreetings: data.notificationPrefs?.holidayGreetings ?? true,
        reEngagement: data.notificationPrefs?.reEngagement ?? true,
        appUpdates: data.notificationPrefs?.appUpdates ?? true,
    };
};

//Update user's notification preferences
exports.updatePreferences = async (uid, preferences) => {
    const userRef = db.collection('users').doc(uid);

    const updateData = {};
    if (preferences.holidayGreetings !== undefined) {
        updateData['notificationPrefs.holidayGreetings'] =
            preferences.holidayGreetings;
    }
    if (preferences.reEngagement !== undefined) {
        updateData['notificationPrefs.reEngagement'] = preferences.reEngagement;
    }
    if (preferences.appUpdates !== undefined) {
        updateData['notificationPrefs.appUpdates'] = preferences.appUpdates;
    }

    await userRef.set(updateData, { merge: true });

    return this.getPreferences(uid);
};

//Get all active FCM tokens for a user
exports.getUserTokens = async (uid) => {
    const tokensRef = db
        .collection('users')
        .doc(uid)
        .collection('fcmTokens')
        .where('active', '==', true);

    const snapshot = await tokensRef.get();
    return snapshot.docs.map((doc) => doc.data().token);
};

//Send push notification to a specific user
exports.sendToUser = async (uid, notification) => {
    const tokens = await this.getUserTokens(uid);

    if (tokens.length === 0) {
        console.log(`No FCM tokens found for user ${uid}`);
        return { success: false, reason: 'No tokens' };
    }

    const message = {
        notification: {
            title: notification.title,
            body: notification.body,
        },
        data: notification.data || {},
        tokens: tokens,
    };

    try {
        const response = await admin.messaging().sendEachForMulticast(message);

        // Handle failed tokens (unregistered devices)
        if (response.failureCount > 0) {
            const failedTokens = [];
            response.responses.forEach((resp, idx) => {
                if (!resp.success) {
                    failedTokens.push(tokens[idx]);
                }
            });

            // Mark failed tokens as inactive
            for (const token of failedTokens) {
                await db
                    .collection('users')
                    .doc(uid)
                    .collection('fcmTokens')
                    .doc(token)
                    .update({ active: false });
            }
        }

        return {
            success: true,
            successCount: response.successCount,
            failureCount: response.failureCount,
        };
    } catch (err) {
        console.error('Error sending FCM notification:', err);
        return { success: false, error: err.message };
    }
};

//Send push notification to a topic (for broadcast messages)
exports.sendToTopic = async (topic, notification) => {
    const message = {
        notification: {
            title: notification.title,
            body: notification.body,
        },
        data: notification.data || {},
        topic: topic,
    };

    try {
        const response = await admin.messaging().send(message);
        return { success: true, messageId: response };
    } catch (err) {
        console.error('Error sending FCM to topic:', err);
        return { success: false, error: err.message };
    }
};

//Get users who haven't been active for a specified number of days
exports.getInactiveUsers = async (daysInactive = 30) => {
    const cutoffDate = new Date();
    cutoffDate.setDate(cutoffDate.getDate() - daysInactive);

    const usersRef = db
        .collection('users')
        .where('lastActive', '<', cutoffDate)
        .where('notificationPrefs.reEngagement', '==', true);

    const snapshot = await usersRef.get();
    return snapshot.docs.map((doc) => ({
        uid: doc.id,
        ...doc.data(),
    }));
};

//Get users who have opted in for holiday greetings
exports.getHolidayGreetingUsers = async () => {
    const usersRef = db
        .collection('users')
        .where('notificationPrefs.holidayGreetings', '==', true);

    const snapshot = await usersRef.get();
    return snapshot.docs.map((doc) => ({
        uid: doc.id,
        ...doc.data(),
    }));
};
