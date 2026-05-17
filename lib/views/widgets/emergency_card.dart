import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
class EmergencyCard extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback onTap;

  const EmergencyCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  Widget _buildImage() {
    if (icon.toLowerCase().endsWith('.svg')) {
      return SvgPicture.network(
        icon,
        colorFilter: const ColorFilter.mode(
           Color(0xFF006868),
           BlendMode.srcIn,
         ),
        fit: BoxFit.cover,
      );
    } else {
      return Image.network(
        icon,
        // color: const Color(0xFF006868),
        fit: BoxFit.cover,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity, // Full width
        height: 120, // Card height
        decoration: BoxDecoration(
          color: const Color(0xFF056566), // Bright emergency red
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.15),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image container
            Container(
              width: 170,
              height: 120,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: _buildImage(),
            ),
            // Title
            Expanded(
              child: Center(
                child: Text(
                  title.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}