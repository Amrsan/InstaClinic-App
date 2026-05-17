import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/booking_controller.dart';
import '../../controllers/services_controller.dart';
import '../../models/models.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/profile_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'nursing_confirmation_view.dart';
import 'package:url_launcher/url_launcher.dart';

class NursingBookingView extends GetView<ServicesController> {
  const NursingBookingView({super.key});

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
    ];
  }

  Widget _buildImage(String? imageUrl) {
    if (imageUrl == null) {
      return SvgPicture.asset(
        'assets/icons/abdominal.svg',
        width: 32,
        height: 32,
        colorFilter: const ColorFilter.mode(
          Color(0xFF006868),
          BlendMode.srcIn,
        ),
      );
    }

    if (imageUrl.toLowerCase().endsWith('.svg')) {
      return SvgPicture.network(
        imageUrl,
        width: 32,
        height: 32,
        colorFilter: const ColorFilter.mode(
          Color(0xFF006868),
          BlendMode.srcIn,
        ),
      );
    } else {
      return Image.network(
        imageUrl,
        width: 32,
        height: 32,
        color: const Color(0xFF006868),
        fit: BoxFit.contain,
      );
    }
  }

  Widget _buildServiceTypeCell(Service service, ServicesController controller) {
    return Obx(() {
      final isSelected = controller.selectedService.value?.id == service.id;
      return InkWell(
        onTap: () => controller.selectedService.value = service,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8) ,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color:
                isSelected ? const Color(0xFF006868) : const Color(0xFFE8E8E8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              service.description ?? 'Unknown',
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 18
              ),

            ),
          ),
        ),
      );
    });
  }

  Widget _buildDateCell(DateTime date, BookingController bookingController) {
    return Obx(() {
      final isSelected = bookingController.selectedDates.contains(date);

      return InkWell(
        onTap: () {
          if (isSelected) {
            bookingController.removeDate(date);
          } else {
            bookingController.addDate(date);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF006868) : const Color(0xFFE8E8E8),
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

  Widget _buildTimeSlotCell(
      String timeSlot, BookingController bookingController) {
    return Obx(() {
      final isSelected = bookingController.selectedTimeSlot.value == timeSlot;
      return InkWell(
        onTap: () => bookingController.setTimeSlot(timeSlot),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color:
                isSelected ? const Color(0xFF006868) : const Color(0xFFE8E8E8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              timeSlot,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildDateGrid(BookingController bookingController) {
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
          itemCount: dates.length,
          itemBuilder: (context, index) {
            if (index < startOffset) {
              return const SizedBox();
            }
            return _buildDateCell(
                dates[index - startOffset], bookingController);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final clinic = Get.arguments as Service;
    final bookingController = Get.put(BookingController());
    // Fetch services for the given service name
    controller.fetchServicesByName(clinic.name);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF006868),
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
      body: Obx(() {
        if (controller.isFetchingServices.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.availableServices.isEmpty) {
          return Center(child: Text('no_services_found'.tr));
        }
        return SingleChildScrollView(
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
                        _buildImage(controller.selectedService.value?.imageUrl ?? clinic.imageUrl),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'pick_appointment_for'.trParams({'service': clinic.name}),
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
                    if (controller.availableServices.length > 1) ...[
                      Text(
                        'select_type'.tr,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 120,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          scrollDirection:Axis.horizontal ,
                         // Important for vertical inside a column
                          physics:
                              const NeverScrollableScrollPhysics(), // Don't scroll inside
                          itemCount: controller.availableServices.length,
                          itemBuilder: (context, index) {
                            final service = controller.availableServices[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _buildServiceTypeCell(service, controller),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    Text(
                      'select_day'.tr,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDateGrid(bookingController),
                    const SizedBox(height: 32),
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
                            child:
                                _buildTimeSlotCell(timeSlot, bookingController),
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
                                    const SnackBar(
                                      content: Text('Could not launch phone call'),
                                    ),
                                  );
                                }
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF006868),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.call, color: Colors.white, size: 24),
                                  const SizedBox(height: 8),
                                  Text('call'.tr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
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
                              final Uri whatsappUri = Uri.parse(
                                'whatsapp://send?phone=201033298820&text=can you please book me an appointment for ${"Home Nursing"} ');
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
                                      const SnackBar(
                                        content: Text('Could not launch WhatsApp'),
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF006868),
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
                                  Text('whatsapp'.tr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
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
                                color: const Color(0xFF006868),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.email, color: Colors.white, size: 24),
                                  const SizedBox(height: 8),
                                  Text('email'.tr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
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
        );
      }),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
        //      _buildTotalFees(bookingController, controller),
              SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final authController = Get.find<AuthController>();
                final profileController = Get.find<ProfileController>();

                // Check if user is logged in
                if (!authController.isAuthenticated.value ) {
                  Get.put<String>('/booking', tag: 'intended_route');
                  Get.toNamed('/login');
                  return;
                }

                    // Check if user has selected a service type, at least one date, and time
                if (controller.selectedService.value == null ||
                        bookingController.selectedDates.isEmpty ||
                    bookingController.selectedTimeSlot.value.isEmpty) {
                  Get.snackbar(
                    'missing_info'.tr,
                    'please_select_service_type_date_time'.tr,
                    snackPosition: SnackPosition.BOTTOM,
                    duration: const Duration(seconds: 5),

                  );
                  return;
                }

                // Set the selected service in BookingController
                bookingController.selectedService.value =
                    controller.selectedService.value;

                // Check if user has address
                final addresses = await profileController.addresses;
                if (addresses.isEmpty) {
                  Get.toNamed('/address', arguments: {
                    'clinic': controller.selectedService.value,
                        'selectedDates': bookingController.selectedDates,
                    'ServiceTypeCell': controller.selectedService.value,
                        'selectedTimeSlot': bookingController.selectedTimeSlot.value,
                  });
                  return;
                }

                // Everything is fine, go to confirmation
                Get.to(() => NursingBookingConfirmationView(), arguments: {
                  'clinic': controller.selectedService.value,
                      'selectedDates': bookingController.selectedDates,
                  'ServiceTypeCell': controller.selectedService.value,
                  'selectedTimeSlot': bookingController.selectedTimeSlot.value,
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006868),
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
            ],
          ),
        ),
      ),
    );
  }
}
