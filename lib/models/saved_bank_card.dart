import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

// Enum for card types
enum CardType { OmanNet, JCB, Meeza, Maestro, Amex, Visa, MasterCard }

// Model for saved bank card
class SavedBankCard {
  final String token;
  final String maskedPanNumber;
  final String cardType;

  SavedBankCard({
    required this.token,
    required this.maskedPanNumber,
    required this.cardType,
  });

  // Convert the custom CardType class to a Map (which can be serialized to JSON)
  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'maskedPanNumber': maskedPanNumber,
      'cardType': cardType,
    };
  }
}

// Method channel for Paymob SDK
class PaymobIntegration {
  static const methodChannel = MethodChannel('paymob_sdk_flutter');

  // Method to call native PaymobSDKs
  Future<void> payWithPaymob(
    BuildContext context,
    String pk,
    String csk, {
    SavedBankCard? savedCard,
    String? appName,
    Color? buttonBackgroundColor,
    Color? buttonTextColor,
    bool? saveCardDefault,
    bool? showSaveCard,
  }) async {
    try {
      final String result = await methodChannel.invokeMethod('payWithPaymob', {
        "publicKey": pk,
        "clientSecret": csk,
        "savedBankCard": savedCard?.toMap(),
        "appName": appName,
        "buttonBackgroundColor": buttonBackgroundColor?.value,
        "buttonTextColor": buttonTextColor?.value,
        "saveCardDefault": saveCardDefault,
        "showSaveCard": showSaveCard
      });

      String message;
      switch (result) {
        case 'Successfull':
          message = 'Transaction Successful';
          break;
        case 'Rejected':
          message = 'Transaction Rejected';
          break;
        case 'Pending':
          message = 'Transaction Pending';
          break;
        default:
          message = 'Unknown response: $result';
      }

      // Show dialog with the message
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Payment Result'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } on PlatformException catch (e) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Error'),
          content: Text("Failed to call native SDK: '${e.message}'."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
} 