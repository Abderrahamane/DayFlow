import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirestoreService() {
    _firestore.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }

  String? get currentUserId => _auth.currentUser?.uid;

  // Collections
  CollectionReference get users => _firestore.collection('users');

  // User specific collections
  CollectionReference? get tasks {
    final uid = currentUserId;
    if (uid == null) return null;
    return users.doc(uid).collection('tasks');
  }

  CollectionReference? get habits {
    final uid = currentUserId;
    if (uid == null) return null;
    return users.doc(uid).collection('habits');
  }

  CollectionReference? get notes {
    final uid = currentUserId;
    if (uid == null) return null;
    return users.doc(uid).collection('notes');
  }

  CollectionReference? get pomodoroSessions {
    final uid = currentUserId;
    if (uid == null) return null;
    return users.doc(uid).collection('pomodoro_sessions');
  }

  CollectionReference? get templates {
    final uid = currentUserId;
    if (uid == null) return null;
    return users.doc(uid).collection('templates');
  }

  CollectionReference? get notifications {
    final uid = currentUserId;
    if (uid == null) return null;
    return users.doc(uid).collection('notifications');
  }
}
