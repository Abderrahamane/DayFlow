import 'dart:convert';
import 'package:flutter/material.dart';

/// Enhanced Note model with rich text, attachments, checklists, and security
class Note {
  final String id;
  String title;
  String content; // Now stores rich text as JSON/Delta format
  final DateTime createdAt;
  DateTime? updatedAt;
  final Color? color;
  final List<String>? tags;
  bool isPinned;
  final NoteType type;
  final List<NoteAttachment>? attachments;
  final List<ChecklistItem>? checklistItems;
  final bool isLocked;
  final String? lockPin; // Encrypted PIN if using PIN lock
  final bool useBiometric;
  final NoteCategory? category;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    this.color,
    this.tags,
    this.isPinned = false,
    this.type = NoteType.text,
    this.attachments,
    this.checklistItems,
    this.isLocked = false,
    this.lockPin,
    this.useBiometric = false,
    this.category,
  });

  Note copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    Color? color,
    List<String>? tags,
    bool? isPinned,
    NoteType? type,
    List<NoteAttachment>? attachments,
    List<ChecklistItem>? checklistItems,
    bool? isLocked,
    String? lockPin,
    bool? useBiometric,
    NoteCategory? category,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      color: color ?? this.color,
      tags: tags ?? this.tags,
      isPinned: isPinned ?? this.isPinned,
      type: type ?? this.type,
      attachments: attachments ?? this.attachments,
      checklistItems: checklistItems ?? this.checklistItems,
      isLocked: isLocked ?? this.isLocked,
      lockPin: lockPin ?? this.lockPin,
      useBiometric: useBiometric ?? this.useBiometric,
      category: category ?? this.category,
    );
  }

  /// Check if note has any attachments
  bool get hasAttachments => attachments != null && attachments!.isNotEmpty;
  int get attachmentCount => attachments?.length ?? 0;

  /// Check if note is a checklist
  bool get isChecklist => type == NoteType.checklist;

  /// Get checklist progress
  double get checklistProgress {
    if (checklistItems == null || checklistItems!.isEmpty) return 0;
    final completed = checklistItems!.where((item) => item.isChecked).length;
    return completed / checklistItems!.length;
  }

  /// Get completed checklist count
  int get completedChecklistCount =>
      checklistItems?.where((item) => item.isChecked).length ?? 0;

  /// Get total checklist count
  int get totalChecklistCount => checklistItems?.length ?? 0;

  /// Get images from attachments
  List<NoteAttachment> get images =>
      attachments?.where((a) => a.type == AttachmentType.image).toList() ?? [];

  /// Get files from attachments
  List<NoteAttachment> get files =>
      attachments?.where((a) => a.type != AttachmentType.image).toList() ?? [];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'colorValue': color?.value,
      'tags': tags,
      'isPinned': isPinned,
      'type': type.name,
      'attachments': attachments?.map((a) => a.toJson()).toList(),
      'checklistItems': checklistItems?.map((c) => c.toJson()).toList(),
      'isLocked': isLocked,
      'lockPin': lockPin,
      'useBiometric': useBiometric,
      'category': category?.name,
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      color: json['colorValue'] != null ? Color(json['colorValue']) : null,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      isPinned: json['isPinned'] ?? false,
      type: NoteType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => NoteType.text,
      ),
      attachments: json['attachments'] != null
          ? (json['attachments'] as List).map((a) => NoteAttachment.fromJson(a)).toList()
          : null,
      checklistItems: json['checklistItems'] != null
          ? (json['checklistItems'] as List).map((c) => ChecklistItem.fromJson(c)).toList()
          : null,
      isLocked: json['isLocked'] ?? false,
      lockPin: json['lockPin'],
      useBiometric: json['useBiometric'] ?? false,
      category: json['category'] != null
          ? NoteCategory.values.firstWhere(
              (c) => c.name == json['category'],
              orElse: () => NoteCategory.personal,
            )
          : null,
    );
  }

  // For database serialization
  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'colorValue': color?.value,
      'tagsJson': tags != null ? jsonEncode(tags) : null,
      'isPinned': isPinned ? 1 : 0,
      'type': type.index,
      'attachmentsJson': attachments != null
          ? jsonEncode(attachments!.map((a) => a.toJson()).toList())
          : null,
      'checklistJson': checklistItems != null
          ? jsonEncode(checklistItems!.map((c) => c.toJson()).toList())
          : null,
      'isLocked': isLocked ? 1 : 0,
      'lockPin': lockPin,
      'useBiometric': useBiometric ? 1 : 0,
      'category': category?.index,
    };
  }

  factory Note.fromDatabase(Map<String, dynamic> row) {
    return Note(
      id: row['id'] as String,
      title: row['title'] as String,
      content: row['content'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(row['createdAt'] as int),
      updatedAt: row['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(row['updatedAt'] as int)
          : null,
      color: row['colorValue'] != null ? Color(row['colorValue'] as int) : null,
      tags: row['tagsJson'] != null
          ? List<String>.from(jsonDecode(row['tagsJson'] as String))
          : null,
      isPinned: (row['isPinned'] as int?) == 1,
      type: row['type'] != null
          ? NoteType.values[row['type'] as int]
          : NoteType.text,
      attachments: row['attachmentsJson'] != null
          ? (jsonDecode(row['attachmentsJson'] as String) as List)
              .map((a) => NoteAttachment.fromJson(a))
              .toList()
          : null,
      checklistItems: row['checklistJson'] != null
          ? (jsonDecode(row['checklistJson'] as String) as List)
              .map((c) => ChecklistItem.fromJson(c))
              .toList()
          : null,
      isLocked: (row['isLocked'] as int?) == 1,
      lockPin: row['lockPin'] as String?,
      useBiometric: (row['useBiometric'] as int?) == 1,
      category: row['category'] != null
          ? NoteCategory.values[row['category'] as int]
          : null,
    );
  }

  // Firestore serialization
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'colorValue': color?.value,
      'tags': tags,
      'isPinned': isPinned,
      'type': type.name,
      'attachments': attachments?.map((a) => a.toJson()).toList(),
      'checklistItems': checklistItems?.map((c) => c.toJson()).toList(),
      'isLocked': isLocked,
      'lockPin': lockPin,
      'useBiometric': useBiometric,
      'category': category?.name,
    };
  }

  factory Note.fromFirestore(Map<String, dynamic> data, String docId) {
    return Note(
      id: docId,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'])
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? DateTime.parse(data['updatedAt'])
          : null,
      color: data['colorValue'] != null ? Color(data['colorValue']) : null,
      tags: data['tags'] != null ? List<String>.from(data['tags']) : null,
      isPinned: data['isPinned'] ?? false,
      type: NoteType.values.firstWhere(
        (t) => t.name == data['type'],
        orElse: () => NoteType.text,
      ),
      attachments: data['attachments'] != null
          ? (data['attachments'] as List)
              .map((a) => NoteAttachment.fromJson(a))
              .toList()
          : null,
      checklistItems: data['checklistItems'] != null
          ? (data['checklistItems'] as List)
              .map((c) => ChecklistItem.fromJson(c))
              .toList()
          : null,
      isLocked: data['isLocked'] ?? false,
      lockPin: data['lockPin'],
      useBiometric: data['useBiometric'] ?? false,
      category: data['category'] != null
          ? NoteCategory.values.firstWhere(
              (c) => c.name == data['category'],
              orElse: () => NoteCategory.personal,
            )
          : null,
    );
  }

  /// Get preview of content (first 100 characters)
  String get contentPreview {
    if (content.isEmpty) return '';
    // Strip any HTML/rich text for preview
    final plainText = content.replaceAll(RegExp(r'<[^>]*>'), '');
    if (plainText.length <= 100) return plainText;
    return '${plainText.substring(0, 100)}...';
  }

  /// Get formatted date string
  String get formattedDate {
    final date = updatedAt ?? createdAt;
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

/// Note type enum
enum NoteType {
  text,
  checklist,
  richText;

  String get displayName {
    switch (this) {
      case NoteType.text:
        return 'Text Note';
      case NoteType.checklist:
        return 'Checklist';
      case NoteType.richText:
        return 'Rich Text';
    }
  }

  IconData get icon {
    switch (this) {
      case NoteType.text:
        return Icons.note;
      case NoteType.checklist:
        return Icons.checklist;
      case NoteType.richText:
        return Icons.text_fields;
    }
  }
}

/// Note category for filtering
enum NoteCategory {
  work,
  study,
  personal,
  shopping,
  important,
  ideas,
  travel,
  health;

  String get displayName {
    switch (this) {
      case NoteCategory.work:
        return 'Work';
      case NoteCategory.study:
        return 'Study';
      case NoteCategory.personal:
        return 'Personal';
      case NoteCategory.shopping:
        return 'Shopping';
      case NoteCategory.important:
        return 'Important';
      case NoteCategory.ideas:
        return 'Ideas';
      case NoteCategory.travel:
        return 'Travel';
      case NoteCategory.health:
        return 'Health';
    }
  }

  String get icon {
    switch (this) {
      case NoteCategory.work:
        return '💼';
      case NoteCategory.study:
        return '📚';
      case NoteCategory.personal:
        return '👤';
      case NoteCategory.shopping:
        return '🛒';
      case NoteCategory.important:
        return '⭐';
      case NoteCategory.ideas:
        return '💡';
      case NoteCategory.travel:
        return '✈️';
      case NoteCategory.health:
        return '❤️';
    }
  }

  Color get color {
    switch (this) {
      case NoteCategory.work:
        return Colors.blue;
      case NoteCategory.study:
        return Colors.purple;
      case NoteCategory.personal:
        return Colors.teal;
      case NoteCategory.shopping:
        return Colors.orange;
      case NoteCategory.important:
        return Colors.red;
      case NoteCategory.ideas:
        return Colors.amber;
      case NoteCategory.travel:
        return Colors.cyan;
      case NoteCategory.health:
        return Colors.pink;
    }
  }
}

/// Attachment for notes
class NoteAttachment {
  final String id;
  final String noteId;
  final String name;
  final String url;
  final String? localPath;
  final AttachmentType type;
  final int? sizeBytes;
  final DateTime createdAt;
  final String? thumbnailUrl;

  NoteAttachment({
    required this.id,
    required this.noteId,
    required this.name,
    required this.url,
    this.localPath,
    required this.type,
    this.sizeBytes,
    required this.createdAt,
    this.thumbnailUrl,
  });

  NoteAttachment copyWith({
    String? id,
    String? noteId,
    String? name,
    String? url,
    String? localPath,
    AttachmentType? type,
    int? sizeBytes,
    DateTime? createdAt,
    String? thumbnailUrl,
  }) {
    return NoteAttachment(
      id: id ?? this.id,
      noteId: noteId ?? this.noteId,
      name: name ?? this.name,
      url: url ?? this.url,
      localPath: localPath ?? this.localPath,
      type: type ?? this.type,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      createdAt: createdAt ?? this.createdAt,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    );
  }

  String get formattedSize {
    if (sizeBytes == null) return '';
    if (sizeBytes! < 1024) return '$sizeBytes B';
    if (sizeBytes! < 1024 * 1024) return '${(sizeBytes! / 1024).toStringAsFixed(1)} KB';
    return '${(sizeBytes! / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'noteId': noteId,
      'name': name,
      'url': url,
      'localPath': localPath,
      'type': type.name,
      'sizeBytes': sizeBytes,
      'createdAt': createdAt.toIso8601String(),
      'thumbnailUrl': thumbnailUrl,
    };
  }

  factory NoteAttachment.fromJson(Map<String, dynamic> json) {
    return NoteAttachment(
      id: json['id'],
      noteId: json['noteId'],
      name: json['name'],
      url: json['url'],
      localPath: json['localPath'],
      type: AttachmentType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => AttachmentType.other,
      ),
      sizeBytes: json['sizeBytes'],
      createdAt: DateTime.parse(json['createdAt']),
      thumbnailUrl: json['thumbnailUrl'],
    );
  }
}

