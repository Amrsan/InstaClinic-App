import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/foundation.dart' show kIsWeb;

class ImageService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<String?> pickAndUploadImage({
    required String bucketName,
    required String folderPath,
    ImageSource source =
        ImageSource.gallery, // Kept for compatibility, though not used directly
  }) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg', 'svg'],
      );

      if (result == null) return null;

      Uint8List bytes;
      String fileExtension;

      if (kIsWeb) {
        bytes = result.files.first.bytes!;
        fileExtension = result.files.first.extension!.toLowerCase();
      } else {
        final file = File(result.files.first.path!);
        bytes = await file.readAsBytes();
        fileExtension = path.extension(file.path).toLowerCase().substring(1);
      }

      // Validate file type
      if (!['png', 'jpg', 'jpeg', 'svg'].contains(fileExtension)) {
        throw Exception(
            'Invalid file type. Only PNG, JPG, JPEG, and SVG files are allowed.');
      }

      // Generate unique filename
      final String fileName =
          '${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
      final String filePath = '$folderPath/$fileName';

      // Upload to Supabase Storage
      await _supabase.storage.from(bucketName).uploadBinary(filePath, bytes);

      // Get public URL
      final String publicUrl =
          _supabase.storage.from(bucketName).getPublicUrl(filePath);
      return publicUrl;
    } catch (e) {
      debugPrint('Error uploading image: $e');
      rethrow;
    }
  }

  Future<void> deleteImage({
    required String bucketName,
    required String filePath,
  }) async {
    try {
      await _supabase.storage.from(bucketName).remove([filePath]);
    } catch (e) {
      debugPrint('Error deleting image: $e');
      rethrow;
    }
  }
}
