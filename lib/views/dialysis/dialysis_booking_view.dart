import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/booking_controller.dart';
import '../../models/models.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/profile_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dialysis_confirmation_view.dart';
import 'package:url_launcher/url_launcher.dart';

class DialysisBookingView extends GetView<BookingController> {
  const DialysisBookingView({super.key});

  List<DateTime> _getNext14Days() {
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, now.day);
    return List.generate(14, (index) => startDate.add(Duration(days: index)));
  }

  Widget _buildDateCell(DateTime date) {
    return Obx(() {
      final isSelected = controller.selectedDates.contains(date);

      return InkWell(
        onTap: () {
          if (isSelected) {
            controller.removeDate(date);
          } else {
            controller.addDate(date);
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

  Widget _buildTotalFees() {
    return Obx(() {
      if (controller.selectedDates.isEmpty) {
        return const SizedBox();
      }
      final service = Get.arguments as Service;
      final totalDays = controller.selectedDates.length;
      final totalFees = service.price * totalDays;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF006868).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'total_fees'.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF006868),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${'service'.tr}: ${service.name}',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                '${'price_per_day'.tr}: EGP ${service.price}',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                '${'number_of_days'.tr}: $totalDays',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                '${'total'.tr}: EGP $totalFees',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF006868),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryServices = Get.arguments as Service;

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
          'request_for_dialysis'.tr,
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
                      _buildImage(primaryServices.imageUrl),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'pick appointment for'.trParams({'clinic': primaryServices.name}),
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
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF006868).withOpacity(0.1),
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'note'.tr,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '• ',
                              style: TextStyle(fontSize: 14, height: 1.4),
                            ),
                            Expanded(
                              child: Text(
                                'At least 2 sessions to booking dialysis '.tr,
                                style: const TextStyle(fontSize: 14, height: 1.4),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'select day'.tr,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDateGrid(),
                  const SizedBox(height: 24),
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
                              color: const Color(0xFF006868),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.call, color: Colors.white, size: 24),
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
                            final Uri whatsappUri = Uri.parse(
                              'whatsapp://send?phone=201033298820&text=can you please book me an appointment for ${"Dialysis"} on ${controller.selectedDates.isNotEmpty ? controller.selectedDates.first.toString() : ''}');
                            if (await canLaunchUrl(whatsappUri)) {
                              await launchUrl(whatsappUri);
                            } else {
                              final Uri webWhatsappUri = Uri.parse('https://wa.me/201033298820');
                              if (await canLaunchUrl(webWhatsappUri)) {
                                await launchUrl(webWhatsappUri);
                              } else {
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
                                SizedBox(height: 8),
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
                              color: const Color(0xFF006868),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.email, color: Colors.white, size: 24),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTotalFees(),
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

                    // Check if user has selected at least 2 dates (as per note)
                    if (controller.selectedDates.length < 2) {
                  Get.snackbar(
                    'missing_info'.tr,
                    'please_select_two_dates'.tr,
                    snackPosition: SnackPosition.BOTTOM,
                    duration: const Duration(seconds: 5),
                  );
                  return;
                }

                // Check if user has address
                final addresses = await profileController.addresses;
                if (addresses.isEmpty) {
                  Get.toNamed('/address', arguments: {
                    'clinic': primaryServices,
                        'selectedDates': controller.selectedDates,
                    'selectedTimeSlot': '10:00 AM - 10:00 PM',
                  });
                  return;
                }

                // Everything is fine, go to confirmation
                Get.to(() => DialysisBookingConfirmationView(), arguments: {
                  'primaryServices': primaryServices,
                      'selectedDates': controller.selectedDates,
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