/// Attachment types
enum AttachmentType {
  image,
  pdf,
  document,
  other;

  String get displayName {
    switch (this) {
      case AttachmentType.image:
        return 'Image';
      case AttachmentType.pdf:
        return 'PDF';
      case AttachmentType.document:
        return 'Document';
      case AttachmentType.other:
        return 'File';
    }
  }

  IconData get icon {
    switch (this) {
      case AttachmentType.image:
        return Icons.image;
      case AttachmentType.pdf:
        return Icons.picture_as_pdf;
      case AttachmentType.document:
        return Icons.description;
      case AttachmentType.other:
        return Icons.attach_file;
    }
  }
}

/// Checklist item for checklist notes
class ChecklistItem {
  final String id;
  String text;
  bool isChecked;
  final int order;

  ChecklistItem({
    required this.id,
    required this.text,
    this.isChecked = false,
    this.order = 0,
  });

  ChecklistItem copyWith({
    String? id,
    String? text,
    bool? isChecked,
    int? order,
  }) {
    return ChecklistItem(
      id: id ?? this.id,
      text: text ?? this.text,
      isChecked: isChecked ?? this.isChecked,
      order: order ?? this.order,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isChecked': isChecked,
      'order': order,
    };
  }

  factory ChecklistItem.fromJson(Map<String, dynamic> json) {
    return ChecklistItem(
      id: json['id'],
      text: json['text'],
      isChecked: json['isChecked'] ?? false,
      order: json['order'] ?? 0,
    );
  }
}

