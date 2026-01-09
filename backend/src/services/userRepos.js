const { randomUUID } = require("crypto");
const admin = require("../config/firebase");
const { getUserCollection, db, withId } = require("../utils/firestoreCollections");

const userCollection = (uid, col) => getUserCollection(uid, col);

const preserveCreatedAt = async (docRef, incoming) => {
  if (incoming.createdAt) return incoming.createdAt;
  const snap = await docRef.get();
  if (snap.exists && snap.data().createdAt) return snap.data().createdAt;
  return new Date().toISOString();
};

const tasksRepo = {
  async list(uid) {
    const snapshot = await userCollection(uid, "tasks")
      .orderBy("createdAt", "desc")
      .get();
    return snapshot.docs.map(withId);
  },

  async upsert(uid, id, data = {}) {
    const taskId = id || randomUUID();
    const docRef = userCollection(uid, "tasks").doc(taskId);
    const createdAt = await preserveCreatedAt(docRef, data);
    const payload = { ...data, createdAt };
    await docRef.set(payload, { merge: true });
    const saved = await docRef.get();
    return withId(saved);
  },

  async delete(uid, id) {
    const docRef = userCollection(uid, "tasks").doc(id);
    const snap = await docRef.get();
    if (!snap.exists) return false;
    await docRef.delete();
    return true;
  },

  async toggleComplete(uid, id) {
    const docRef = userCollection(uid, "tasks").doc(id);

    const result = await db.runTransaction(async (tx) => {
      const snap = await tx.get(docRef);
      if (!snap.exists) throw new Error("not-found");
      const data = snap.data();
      const newStatus = !(data.isCompleted ?? false);
      tx.update(docRef, { isCompleted: newStatus });
      return { id, ...data, isCompleted: newStatus };
    }).catch((err) => {
      if (err.message === "not-found") return null;
      throw err;
    });

    return result;
  },

  async toggleSubtask(uid, taskId, subtaskId) {
    const docRef = userCollection(uid, "tasks").doc(taskId);

    const result = await db.runTransaction(async (tx) => {
      const snap = await tx.get(docRef);
      if (!snap.exists) throw new Error("task-not-found");

      const data = snap.data();
      const subtasks = Array.isArray(data.subtasks) ? [...data.subtasks] : [];
      const index = subtasks.findIndex((s) => s.id === subtaskId);
      if (index === -1) throw new Error("subtask-not-found");

      const current = subtasks[index];
      const updatedSubtask = { ...current, isCompleted: !current.isCompleted };
      subtasks[index] = updatedSubtask;

      tx.update(docRef, { subtasks });

      return { id: taskId, ...data, subtasks, toggledSubtask: updatedSubtask };
    }).catch((err) => {
      if (err.message === "task-not-found") return { error: "task" };
      if (err.message === "subtask-not-found") return { error: "subtask" };
      throw err;
    });

    return result;
  },
};

const habitsRepo = {
  async list(uid) {
    const snapshot = await userCollection(uid, "habits")
      .orderBy("createdAt", "desc")
      .get();
    return snapshot.docs.map(withId);
  },

  async upsert(uid, id, data = {}) {
    const habitId = id || randomUUID();
    const docRef = userCollection(uid, "habits").doc(habitId);
    const createdAt = await preserveCreatedAt(docRef, data);
    const payload = {
      completionHistory: data.completionHistory || {},
      ...data,
      createdAt,
    };
    await docRef.set(payload, { merge: true });
    const saved = await docRef.get();
    return withId(saved);
  },

  async delete(uid, id) {
    const docRef = userCollection(uid, "habits").doc(id);
    const snap = await docRef.get();
    if (!snap.exists) return false;
    await docRef.delete();
    return true;
  },

  async toggleCompletion(uid, habitId, dateKey) {
    const docRef = userCollection(uid, "habits").doc(habitId);

    const result = await db.runTransaction(async (tx) => {
      const snap = await tx.get(docRef);
      if (!snap.exists) throw new Error("habit-not-found");

      const data = snap.data();
      const history = { ...(data.completionHistory || {}) };
      const newValue = !(history[dateKey] === true);
      history[dateKey] = newValue;

      tx.update(docRef, { completionHistory: history });

      return { id: habitId, ...data, completionHistory: history, toggledDate: dateKey, value: newValue };
    }).catch((err) => {
      if (err.message === "habit-not-found") return null;
      throw err;
    });

    return result;
  },
};

