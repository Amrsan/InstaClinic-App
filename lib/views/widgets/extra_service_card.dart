import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
class ExtraServiceCard extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback onTap;

  const ExtraServiceCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150, // Square width
        height: 150, // Square height
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Image container
            Container(
              height: 100, // 2/3 of the card height
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFFFB74D).withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: SvgPicture.asset(
                icon,
                colorFilter: const ColorFilter.mode(
                  Color(0xFFFFB74D),
                  BlendMode.srcIn,
                ),
                fit: BoxFit.contain,
              ),
            ),
            // Divider
            Container(
              height: 1,
              color: Colors.grey[200],
            ),
            // Title container
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                alignment: Alignment.center,
                child: Text(
                  title.tr,
                  style: const TextStyle(
                    color: Color(0xFFFFB74D),
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
    );
  }
} 