/// Predefined note colors - Beautiful pastel and modern colors
class NoteColors {
  // Beautiful light pastel colors for notes
  static const List<Color> colors = [
    Color(0xFFFFFFFF), // White (default)
    Color(0xFFFFF8E1), // Warm Cream
    Color(0xFFFFECB3), // Soft Gold
    Color(0xFFFFE0B2), // Peach
    Color(0xFFFFCCBC), // Coral Light
    Color(0xFFF8BBD9), // Rose Pink
    Color(0xFFE1BEE7), // Lavender
    Color(0xFFD1C4E9), // Soft Purple
    Color(0xFFC5CAE9), // Periwinkle
    Color(0xFFBBDEFB), // Sky Blue
    Color(0xFFB2EBF2), // Aqua
    Color(0xFFB2DFDB), // Mint
    Color(0xFFC8E6C9), // Sage Green
    Color(0xFFDCEDC8), // Light Lime
    Color(0xFFF0F4C3), // Soft Yellow
    Color(0xFFD7CCC8), // Warm Taupe
  ];

  // Gradient colors for more visual appeal
  static const List<List<Color>> gradients = [
    [Color(0xFFFF9A9E), Color(0xFFFECFEF)], // Pink gradient
    [Color(0xFFA18CD1), Color(0xFFFBC2EB)], // Purple gradient
    [Color(0xFF667EEA), Color(0xFF764BA2)], // Indigo gradient
    [Color(0xFF11998E), Color(0xFF38EF7D)], // Green gradient
    [Color(0xFFFDC830), Color(0xFFF37335)], // Orange gradient
    [Color(0xFF00C6FB), Color(0xFF005BEA)], // Blue gradient
  ];

