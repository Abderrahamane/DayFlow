class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final bool isRead;
  final String? payload;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
    this.payload,
  });

  AppNotification copyWith({
    String? id,
    String? title,
    String? body,
    DateTime? timestamp,
    bool? isRead,
    String? payload,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      payload: payload ?? this.payload,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'payload': payload,
    };
  }

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] ?? false,
      payload: json['payload'],
    );
  }

  // Database serialization
  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'isRead': isRead ? 1 : 0,
      'payload': payload,
    };
  }

  factory AppNotification.fromDatabase(Map<String, dynamic> row) {
    return AppNotification(
      id: row['id'] as String,
      title: row['title'] as String,
      body: row['body'] as String,
      timestamp: DateTime.fromMillisecondsSinceEpoch(row['timestamp'] as int),
      isRead: (row['isRead'] as int) == 1,
      payload: row['payload'] as String?,
    );
  }

  // Firestore serialization
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'body': body,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'payload': payload,
    };
  }

  factory AppNotification.fromFirestore(
      Map<String, dynamic> data, String docId) {
    // Handle payload - could be String or Map
    String? payloadStr;
    final payloadData = data['payload'];
    if (payloadData is String) {
      payloadStr = payloadData;
    } else if (payloadData is Map) {
      payloadStr = payloadData.toString();
    }

    DateTime timestamp;
    final ts = data['timestamp'];
    if (ts is String) {
      timestamp = DateTime.parse(ts);
    } else if (ts != null && ts.toDate != null) {
      // Firestore Timestamp
      timestamp = ts.toDate();
    } else {
      timestamp = DateTime.now();
    }

    return AppNotification(
      id: docId,
      title: data['title']?.toString() ?? '',
      body: data['body']?.toString() ?? '',
      timestamp: timestamp,
      isRead: data['isRead'] == true,
      payload: payloadStr,
    );
  }
}
