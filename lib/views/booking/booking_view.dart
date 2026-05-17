import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/booking_controller.dart';
import '../../models/models.dart';
import '../../views/booking/confirmation_view.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/profile_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../emergancy/confirm_book_eme.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingView extends GetView<BookingController> {
  const BookingView({super.key});

  List<DateTime> _getNext14Days() {
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, now.day);
    return List.generate(14, (index) => startDate.add(Duration(days: index)));
  }

  List<String> _getTimeSlots() {
    return [
      '10:00 AM - 12:00 PM',
      '12:00 PM - 02:00 PM',
      '02:00 PM - 04:00 PM',
      '04:00 PM - 06:00 PM',
      '06:00 PM - 08:00 PM',
      '08:00 PM - 10:00 PM',
      'After 10:00 PM (24 hours Emergency)',
    ];
  }

  Widget _buildDateCell(DateTime date) {
    return Obx(() {
      final isSelected = controller.selectedDates.contains(date);

      return InkWell(
        onTap: () {
          // Clear any existing selection and add the new date
          controller.selectedDates.clear();
            controller.addDate(date);
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF55B7B6) : const Color(0xFFE8E8E8),
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(
            '${date.day}',
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTimeSlotCell(String timeSlot) {
    return Obx(() {
      final isSelected = controller.selectedTimeSlot.value == timeSlot;
      final isEmergency = timeSlot == 'After 10:00 PM (24 hours Emergency)';
      
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (isEmergency) {
              // Get the clinic argument robustly
              Service clinic;
              if (Get.arguments is Service) {
                clinic = Get.arguments as Service;
              } else if (Get.arguments is Map<String, dynamic>) {
                clinic = (Get.arguments as Map<String, dynamic>)['clinic'] as Service;
              } else {
                Get.snackbar("error".tr, "clinic_information_missing".tr);
                return;
              }

              // Make sure a date is selected
              if (controller.selectedDates.isEmpty) {
                Get.snackbar("missing_info".tr, "please_select_date".tr, snackPosition: SnackPosition.BOTTOM);
                return;
              }

              // Set up the controller
              controller.selectedService.value = clinic;
              controller.selectedTimeSlot.value = timeSlot;

              // Navigate to Emergency Booking
              Get.to(() => EmeBookingConfirmationView(), arguments: {
                'clinic': clinic,
                'selectedDate': controller.selectedDates.first,
                'selectedTimeSlot': timeSlot,
              });
            } else {
              controller.setTimeSlot(timeSlot);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: isEmergency 
                  ? Colors.red.withOpacity(isSelected ? 1.0 : 0.1)
                  : isSelected ? const Color(0xFF55B7B6) : const Color(0xFFE8E8E8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                timeSlot,
                style: TextStyle(
                  color: isEmergency 
                      ? isSelected ? Colors.white : Colors.red
                      : isSelected ? Colors.white : Colors.black,
                  fontWeight: isEmergency ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildDateGrid() {
    final dates = _getNext14Days();
    final weekDays = ['Sun', 'Mon', 'Tues', 'Weds', 'Thurs', 'Fri', 'Sat'];

    int startOffset = dates[0].weekday % 7;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: weekDays
              .map((day) => SizedBox(
                    width: 40,
                    child: Text(
                      day,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.2,
          ),
          itemCount: dates.length + startOffset,
          itemBuilder: (context, index) {
            if (index < startOffset) {
              return const SizedBox(); // empty space
            } else {
              return _buildDateCell(dates[index - startOffset]);
            }
          },
        ),
      ],
    );
  }

  Widget _buildImage(String? imageUrl) {
    if (imageUrl == null) {
      return SvgPicture.asset(
        'assets/icons/abdominal.svg',
        width: 38,
        height: 38,
      //   colorFilter: const ColorFilter.mode(
      //     Color(0xFF55B7B6),
      //     BlendMode.srcIn,
      //   ),
       );
    }

    if (imageUrl.toLowerCase().endsWith('.svg')) {
      return SvgPicture.network(
        imageUrl,
        width: 32,
        height: 32,
        colorFilter: const ColorFilter.mode(
          Color(0xFF55B7B6),
          BlendMode.srcIn,
        ),
      );
    } else {
      return Image.network(
        imageUrl,
        width: 55,
        height: 55,
       // color: const Color(0xFF55B7B6),
        fit: BoxFit.cover,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final clinic = Get.arguments as Service;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF55B7B6),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'booking_consultation'.tr,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),

      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildImage(clinic.imageUrl),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'pick appointment for'.tr,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'select day'.tr,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(() => Text(
                    controller.selectedDates.isEmpty 
                        ? 'no day selected'.tr
                        : 'selected_day'.trParams({
                            'date': ' 24{controller.selectedDates.first.day}/ 24{controller.selectedDates.first.month}/ 24{controller.selectedDates.first.year}'
                          }),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  )),
                  const SizedBox(height: 8),
                  _buildDateGrid(),
                  const SizedBox(height: 24),
                  Text(
                    'select_time'.tr,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _getTimeSlots().length,
                      itemBuilder: (context, index) {
                        final timeSlot = _getTimeSlots()[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _buildTimeSlotCell(timeSlot),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'contact_us'.tr,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Call Option
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final Uri phoneUri = Uri(
                              scheme: 'tel',
                              path: '01033298820',
                            );
                            if (await canLaunchUrl(phoneUri)) {
                              await launchUrl(phoneUri);
                            } else {
                              // Handle error
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('could_not_launch_phone'.tr),
                                  ),
                                );
                              }
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF55B7B6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.call, color: Colors.white, size: 24),
                                SizedBox(height: 8),
                                Text('call'.tr, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // WhatsApp Option
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final Uri whatsappUri = Uri.parse('whatsapp://send?phone=201033298820&text=can you please book me an appointment for ${clinic.name==Null ? '':clinic.name} on ${controller.selectedDates.isEmpty ? '':controller.selectedDates.join(', ')} at ${controller.selectedTimeSlot.value==Null ? TimeOfDay.now().toString():controller.selectedTimeSlot.value}');
                            if (await canLaunchUrl(whatsappUri)) {
                              await launchUrl(whatsappUri);
                            } else {
                              // If WhatsApp is not installed, try opening in browser
                              final Uri webWhatsappUri = Uri.parse('https://wa.me/201033298820');
                              if (await canLaunchUrl(webWhatsappUri)) {
                                await launchUrl(webWhatsappUri);
                              } else {
                                // Handle error
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('could_not_launch_whatsapp'.tr),
                                    ),
                                  );
                                }
                              }
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF55B7B6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/whatsapp-white-icon 1.svg',
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                  width: 24,
                                  height: 24,
                                ),
                                const SizedBox(height: 8),
                                Text('whatsapp'.tr, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Email Option
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            launchUrl(Uri.parse('mailto:instaclinic30@gmail.com'));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF55B7B6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.email, color: Colors.white, size: 24),
                                SizedBox(height: 8),
                                Text('email'.tr, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final authController = Get.find<AuthController>();
                final profileController = Get.find<ProfileController>();

                // Check if user is logged in
              //  if (!authController.isAuthenticated.value && FirebaseAuth.instance.currentUser == Null) {
                  print(authController.isAuthenticated.value);
                  if (!authController.isAuthenticated.value){
                  Get.put<String>('/booking', tag: 'intended_route');
                  
                  Get.toNamed('/login');
               
                  return;
                }

                // Check if user has selected a date
                if (controller.selectedDates.isEmpty) {
                  Get.snackbar(
                    "missing_info".tr,
                    "please_select_date".tr,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                  return;
                }

                // Check if user has selected a time slot
                if (controller.selectedTimeSlot.value == null) {
                  Get.snackbar(
                    "missing_info".tr,
                    "please_select_time_slot".tr,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                  return;
                }

                // Check if user has address
                final addresses = await profileController.addresses;
                if (addresses.isEmpty) {
                  Get.toNamed('/address', arguments: {
                    'clinic': clinic,
                    'selectedDates': controller.selectedDates,
                    'selectedTimeSlot': controller.selectedTimeSlot.value,
                  });
                  return;
                }

                // Everything is fine, go to confirmation
                Get.to(() => ConfirmationView(), arguments: {
                  'clinic': clinic,
                  'selectedDate': controller.selectedDates.first,
                  'selectedTimeSlot': controller.selectedTimeSlot.value,
                  'is24Hours': controller.selectedTimeSlot.value == 'After 10:00 PM (24 hours Emergency)',
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF55B7B6),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'confirm_booking'.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
