import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/constants.dart';

class WhatsAppButton extends StatelessWidget {
  final String phoneNumber;
  final String message;

  const WhatsAppButton({
    Key? key,
    required this.phoneNumber,
    required this.message,
  }) : super(key: key);

  Future<void> _launchWhatsApp() async {
    final whatsappUrl = Uri.parse(
      'whatsapp://send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}',
    );

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl);
    } else {
      // Fallback to web WhatsApp
      final webWhatsappUrl = Uri.parse(
        'https://web.whatsapp.com/send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}',
      );
      if (await canLaunchUrl(webWhatsappUrl)) {
        await launchUrl(webWhatsappUrl);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _launchWhatsApp,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.background,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/whatsapp.png',
              height: 24,
              width: 24,
              color: AppColors.background,
            ),
            SizedBox(width: 12),
            Text(
              'Through WhatsApp',
              style: AppStyles.bodyLarge.copyWith(
                color: AppColors.background,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 