import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // for date formatting
import '../../constants/app_colors.dart';
import '../../controllers/booking_controller.dart';
import '../../controllers/profile_controller.dart';
import '../../models/models.dart'; // Service, AddressModel, etc.
import '../payment/payment_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../controllers/payment_controller.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../payment/test_payment_view.dart';

class ConfirmationView extends GetView<BookingController> {
  ConfirmationView({Key? key}) : super(key: key);

  // grab the already-registered ProfileController
  final ProfileController profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final Service clinic = args['clinic'] as Service;
    final DateTime selectedDate = args['selectedDate'] as DateTime;
    final String selectedTime = args['selectedTimeSlot'] as String;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text('confirm_consultation'.tr),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ── Clinic Info ──────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(children: [
              SvgPicture.network(
                clinic.imageUrl ??
                'assets/icons/abdominal.svg',
                width: 32, height: 32,
                colorFilter:
                    ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  clinic.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
            ]),
          ),

          const SizedBox(height: 24),

          // ── Address ──────────────────────────────────
          Obx(() {
            if (profileController.addresses.isEmpty) {
              return Text(
                'no_address'.tr,
                style: const TextStyle(color: Colors.red),
              );
            }
            final addr = profileController.addresses.first;
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: IntrinsicHeight(
                child: Row(children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: const BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(12))),
                      child: const Center(
                        child: Icon(Icons.location_on,
                            color: Colors.white, size: 40),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '${addr['government']}, ${addr['city']}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: AppColors.primary,
                                ),
                                onPressed: () => Get.toNamed('/address'),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(addr['street'] ?? '',
                              style: const TextStyle(fontSize: 14)),
                          const SizedBox(height: 4),
                          Text('${addr['floor_no']} ${'floor'.tr} ',
                              style: const TextStyle(fontSize: 14)),
                          const SizedBox(height: 4),
                          Text('${'apt_no'.tr} ${addr['apartment_no'] ?? ''}',
                              style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            );
          }),

          const SizedBox(height: 24),

          // ── Appointment Date ─────────────────────────
          Text(
            'selected date'.tr,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat('EEEE d MMMM').format(selectedDate),
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${'time'.tr}: $selectedTime',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 24),

          // ── Contact Number ───────────────────────────
          Text(
            'contact_number'.tr,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                child: const Row(children: [
                  Text('🇪🇬', style: TextStyle(fontSize: 16)),
                  SizedBox(width: 4),
                  Text('+20', style: TextStyle(fontSize: 16)),
                ]),
              ),
              Expanded(
                child: Obx(() {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      profileController.phoneNumber.value,
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                }),
              ),
            ]),
          ),
          const SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'special_notes'.tr,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: controller.notesController,
                  decoration: const InputDecoration(
                    hintText: 'type here',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  maxLines: 3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // ── Confirm Button ────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => _chooseAddressAndBook(
                context,
                clinic,
                selectedDate,
                selectedTime,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                'confirm'.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Future<void> _chooseAddressAndBook(
    BuildContext ctx,
    Service clinic,
    DateTime date,
    String time,
  ) {
    final addr = profileController.addresses.first;

    return showDialog(
      context: ctx,
      builder: (_) => StatefulBuilder(
        builder: (c, setState) => AlertDialog(

          title: Text('Data Confirmation'.tr),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Kindly review the information below and confirm that it is correct. If everything looks good, please click confirm",
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 16),
                
                // Service Name
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.medical_services, color: AppColors.primary),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          clinic.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                
                // Selected Date
                Text(
                  'Selected Date:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${DateFormat('EEEE, d MMMM yyyy').format(date)}',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                SizedBox(height: 12),
                
                // Time Slot
                Text(
                  'Time Slot:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    time,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                SizedBox(height: 12),
                
                // Address
                Text(
                  'Delivery Address:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${addr['street'] ?? ''}, ${addr['floor_no'] ?? ''} ${'floor'.tr}, ${'apt_no'.tr} ${addr['apartment_no'] ?? ''}, ${addr['city'] ?? ''}, ${addr['government'] ?? ''}',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                SizedBox(height: 12),
                
                // Contact Info
                Text(
                  'Contact Information:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 8),
                Text(
                  'Name: ${profileController.firstName.value} ${profileController.lastName.value}',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  'Phone: ${profileController.phoneNumber.value}',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 12),
                
                // Price
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.primary),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Price:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'EGP ${clinic.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Get.back(), child: Text('cancel'.tr)),
            TextButton(
              onPressed: () async {
                // 1) Populate bookingController with everything
                controller.selectedService.value = clinic;
                controller.selectedDates.clear();
                controller.selectedDates.add(date);
                controller.selectedTimeSlot.value = time;
                controller.selectedAddressId.value = addr['id'];
                controller.contactNumber.value =
                    profileController.phoneNumber.value;
                controller.patientName.value =
                    profileController.firstName.value +
                        ' ' +
                        profileController.lastName.value;
                controller.patientAge.value =
                    profileController.birthDate.value.toString();
                controller.patientGender.value = profileController.gender.value;
                controller.notes.value = controller.notesController.text;
                // 2) Insert into Supabase with status = "unpaid"

                final ok =
                    await controller.createBooking(statusOverride: 'unpaid');
                Get.back(); // close dialog

                if (ok) {
                  final paymentController = Get.find<PaymentController>();
                  final authToken = await paymentController.getAuthToken();
                  final orderId = await paymentController.getOrderId(authToken, clinic.price);
                  final paymentKey = await paymentController.getPaymentKey(authToken, orderId, clinic.price);
                  final iframeUrl = 'https://accept.paymob.com/api/acceptance/iframes/867108?payment_token=$paymentKey';
                  final result = await Get.to(() => PaymentWebView(
                    paymentUrl: iframeUrl,
                    clinicName: clinic.name,
                    price: clinic.price,
                  ));
                  if (result == 'success' || result == 'fail') {
                    Get.snackbar(
                      result == 'success' ? 'Payment request send Successful' : 'Payment Failed',
                      'We will contact you soon.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: result == 'success' ? Colors.green : Colors.red,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 3),
                    );
                    Get.offAllNamed('/home');
                  }
                } else {
                  Get.snackbar('error'.tr, controller.errorMessage.value,
                      duration: const Duration(seconds: 5),
                      snackPosition: SnackPosition.BOTTOM);
                }
              },
              child: Text('confirm'.tr),
            ),
          ],
        ),
      ),
    );
  }


   Future<void> _pay(double amount) async{
    if (!Get.isRegistered<PaymentController>()) {
      Get.put(PaymentController());
    }
    final paymentController = Get.find<PaymentController>();
    final authToken = await paymentController.getAuthToken();
    final orderId = await paymentController.getOrderId(authToken, amount);
    final paymentKey = await paymentController.getPaymentKey(authToken, orderId, amount);
    launchUrl(
      Uri.parse("https://accept.paymob.com/api/acceptance/iframes/791787?payment_token=$paymentKey"),
    );
  } 
}