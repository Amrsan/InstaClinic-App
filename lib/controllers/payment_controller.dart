import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/saved_bank_card.dart';
import '../views/payment/test_payment_view.dart';
import '../controllers/profile_controller.dart';

class PaymentController extends GetxController {
  final storage = const FlutterSecureStorage();
  late final ProfileController profileController;

  @override
  void onInit() {
    super.onInit();
    profileController = Get.find<ProfileController>();
  }

  // Paymob API Keys
  final String apiKey = 'ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2T1RrME16ZzNMQ0p1WVcxbElqb2lhVzVwZEdsaGJDSjkuVEprTWsyOVhTR0h4Rl9xQlRfdEUwSVB6N0VwdG93QV9IZmZ6OVhLU1RidXZfLU1RaGRnSkpkZmUwaURYSlh1Y0ZYMHgtR3g3N1RMV1loSHhIbzlnWUE=';
  final String integrationId = '4832092';
  final String iframeId = 'https://accept.paymob.com/api/acceptance/iframes/867108?payment_token={payment_key_obtained_previously}';

  // Card details
  final cardNumber = ''.obs;
  final cvv = ''.obs;
  final cardHolderName = ''.obs;

  // Payment state
  final isLoading = false.obs;
  final paymentError = ''.obs;

  Future<String> getAuthToken() async {
    try {
      final response = await http.post(
        Uri.parse('https://accept.paymob.com/api/auth/tokens'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'api_key': apiKey}),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['token'];
      } else {
        final error = jsonDecode(response.body);
        throw Exception('Failed to get auth token: ${error['detail']}');
      }
    } catch (e) {
      throw Exception('Error getting auth token: $e');
    }
  }

  Future<String> getOrderId(String authToken, double amount) async {
    try {
      final response = await http.post(
        Uri.parse('https://accept.paymob.com/api/ecommerce/orders'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({
          'auth_token': authToken,
          'delivery_needed': false,
          'amount_cents': (amount * 100).round(),
          'currency': 'EGP',
          'items': [],
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['id'].toString();
      } else {
        final error = jsonDecode(response.body);
        throw Exception('Failed to create order: ${error['detail']}');
      }
    } catch (e) {
      throw Exception('Error creating order: $e');
    }
  }

  Future<String> getPaymentKey(String authToken, String orderId, double amount) async {
    try {
      final address = profileController.addresses.first;

      final response = await http.post(
        Uri.parse('https://accept.paymob.com/api/acceptance/payment_keys'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({
          'auth_token': authToken,
          'amount_cents': (amount * 100).round(),
          'expiration': 3600,
          'order_id': orderId,
          'billing_data': {
            'apartment': 'NA',
            'email': profileController.email.value??"",
            'floor':  'NA',
            'first_name': profileController.firstName.value??"",
            'street':  'NA',
            'building':  'NA',
            'phone_number': profileController.phoneNumber.value??"",
            'shipping_method': 'NA',
            'postal_code': 'NA',
            'city':'NA',
            'country': 'EG',
            'last_name': profileController.lastName.value??"",
            'state':  'NA',
          },
          'currency': 'EGP',
          'integration_id': integrationId,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['token'];
      } else {
        print('Failed to get payment key. Status: ${response.statusCode}');
        print('Response body: ${response.body}');
        final error = jsonDecode(response.body);
        throw Exception('Failed to get payment key: ${error['detail'] ?? response.body}');
      }
    } catch (e) {
      throw Exception('Error getting payment key: $e');
    }
  }

  Future<void> processPayment(double amount) async {
    try {
      isLoading.value = true;
      paymentError.value = '';

      // Validate card details
      if (cardNumber.value.isEmpty || cvv.value.isEmpty || cardHolderName.value.isEmpty) {
        throw Exception('Please fill in all card details');
      }

      // Use the passed amount
      final payAmount = amount;

      // Get auth token
      final authToken = await getAuthToken();
      print('Auth Token: $authToken'); // Debug print

      // Create order
      final orderId = await getOrderId(authToken, payAmount);
      print('Order ID: $orderId'); // Debug print

      // Get payment key
      final paymentKey = await getPaymentKey(authToken, orderId, payAmount);
      print('Payment Key: $paymentKey'); // Debug print

      // Show success message
      Get.snackbar(
        'Success',
        'Payment processed successfully\nAmount: $payAmount EGP',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );

      // Clear form after successful payment
      cardNumber.value = '';
      cvv.value = '';
      cardHolderName.value = '';

    } catch (e) {
      paymentError.value = e.toString();
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> processPaymentWithOrder(String authToken, String orderId, double amount) async {
    try {
      isLoading.value = true;
      paymentError.value = '';

      final paymentKey = await getPaymentKey(authToken, orderId, amount);
      print('Payment Key: $paymentKey'); // Debug print

      // Show success message
      Get.snackbar(
        'Success',
        'Payment processed successfully\nAmount: $amount EGP',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );

      // Clear form after successful payment
      cardNumber.value = '';
      cvv.value = '';
      cardHolderName.value = '';

    } catch (e) {
      paymentError.value = e.toString();
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> processPaymentByIframe( double amount) async {
    try {
      isLoading.value = true;
      paymentError.value = '';

      // Get auth token and order/payment key
      final authToken = await getAuthToken();
      final orderId = await getOrderId(authToken, amount);
      final paymentKey = await getPaymentKey(authToken, orderId, amount);

      // Build the iframe URL
      final iframeUrl = 'https://accept.paymob.com/api/acceptance/iframes/867108?payment_token=$paymentKey';

      // Open the WebView
      Get.to(() => PaymentWebView(
                    paymentUrl: iframeUrl,
                    clinicName: 'clinic.name',
                    price: amount,
                  ));
    } catch (e) {
      paymentError.value = e.toString();
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }
}