  // Dark mode colors
  static const List<Color> darkColors = [
    Color(0xFF1E1E1E), // Near Black
    Color(0xFF2D2D30), // Dark Grey
    Color(0xFF3E2723), // Dark Brown
    Color(0xFF1A237E), // Deep Indigo
    Color(0xFF311B92), // Deep Purple
    Color(0xFF880E4F), // Deep Pink
    Color(0xFF004D40), // Deep Teal
    Color(0xFF1B5E20), // Deep Green
    Color(0xFF0D47A1), // Deep Blue
    Color(0xFFBF360C), // Deep Orange
  ];

  // Named color presets with better names
  static const Map<String, Color> namedColors = {
    'Default': Color(0xFFFFFFFF),
    'Cream': Color(0xFFFFF8E1),
    'Peach': Color(0xFFFFE0B2),
    'Rose': Color(0xFFF8BBD9),
    'Lavender': Color(0xFFE1BEE7),
    'Sky': Color(0xFFBBDEFB),
    'Mint': Color(0xFFB2DFDB),
    'Sage': Color(0xFFC8E6C9),
    'Lemon': Color(0xFFF0F4C3),
    'Coral': Color(0xFFFFCCBC),
  };

  static Color getContrastText(Color backgroundColor) {
    // Calculate luminance for better contrast detection
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? const Color(0xFF1A1A1A) : Colors.white;
  }

  static Color getSecondaryText(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5
        ? const Color(0xFF1A1A1A).withAlpha(153)
        : Colors.white.withAlpha(179);
  }

  static Color getBorderColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5
        ? Colors.black.withAlpha(26)
        : Colors.white.withAlpha(51);
  }
}

