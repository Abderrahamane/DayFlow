import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;
import '../models/task_model.dart';

class AttachmentService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final ImagePicker _imagePicker = ImagePicker();
  static const _uuid = Uuid();

  /// Pick image from camera
  static Future<File?> pickImageFromCamera() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    } catch (e) {
      print('Error picking image from camera: $e');
    }
    return null;
  }

  /// Pick image from gallery
  static Future<File?> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    } catch (e) {
      print('Error picking image from gallery: $e');
    }
    return null;
  }

  /// Pick multiple images from gallery
  static Future<List<File>> pickMultipleImages() async {
    try {
      final List<XFile> pickedFiles = await _imagePicker.pickMultiImage(
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );
      return pickedFiles.map((xfile) => File(xfile.path)).toList();
    } catch (e) {
      print('Error picking multiple images: $e');
    }
    return [];
  }

  /// Pick document/file
  static Future<File?> pickDocument() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'xls', 'xlsx', 'ppt', 'pptx'],
      );
      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
    } catch (e) {
      print('Error picking document: $e');
    }
    return null;
  }

  /// Pick any file
  static Future<File?> pickAnyFile() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
    } catch (e) {
      print('Error picking file: $e');
    }
    return null;
  }

  /// Upload file to Firebase Storage
  static Future<TaskAttachment?> uploadAttachment({
    required File file,
    required String taskId,
    required String userId,
  }) async {
    try {
      final fileName = path.basename(file.path);
      final extension = path.extension(file.path).toLowerCase();
      final attachmentId = _uuid.v4();

      // Determine file type
      AttachmentType type;
      if (['.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp'].contains(extension)) {
        type = AttachmentType.image;
      } else if (['.pdf', '.doc', '.docx', '.txt', '.xls', '.xlsx', '.ppt', '.pptx'].contains(extension)) {
        type = AttachmentType.document;
      } else {
        type = AttachmentType.other;
      }

      // Create storage path
      final storagePath = 'users/$userId/tasks/$taskId/attachments/$attachmentId$extension';
      final ref = _storage.ref().child(storagePath);

      // Upload file
      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return TaskAttachment(
        id: attachmentId,
        taskId: taskId,
        name: fileName,
        url: downloadUrl,
        type: type,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      print('Error uploading attachment: $e');
      return null;
    }
  }

  /// Delete attachment from Firebase Storage
  static Future<bool> deleteAttachment(TaskAttachment attachment) async {
    try {
      final ref = _storage.refFromURL(attachment.url);
      await ref.delete();
      return true;
    } catch (e) {
      print('Error deleting attachment: $e');
      return false;
    }
  }

  /// Get file size in readable format
  static String getFileSizeString(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}

