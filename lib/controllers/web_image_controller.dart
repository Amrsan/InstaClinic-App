import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/image_service.dart';

class WebImageController extends GetxController {
  final ImageService _imageService = Get.find<ImageService>();
  final RxString selectedImageName = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString currentImageUrl = ''.obs;

  Future<void> pickAndUploadImage({
    required String bucketName,
    required String folderPath,
  }) async {
    try {
      isLoading.value = true;
      
      final String? imageUrl = await _imageService.pickAndUploadImage(
        bucketName: bucketName,
        folderPath: folderPath,
      );

      if (imageUrl != null) {
        currentImageUrl.value = imageUrl;
        Get.snackbar(
          'Success',
          'Image uploaded successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } on StorageException catch (e) {
      String errorMessage = 'Failed to upload image';
      if (e.message.contains('permission-denied')) {
        errorMessage = 'Permission denied. Please check your storage rules.';
      } else if (e.message.contains('bucket-not-found')) {
        errorMessage = 'Storage bucket not found. Please contact support.';
      }
      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to upload image: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteImage({
    required String bucketName,
    required String filePath,
  }) async {
    try {
      isLoading.value = true;
      await _imageService.deleteImage(
        bucketName: bucketName,
        filePath: filePath,
      );
      currentImageUrl.value = '';
      Get.snackbar(
        'Success',
        'Image deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } on StorageException catch (e) {
      String errorMessage = 'Failed to delete image';
      if (e.message.contains('permission-denied')) {
        errorMessage = 'Permission denied. Please check your storage rules.';
      } else if (e.message.contains('bucket-not-found')) {
        errorMessage = 'Storage bucket not found. Please contact support.';
      }
      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete image: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
} 