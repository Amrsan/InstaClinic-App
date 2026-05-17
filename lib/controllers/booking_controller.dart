import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/database_service.dart';
import '../models/models.dart';

class BookingController extends GetxController {
  DatabaseService get _databaseService => Get.find<DatabaseService>();

  // Observable variables for date and time selection
  final selectedDates = <DateTime>[].obs;
  final selectedTimeSlot = ''.obs;

  // Service and provider selection
  final selectedService = Rxn<Service>();
  final selectedProvider = Rx<MedicalProvider?>(null);

  // Patient information
  final patientName = ''.obs;
  final patientAge = ''.obs;
  final patientGender = ''.obs;
  final contactNumber = ''.obs;
  final notes = ''.obs;

  // Address selection
  final selectedAddressId = ''.obs;

  // UI state
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final showTotalFees = false.obs;

  final selectedTaskType = 'Single Task'.obs;

  TextEditingController notesController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  // Add date to selection
  void addDate(DateTime date) {
    if (!selectedDates.contains(date)) {
      selectedDates.add(date);
    }
  }

  // Remove date from selection
  void removeDate(DateTime date) {
    selectedDates.remove(date);
  }

  // Set time slot
  void setTimeSlot(String timeSlot) {
    selectedTimeSlot.value = timeSlot;
  }

  // Create booking
  Future<bool> createBooking({
    String statusOverride = 'pending',
    Map<String, dynamic>? bookingData,
  }) async {
    if (bookingData != null) {
      // Use provided booking data
      final service = bookingData['service'] as Service;
      final dates = bookingData['dates'] as List<DateTime>;
      final timeSlot = bookingData['timeSlot'] as String;
      final addressId = bookingData['addressId'] as String;
      final contactNumber = bookingData['contactNumber'] as String;
      final patientName = bookingData['patientName'] as String;
      final patientAge = bookingData['patientAge'] as String;
      final patientGender = bookingData['patientGender'] as String;
      final notes = bookingData['notes'] as String;

      try {
        isLoading.value = true;
        errorMessage.value = '';

        final user = Supabase.instance.client.auth.currentUser;

        // Create a booking for each selected date
        for (final date in dates) {
          final booking = {
            'service_id': service.id,
            'user_id': user?.id,
            'address_id': addressId,
            'booking_date': date.toIso8601String().split('T')[0],
            'booking_time': timeSlot,
            'status': statusOverride,
            'contact_number': contactNumber,
            'patient_name': patientName,
            'patient_age': patientAge,
            'patient_gender': patientGender,
            'fee': service.price * dates.length,
            'notes': notes,
          };

          await _databaseService.createBooking(booking);
        }

        return true;
      } catch (e) {
        errorMessage.value = 'Failed to create booking: $e';
        return false;
      } finally {
        isLoading.value = false;
      }
    } else {
      // Use existing controller state
      if (!validateBookingForm()) return false;

      try {
        isLoading.value = true;
        errorMessage.value = '';

        final user = Supabase.instance.client.auth.currentUser;

        // Create a booking for each selected date
        for (final date in selectedDates) {
          final booking = {
            'service_id': selectedService.value!.id,
            'user_id': user?.id,
            'address_id': selectedAddressId.value.isEmpty ? null : selectedAddressId.value,
            'booking_date': date.toIso8601String().split('T')[0],
            'booking_time': selectedTimeSlot.value,
            'status': statusOverride,
            'contact_number': contactNumber.value,
            'patient_name': patientName.value.isEmpty ? null : patientName.value,
            'patient_age': patientAge.value.isEmpty ? null : patientAge.value,
            'patient_gender': patientGender.value.isEmpty ? null : patientGender.value,
            'fee': selectedService.value!.price * selectedDates.length,
            'notes': notes.value.isEmpty ? null : notes.value,
          };

          await _databaseService.createBooking(booking);
        }

        resetBookingForm();
        return true;
      } catch (e) {
        errorMessage.value = 'Failed to create booking: $e';
        return false;
      } finally {
        isLoading.value = false;
      }
    }
  }

  // Validate booking form
  bool validateBookingForm() {
    if (selectedDates.isEmpty) {
      errorMessage.value = 'Please select at least one date';
      return false;
    }
    if (selectedTimeSlot.value.isEmpty) {
      errorMessage.value = 'Please select a time slot';
      return false;
    }
    if (selectedService.value == null) {
      errorMessage.value = 'Please select a service';
      return false;
    }
    return true;
  }

  // Reset booking form
  void resetBookingForm() {
    selectedDates.clear();
    selectedTimeSlot.value = '';
    selectedService.value = null;
    selectedProvider.value = null;
    patientName.value = '';
    patientAge.value = '';
    patientGender.value = '';
    contactNumber.value = '';
    notes.value = '';
    selectedAddressId.value = '';
    errorMessage.value = '';
    notesController.clear();
    phoneNumberController.clear();
  }

  // Update booking status by booking/order id
  Future<void> updateBookingStatus(String bookingId, String status) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      // Update the booking in the database (Supabase example)
      final response = await Supabase.instance.client
          .from('bookings')
          .update({'status': status})
          .eq('id', bookingId)
          .maybeSingle();
      if (response == null) {
        throw Exception('No response from database');
      }
      Get.snackbar(
        'Booking Updated',
        'Booking $bookingId status changed to $status',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 8),
      );
    } catch (e) {
      errorMessage.value = 'Failed to update booking status: $e';
      Get.snackbar(
        'Error',
        'Failed to update booking status: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 8),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
