import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/models.dart';
import 'booking_controller.dart';

class DialysisBookingController extends GetxController {
  final _bookingController = Get.find<BookingController>();
  final selectedDates = <DateTime>[].obs;
  final selectedTimeSlot = ''.obs;
  final notes = ''.obs;
  final errorMessage = ''.obs;

  void addDate(DateTime date) {
    if (!selectedDates.contains(date)) {
      selectedDates.add(date);
    }
  }

  void removeDate(DateTime date) {
    selectedDates.remove(date);
  }

  void setTimeSlot(String timeSlot) {
    selectedTimeSlot.value = timeSlot;
  }

  bool validateBooking() {
    if (selectedDates.length < 2) {
      errorMessage.value = 'Dialysis requires at least 2 days of booking';
      return false;
    }
    if (selectedTimeSlot.value.isEmpty) {
      errorMessage.value = 'Please select a time slot';
      return false;
    }
    return true;
  }

  double calculateFees(Service service) {
    return service.price * selectedDates.length;
  }

  String formatBookingDetails(Service service) {
    final totalFees = calculateFees(service);
    final datesString = selectedDates.map((date) => 
      '${date.day}/${date.month}/${date.year}'
    ).join(', ');
    
    return 'Dialysis Booking Details:\n'
           'Selected Dates: $datesString\n'
           'Time Slot: ${selectedTimeSlot.value}\n'
           'Total Fees: EGP $totalFees';
  }

  Future<bool> createDialysisBooking({
    required Service service,
    required List<DateTime> selectedDates,
    required String timeSlot,
    required String addressId,
    required String contactNumber,
    required String patientName,
    required String patientAge,
    required String patientGender,
    String? notes,
  }) async {
    if (!validateBooking()) {
      return false;
    }

    // Format booking details
    final bookingDetails = formatBookingDetails(service);

    // Set the booking details in the main controller
    _bookingController.selectedService.value = service;
    _bookingController.selectedDates.value = selectedDates;
    _bookingController.selectedTimeSlot.value = timeSlot;
    _bookingController.selectedAddressId.value = addressId;
    _bookingController.contactNumber.value = contactNumber;
    _bookingController.patientName.value = patientName;
    _bookingController.patientAge.value = patientAge;
    _bookingController.patientGender.value = patientGender;
    _bookingController.notes.value = bookingDetails;
print("================here================");
    // Create the booking
    final success = await _bookingController.createBooking();

    if (success) {
      // Navigate to payment page with total fees
      Get.toNamed('/payment', arguments: {
        'clinic': service,
        'totalFees': calculateFees(service),
        'color': const Color(0xFF006868),
      });
    } else {
      errorMessage.value = _bookingController.errorMessage.value;
    }

    return success;
  }
}

class HomeNursingBookingController extends GetxController {
  final _bookingController = Get.find<BookingController>();
  final selectedDates = <DateTime>[].obs;
  final selectedTimeSlot = ''.obs;
  final notes = ''.obs;
  final errorMessage = ''.obs;

  void addDate(DateTime date) {
    if (!selectedDates.contains(date)) {
      selectedDates.add(date);
    }
  }

  void removeDate(DateTime date) {
    selectedDates.remove(date);
  }

  void setTimeSlot(String timeSlot) {
    selectedTimeSlot.value = timeSlot;
  }

  bool validateBooking() {
    if (selectedDates.isEmpty) {
          errorMessage.value = 'Please select at least one date';
          return false;
        }
    if (selectedTimeSlot.value.isEmpty) {
      errorMessage.value = 'Please select a time slot';
      return false;
    }
    return true;
  }

  double calculateFees(Service service) {
    return service.price * selectedDates.length;
  }

  String formatBookingDetails(Service service) {
    final totalFees = calculateFees(service);
    final datesString = selectedDates.map((date) => 
      '${date.day}/${date.month}/${date.year}'
    ).join(', ');
    
    return 'Home Nursing Booking Details:\n'
           'Selected Dates: $datesString\n'
           'Time Slot: ${selectedTimeSlot.value}\n'
           'Total Fees: EGP $totalFees';
  }

  Future<bool> createHomeNursingBooking({
    required Service service,
    required List<DateTime> selectedDates,
    required String timeSlot,
    required String addressId,
    required String contactNumber,
    required String patientName,
    required String patientAge,
    required String patientGender,
    String? notes,
  }) async {
    if (!validateBooking()) {
      return false;
    }

    // Format booking details
    final bookingDetails = formatBookingDetails(service);

    // Set the booking details in the main controller
    _bookingController.selectedService.value = service;
    _bookingController.selectedDates.value = selectedDates;
    _bookingController.selectedTimeSlot.value = timeSlot;
    _bookingController.selectedAddressId.value = addressId;
    _bookingController.contactNumber.value = contactNumber;
    _bookingController.patientName.value = patientName;
    _bookingController.patientAge.value = patientAge;
    _bookingController.patientGender.value = patientGender;
    _bookingController.notes.value = bookingDetails;

    // Create the booking
    final success = await _bookingController.createBooking();

    if (success) {
      // Navigate to payment page with total fees
      Get.toNamed('/nursing_confirmation', arguments: {
        'clinic': service,
        'totalFees': calculateFees(service),
        'color': const Color(0xFF006868),
      });
    } else {
      errorMessage.value = _bookingController.errorMessage.value;
    }

    return success;
  }
} 