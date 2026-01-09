const fcmService = require('./fcmService');

const HOLIDAYS = [
    {
        name: 'new_year',
        month: 1,
        day: 1,
        title: '🎉 سنة جديدة سعيدة',
        body: 'نتمنّالك سنة عامرة بالنجاح والإنتاجية. مع DayFlow، نظّم وقتك وحقّق أهدافك.',
    },
    {
        name: 'yennayer',
        month: 1,
        day: 12,
        title: '🌾 يناير سعيد',
        body: 'يناير مبارك! نتمنّالك سنة أمازيغية مليانة خير وبركة.',
    },
    {
        name: 'ramadan_start',
        // changing every year
        month: 2,
        day: 17,
        title: '🌙 رمضان مبارك',
        body: 'رمضان كريم، جعله الله شهر خير وبركة عليك. DayFlow يعاونك تنظّم وقتك في هذا الشهر الفضيل.',
    },
    {
        name: 'eid_fitr',
        // changing every year
        month: 3,
        day: 19,
        title: '🎊 عيد الفطر المبارك',
        body: 'تقبّل الله منا ومنكم الصيام والقيام. عيدك مبارك وإن شاء الله يكون مليان فرحة وراحة.',
    },
    {
        name: 'eid_adha',
        // changing every year
        month: 5,
        day: 26,
        title: '🐑 عيد الأضحى المبارك',
        body: 'عيدكم مبارك، ربي يتقبّل طاعاتكم ويجعله عيد خير وسعادة عليكم.',
    },
    {
        name: 'independence_day',
        month: 7,
        day: 5,
        title: '🇩🇿 عيد الاستقلال',
        body: 'تحيا الجزائر! نهار تاريخي نفخروا فيه باستقلال بلادنا الغالية.',
    },
    {
        name: 'ashura',
        // changing every year
        month: 7,
        day: 6,
        title: '🕌 يوم عاشوراء',
        body: 'يوم مبارك، صيامه فيه أجر كبير وتكفير لذنوب سنة بإذن الله.',
    },
    {
        name: 'revolution_day',
        month: 11,
        day: 1,
        title: '🇩🇿 عيد الثورة',
        body: 'المجد والخلود لشهدائنا الأبرار. نهار عظيم في تاريخ الجزائر.',
    },
    {
        name: 'prophet_birthday',
        // changing every year
        month: 9,
        day: 15,
        title: '🌸 المولد النبوي الشريف',
        body: 'صلّى الله عليه وسلم. يوم مبارك مليان ذكر وبركة.',
    },
    {
        name: 'year_end',
        month: 12,
        day: 31,
        title: '✨ نهاية السنة',
        body: 'سنة جديدة راهي قريبة! راجع وش حقّقت ووجد أهدافك للسنة الجاية.',
    },
];

const REENGAGEMENT_MESSAGES = [
    {
        title: '👋 وحشتنا!',
        body: 'راكم غايب شوية! مهامك ما زالهم مستنيينك. يلا نرجعوا للروتين المليح.',
    },
    {
        title: '🎯 جاهز ترجع للنشاط؟',
        body: 'العادات المليحة تبدأ بخطوة صغيرة. افتح DayFlow ودير غير مهمة وحدة اليوم!',
    },
    {
        title: '💪 ما تقطعش السلسلة!',
        body: 'الاستمرارية هي السر. رجع وكمل تبني عادات مليحة يوم بعد يوم.',
    },
    {
        title: '📝 أهدافك ما زالت هنا',
        body: 'الدنيا تشغّل، بصح أحلامك تستاهل. يلا نخططوا للخطوة الجاية!',
    },
];

exports.sendHolidayGreetings = async () => {
    const today = new Date();
    const month = today.getMonth() + 1;
    const day = today.getDate();

    const holiday = HOLIDAYS.find((h) => h.month === month && h.day === day);

    if (!holiday) {
        console.log('No holiday today');
        return { sent: false, reason: 'No holiday today' };
    }

    console.log(`Sending ${holiday.name} greetings...`);

    const topicResult = await fcmService.sendToTopic('holidays', {
        title: holiday.title,
        body: holiday.body,
        data: {
            type: 'holiday_greeting',
            holiday: holiday.name,
        },
    });

    return { sent: true, holiday: holiday.name, result: topicResult };
};

/**
 * @param {number} daysInactive - Number of days of inactivity to trigger
 */
exports.sendReengagementNotifications = async (daysInactive = 30) => {
    console.log(`Finding users inactive for ${daysInactive} days...`);

    const inactiveUsers = await fcmService.getInactiveUsers(daysInactive);

    console.log(`Found ${inactiveUsers.length} inactive users`);

    if (inactiveUsers.length === 0) {
        return { sent: 0, total: 0 };
    }

    // Pick a random message
    const message =
        REENGAGEMENT_MESSAGES[
            Math.floor(Math.random() * REENGAGEMENT_MESSAGES.length)
        ];

    let successCount = 0;

    for (const user of inactiveUsers) {
        const result = await fcmService.sendToUser(user.uid, {
            title: message.title,
            body: message.body,
            data: {
                type: 'engagement',
                reason: 'inactive',
            },
        });

        if (result.success) {
            successCount++;
        }
    }

    return { sent: successCount, total: inactiveUsers.length };
};

/**
 * @param {string} title - Notification title
 * @param {string} body - Notification body
 * @param {object} data - Additional data payload
 */
exports.sendAnnouncement = async (title, body, data = {}) => {
    const result = await fcmService.sendToTopic('announcements', {
        title,
        body,
        data: {
            type: 'announcement',
            ...data,
        },
    });

    return result;
};

exports.scheduleInfo = {
    holidayGreetings: {
        description: 'Send holiday greetings',
        cron: '0 9 * * *',
        handler: 'sendHolidayGreetings',
    },
    reengagement7Days: {
        description: 'Re-engage users inactive for 7 days',
        cron: '0 18 * * *',
        handler: 'sendReengagementNotifications',
        args: [7],
    },
    reengagement30Days: {
        description: 'Re-engage users inactive for 30 days',
        cron: '0 10 * * 0',
        handler: 'sendReengagementNotifications',
        args: [30],
    },
};