const notesRepo = {
  async list(uid, { tag, category } = {}) {
    let query = userCollection(uid, "notes");
    if (tag) query = query.where("tags", "array-contains", tag);
    if (category) query = query.where("category", "==", category);

    const snapshot = await query
      .orderBy("isPinned", "desc")
      .orderBy("updatedAt", "desc")
      .get();

    return snapshot.docs.map(withId);
  },

  async upsert(uid, id, data = {}) {
    const noteId = id || randomUUID();
    const docRef = userCollection(uid, "notes").doc(noteId);
    const createdAt = await preserveCreatedAt(docRef, data);
    const payload = {
      isPinned: data.isPinned ?? false,
      isLocked: data.isLocked ?? false,
      useBiometric: data.useBiometric ?? false,
      ...data,
      createdAt,
      updatedAt: data.updatedAt || data.createdAt || new Date().toISOString(),
    };
    await docRef.set(payload, { merge: true });
    const saved = await docRef.get();
    return withId(saved);
  },

  async delete(uid, id) {
    const docRef = userCollection(uid, "notes").doc(id);
    const snap = await docRef.get();
    if (!snap.exists) return false;
    await docRef.delete();
    return true;
  },

  async togglePin(uid, id) {
    const docRef = userCollection(uid, "notes").doc(id);

    const result = await db.runTransaction(async (tx) => {
      const snap = await tx.get(docRef);
      if (!snap.exists) throw new Error("note-not-found");

      const data = snap.data();
      const newStatus = !(data.isPinned ?? false);
      tx.update(docRef, { isPinned: newStatus });

      return { id, ...data, isPinned: newStatus };
    }).catch((err) => {
      if (err.message === "note-not-found") return null;
      throw err;
    });

    return result;
  },

  async lock(uid, id, { lockPin, useBiometric }) {
    const docRef = userCollection(uid, "notes").doc(id);
    const snap = await docRef.get();
    if (!snap.exists) return null;

    await docRef.set(
      {
        isLocked: true,
        lockPin: lockPin || null,
        useBiometric: useBiometric ?? false,
      },
      { merge: true }
    );

    const updated = await docRef.get();
    return withId(updated);
  },

  async unlock(uid, id) {
    const docRef = userCollection(uid, "notes").doc(id);
    const snap = await docRef.get();
    if (!snap.exists) return null;

    await docRef.set(
      {
        isLocked: false,
        lockPin: null,
        useBiometric: false,
      },
      { merge: true }
    );

    const updated = await docRef.get();
    return withId(updated);
  },
};

const notificationsRepo = {
  async list(uid, { limit = 20, cursor } = {}) {
    let query = userCollection(uid, "notifications")
      .orderBy("timestamp", "desc")
      .limit(Math.min(limit, 100));

    if (cursor) {
      query = query.startAfter(cursor);
    }

    const snapshot = await query.get();
    const notifications = snapshot.docs.map(withId);
    const nextCursor =
      notifications.length === Math.min(limit, 100)
        ? notifications[notifications.length - 1].timestamp
        : null;

    return { notifications, nextCursor };
  },

  async upsert(uid, id, data = {}) {
    const notificationId = id || randomUUID();
    const docRef = userCollection(uid, "notifications").doc(notificationId);
    const payload = {
      title: data.title,
      body: data.body,
      timestamp: data.timestamp || new Date().toISOString(),
      isRead: data.isRead ?? false,
      payload: data.payload || null,
    };
    await docRef.set(payload, { merge: true });
    const saved = await docRef.get();
    return withId(saved);
  },

  async markRead(uid, id) {
    const docRef = userCollection(uid, "notifications").doc(id);
    const snap = await docRef.get();
    if (!snap.exists) return null;
    await docRef.set({ isRead: true }, { merge: true });
    const updated = await docRef.get();
    return withId(updated);
  },

  async markAllRead(uid) {
    const snapshot = await userCollection(uid, "notifications")
      .where("isRead", "==", false)
      .get();

    const batch = db.batch();
    snapshot.docs.forEach((doc) => {
      batch.update(doc.ref, { isRead: true });
    });

    await batch.commit();
    return snapshot.size;
  },

  async delete(uid, id) {
    const docRef = userCollection(uid, "notifications").doc(id);
    const snap = await docRef.get();
    if (!snap.exists) return false;
    await docRef.delete();
    return true;
  },

  async getUnreadCount(uid) {
    const snapshot = await userCollection(uid, "notifications")
      .where("isRead", "==", false)
      .count()
      .get();

    return snapshot.data().count;
  },
};

module.exports = {
  tasksRepo,
  habitsRepo,
  notesRepo,
  notificationsRepo,
};
