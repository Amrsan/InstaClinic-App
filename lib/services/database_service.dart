import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../models/models.dart';

class DatabaseService extends GetxService {
  final supabase.SupabaseClient _supabase = supabase.Supabase.instance.client;

  // Fetch user profile
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final response =
          await _supabase.from('profiles').select().eq('id', userId).single();
      return response;
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }

  // Update user profile
  Future<bool> updateUserProfile(
      String userId, Map<String, dynamic> data) async {
    try {
      await _supabase.from('profiles').update(data).eq('id', userId);
      return true;
    } catch (e) {
      print('Error updating user profile: $e');
      return false;
    }
  }

  // Create booking
Future<Map<String, dynamic>> createBooking(
    Map<String, dynamic> bookingData,
  ) async {
  print('Creating booking with data: $bookingData');
  final response = await _supabase
      .from('bookings')
      .insert(bookingData)     // you can also do .insert([bookingData])
      .select()
      .single();
  print('Booking created: $response');
  return response;
}
  // Get user bookings
  Future<List<Map<String, dynamic>>> getUserBookings(String userId) async {
    try {
      final response = await _supabase
          .from('bookings')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching user bookings: $e');
      return [];
    }
  }

  // Get available services
  Future<List<Map<String, dynamic>>> getAvailableServices() async {
    try {
      final response = await _supabase.from('services').select().order('name');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching services: $e');
      return [];
    }
  }

  // ADDRESSES
  Future<List<Address>> getUserAddresses() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final response =
          await _supabase.from('addresses').select().eq('user_id', userId);

      return response
          .map<Address>(
              (data) => Address.fromJson(data as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting user addresses: $e');
      return [];
    }
  }

  Future<void> saveAddress(Map<String, dynamic> addressData) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      addressData['user_id'] = userId;

      if (addressData['is_default'] == true) {
        // Set all other addresses to not default
        final response =
            await _supabase.from('addresses').select().eq('user_id', userId);
        for (var data in response) {
          if (data['id'] != addressData['id']) {
            await _supabase
                .from('addresses')
                .update({'is_default': false}).eq('id', data['id']);
          }
        }
      }

      // Check if address has ID (update) or not (insert)
      if (addressData.containsKey('id') && addressData['id'] != null) {
        await _supabase
            .from('addresses')
            .update(addressData)
            .eq('id', addressData['id']);
      } else {
        await _supabase.from('addresses').insert(addressData);
      }
    } catch (e) {
      print('Error saving address: $e');
      throw e;
    }
  }

  Future<void> deleteAddress(String addressId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      await _supabase.from('addresses').delete().eq('id', addressId);
    } catch (e) {
      print('Error deleting address: $e');
      throw e;
    }
  }

  // SERVICES
  Future<List<Service>> getServices({String? category}) async {
    try {
      final response = await _supabase.from('services').select().order('name');
      return response
          .map<Service>(
              (data) => Service.fromJson(data as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting services: $e');
      return [];
    }
  }

  Future<Service?> getServiceById(String serviceId) async {
    try {
      final response = await _supabase
          .from('services')
          .select()
          .eq('id', serviceId)
          .single();

      return Service.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      print('Error getting service by ID: $e');
      return null;
    }
  }

  // MEDICAL PROVIDERS
  Future<List<MedicalProvider>> getProviders(
      {String specialization = ''}) async {
    try {
      final response = specialization.isEmpty
          ? await _supabase.from('medical_providers').select()
          : await _supabase
              .from('medical_providers')
              .select()
              .eq('specialization', specialization);

      return response
          .map<MedicalProvider>(
              (data) => MedicalProvider.fromJson(data as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting medical providers: $e');
      return [];
    }
  }

  Future<MedicalProvider?> getProviderById(String providerId) async {
    try {
      final response = await _supabase
          .from('medical_providers')
          .select()
          .eq('id', providerId)
          .single();

      return MedicalProvider.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      print('Error getting provider by ID: $e');
      return null;
    }
  }

  // PAYMENTS
  Future<String> createPayment(Map<String, dynamic> paymentData) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      paymentData['user_id'] = userId;

      final response = await _supabase
          .from('payments')
          .insert(paymentData)
          .select()
          .single();

      return response['id'];
    } catch (e) {
      print('Error creating payment: $e');
      throw e;
    }
  }

  Future<List<Payment>> getUserPayments() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final response =
          await _supabase.from('payments').select().eq('user_id', userId);

      return response
          .map<Payment>(
              (data) => Payment.fromJson(data as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting user payments: $e');
      return [];
    }
  }

  // REVIEWS
  Future<void> submitReview(Map<String, dynamic> reviewData) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      reviewData['user_id'] = userId;

      await _supabase.from('reviews').insert(reviewData);
    } catch (e) {
      print('Error submitting review: $e');
      throw e;
    }
  }

  Future<List<Review>> getProviderReviews(String providerId) async {
    try {
      final response = await _supabase
          .from('reviews')
          .select()
          .eq('provider_id', providerId);

      return response
          .map<Review>((data) => Review.fromJson(data as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting provider reviews: $e');
      return [];
    }
  }

  Future<List<Review>> getServiceReviews(String serviceId) async {
    try {
      final response =
          await _supabase.from('reviews').select().eq('service_id', serviceId);

      return response
          .map<Review>((data) => Review.fromJson(data as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting service reviews: $e');
      return [];
    }
  }

  // Update service image
  Future<bool> updateServiceImage({
    required String serviceId,
    required String imageUrl,
  }) async {
    try {
      await _supabase
          .from('services')
          .update({'image_url': imageUrl}).eq('id', serviceId);
      return true;
    } catch (e) {
      print('Error updating service image: $e');
      return false;
    }
  }

  // Update provider image
  Future<bool> updateProviderImage({
    required String providerId,
    required String imageUrl,
  }) async {
    try {
      await _supabase
          .from('medical_providers')
          .update({'photo_url': imageUrl}).eq('id', providerId);
      return true;
    } catch (e) {
      print('Error updating provider image: $e');
      return false;
    }
  }

  // Update user avatar
  Future<bool> updateUserAvatar({
    required String userId,
    required String imageUrl,
  }) async {
    try {
      await _supabase
          .from('users')
          .update({'avatar_url': imageUrl}).eq('id', userId);
      return true;
    } catch (e) {
      print('Error updating user avatar: $e');
      return false;
    }
  }
}