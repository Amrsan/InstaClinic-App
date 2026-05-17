import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instaclinics/core/constants.dart';
import 'package:get/get.dart';
class ClinicCard extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback onTap;
  final Color cardColor;
  final Color imageBackgroundColor;
  final Color titleBackgroundColor;

  const ClinicCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.cardColor = Colors.white,
    this.imageBackgroundColor = const Color(0x1A0D9298), // AppColors.primary.withOpacity(0.1)
    this.titleBackgroundColor = const Color(0xFF0D9298),
  }) : super(key: key);

  Widget _buildImage() {
    if (icon.toLowerCase().endsWith('.svg')) {
      return SvgPicture.network(
        icon,
        fit: BoxFit.contain,
      );
    } else {
      return Image.network(
        icon,
       // color: const Color(0xFFD2E221),
        fit: BoxFit.contain,
      );
    }
  }

  @override
  @override
Widget build(BuildContext context) {
  return GestureDetector(
    onTap: onTap,
    child: AspectRatio(
      aspectRatio: 4 / 5, // or 4/5, adjust as needed
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Image container
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: imageBackgroundColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: _buildImage(),
              ),
            ),
            // Divider
            Container(
              height: 1,
              color: Colors.grey[200],
            ),
            // Title container
            Expanded(
              flex: 1,
              child: Container(
                color: titleBackgroundColor,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                alignment: Alignment.center,
                child: Text(
                  title.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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