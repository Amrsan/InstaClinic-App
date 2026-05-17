import 'dart:io';

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart' as path;
import '../services/image_service.dart';
import '../models/service.dart';

class ServicesController extends GetxController {
  final _supabase = Supabase.instance.client;
  final _imageService = Get.put(ImageService());
  final mainServices = <Service>[].obs;
  final clinicServices = <Service>[].obs;
  final extraServices = <Service>[].obs;
  final isLoading = false.obs;
  final isUploading = false.obs;
  final selectedImageName = ''.obs;
  Uint8List? _selectedImageBytes;
  String? _selectedImageType;
  RxList services = [].obs;
  final availableServices = <Service>[].obs;
  final isFetchingServices = false.obs;
  final selectedService = Rx<Service?>(null);
  @override
  void onInit() {
    super.onInit();
    _checkAndCreateBucket();
    fetchServices();
  }

  Future<void> _checkAndCreateBucket() async {
    try {
      // Check if user is authenticated before trying to create bucket
      final user = _supabase.auth.currentUser;
      if (user == null) {
        print('User not authenticated, skipping bucket creation');
        return;
      }

      final buckets = await _supabase.storage.listBuckets();
      final bucketExists =
          buckets.any((bucket) => bucket.id == 'service-images');
      
      if (!bucketExists) {
        print('Creating service-images bucket...');
        await _supabase.storage.createBucket(
          'service-images',
          const BucketOptions(
            public: true,
            fileSizeLimit: '5242880', // 5MB in bytes as string
          ),
        );
        print('Bucket created successfully');
      } else {
        print('Bucket already exists');
      }
    } catch (e) {
      print('Error checking/creating bucket: $e');
      // Don't throw the error, just log it to prevent app crashes
    }
  }

  Future<void> fetchServices() async {
    try {
      isLoading.value = true;
      final response = await _supabase
          .from('services')
          .select()
          .eq('is_active', true)
          .order('created_at', ascending: false);

      final allServices =
          (response as List).map((json) => Service.fromJson(json)).toList();

      mainServices.value = allServices
          .where((service) => service.category.toLowerCase() == 'primary')
          .toList();
      clinicServices.value = allServices
          .where((service) => service.category.toLowerCase() == 'clinic')
          .toList();
      extraServices.value = allServices
          .where((service) => service.category.toLowerCase() == 'extra')
          .toList();
    } catch (e) {
      print('Error fetching services: $e');
      Get.snackbar(
        'Error',
        'Failed to fetch services',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'svg'],
      );

      if (result != null) {
        if (kIsWeb) {
          _selectedImageBytes = result.files.first.bytes;
          _selectedImageType = result.files.first.extension;
          selectedImageName.value = result.files.first.name;
        } else {
          final file = File(result.files.first.path!);
          _selectedImageBytes = await file.readAsBytes();
          _selectedImageType =
              path.extension(file.path).toLowerCase().substring(1);
          selectedImageName.value = path.basename(file.path);
        }

        // Validate file type
        if (_selectedImageType != 'svg' && _selectedImageType != 'png') {
          Get.snackbar('Error', 'Please select an SVG or PNG file');
          _selectedImageBytes = null;
          _selectedImageType = null;
          selectedImageName.value = '';
          return;
        }

        // Check file size (5MB limit)
        if (_selectedImageBytes!.length > 5 * 1024 * 1024) {
          Get.snackbar('Error', 'Image size must be less than 5MB');
          _selectedImageBytes = null;
          _selectedImageType = null;
          selectedImageName.value = '';
          return;
        }
      }
    } catch (e) {
      print('Error picking image: $e');
      Get.snackbar('Error', 'Failed to pick image');
    }
  }

  Future<String?> _uploadImage() async {
    if (_selectedImageBytes == null || _selectedImageType == null) return null;

    isUploading.value = true;

    try {
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}.$_selectedImageType';
      final filePath = 'services/$fileName';

      await _supabase.storage.from('service-images').uploadBinary(
            filePath,
            _selectedImageBytes!,
            fileOptions: FileOptions(
              contentType:
                  _selectedImageType == 'svg' ? 'image/svg+xml' : 'image/png',
              upsert: true,
            ),
          );

      final imageUrl =
          _supabase.storage.from('service-images').getPublicUrl(filePath);
      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      if (e.toString().contains('storage/permission-denied')) {
        Get.snackbar(
            'Error', 'Permission denied. Please check your storage rules.');
      } else {
        Get.snackbar('Error', 'Failed to upload image');
      }
      return null;
    } finally {
      isUploading.value = false;
    }
  }

  Future<void> createService({
    required String name,
    required String category,
    String? description,
    required double price,
    required int durationMinutes,
  }) async {
    try {
      isLoading.value = true;
      await _supabase.from('services').insert({
        'name': name,
        'category': category,
        'description': description,
        'price': price,
        'duration_minutes': durationMinutes,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      await fetchServices();

      Get.snackbar(
        'Success',
        'Service created successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error creating service: $e');
      Get.snackbar(
        'Error',
        'Failed to create service',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteService(String id) async {
    try {
      isLoading.value = true;
      await _supabase.from('services').delete().eq('id', id);
      await fetchServices();

      Get.snackbar(
        'Success',
        'Service deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error deleting service: $e');
      Get.snackbar(
        'Error',
        'Failed to delete service',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<Service>> fetchClinics() async {
    try {
      final response = await _supabase
          .from('services')
          .select()
          .eq('category', 'clinic')
          .order('name');
      if (response == null) return [];
      return (response as List).map((data) => Service.fromJson(data)).toList();
    } catch (e) {
      print('Error fetching clinics: $e');
      return [];
    }
  }

  Future<List<Service>> fetchPrimaryServices() async {
    try {
      final response = await _supabase
          .from('services')
          .select()
          .eq('category', 'primary')
          .order('name');
      if (response == null) return [];

      // map JSON → Service
      final allServices =
          (response as List).map((json) => Service.fromJson(json)).toList();

      // dedupe by name: each map entry keeps the FIRST service with that name
      final uniqueMap = <String, Service>{};
      for (var s in allServices) {
        if (s.name != null && !uniqueMap.containsKey(s.name)) {
          uniqueMap[s.name!] = s;
        }
      }

      // return only one per name
      return uniqueMap.values.toList();
    } catch (e) {
      print('Error fetching primary: $e');
      return [];
    }
  } // Fetch services by name

  Future<void> fetchServicesByName(String name) async {
    try {
      isFetchingServices.value = true;
      final response = await Supabase.instance.client
          .from('services')
          .select()
          .eq('name', name)
          .order('price', ascending: true);
      availableServices.value =
          (response as List).map((json) => Service.fromJson(json)).toList();
      if (availableServices.isNotEmpty) {
        selectedService.value =
            availableServices.first; // Default to first service
      }
    } catch (e) {
      print('Error fetching services: $e');
    } finally {
      isFetchingServices.value = false;
    }
  }
}
