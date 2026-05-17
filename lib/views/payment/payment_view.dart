import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/payment_controller.dart';
import '../../models/models.dart';
import '../../controllers/booking_controller.dart';

class PaymentView extends GetView<PaymentController> {
  PaymentView({super.key});

  final PaymentController controller = Get.put(PaymentController());

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final Service clinic = args['clinic'] as Service;
    final double totalFees = args['totalFees'] as double? ?? clinic.price;
    final Color color = args['color'] as Color? ?? const Color(0xFF006868);
    final bookingController = Get.find<BookingController>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with Total Amount
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Text(
                      'instaclinic'.tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'total_amount'.tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          totalFees.toStringAsFixed(2),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'EGP',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.lock,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'secured_payment'.tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'view_payment_summary'.tr,
                        style: const TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  Row(
                    children: [
                      const Icon(Icons.credit_card, color: Colors.teal, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        'payment_method'.tr,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(height: 24),
                  Text(
                    'payment_method'.tr,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Card Number Field
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/mastercard.png',
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            onChanged: (value) =>
                                controller.cardNumber.value = value,
                            decoration: InputDecoration(
                              hintText: 'card_number_hint'.tr,
                              border: InputBorder.none,
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // CVV Field
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      onChanged: (value) => controller.cvv.value = value,
                      decoration: InputDecoration(
                        hintText: 'cvv'.tr,
                        border: InputBorder.none,
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      maxLength: 3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Card Holder Name Field
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      onChanged: (value) =>
                          controller.cardHolderName.value = value,
                      decoration: InputDecoration(
                        hintText: 'card_holder_name'.tr,
                        border: InputBorder.none,
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Accepted Cards
                  Row(
                    children: [
                      Text(
                        'we_accept'.tr,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Image.asset('assets/images/visa.png', height: 24),
                      const SizedBox(width: 12),
                      Image.asset('assets/images/amex.png', height: 24),
                      const SizedBox(width: 12),
                      Image.asset('assets/images/mastercard.png', height: 24),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Pay Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Step 1: Validate card details
                        if (controller.cardNumber.value.isEmpty ||
                            controller.cvv.value.isEmpty ||
                            controller.cardHolderName.value.isEmpty) {
                          Get.snackbar('Error', 'Please fill in all card details',
                            duration: const Duration(seconds: 5),
                          );
                          return;
                        }

                        // Step 2: Get auth token and create order to get orderId
                        final authToken = await controller.getAuthToken();
                        final orderId = await controller.getOrderId(authToken, totalFees);

                        // Step 3: Show confirmation dialog
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirm Payment'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Order Number: $orderId'),
                                Text('Total Fees: ${totalFees.toStringAsFixed(2)} EGP'),
                                Text('Clinic: ${clinic.name}'),
                                // Add any other receipt data here
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: const Text('Confirm & Pay'),
                              ),
                            ],
                          ),
                        );
                        // Step 4: If confirmed, proceed to payment
                        if (confirmed == true) {
                          await controller.processPaymentWithOrder(authToken, orderId, totalFees);
                          // Step 5: If payment successful, update booking status
                          if (controller.paymentError.value.isEmpty) {
                            await bookingController.updateBookingStatus(orderId, 'paid');
                            await Future.delayed(const Duration(seconds: 2));
                            Get.offAllNamed('/home');
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'pay'.tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Powered by
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'powered_by'.tr,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        Image.asset('assets/images/paymob.png', height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
