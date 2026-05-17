import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/constants.dart';

class ServiceCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback onTap;
  final bool isLarge;

  const ServiceCard({
    Key? key,
    required this.title,
    required this.iconPath,
    required this.onTap,
    this.backgroundColor = AppColors.cardBackground,
    this.iconColor = AppColors.primary,
    this.isLarge = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(isLarge ? 16.0 : 12.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              height: isLarge ? 40.0 : 32.0,
              width: isLarge ? 40.0 : 32.0,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
            SizedBox(height: isLarge ? 12.0 : 8.0),
            Text(
              title,
              style: AppStyles.bodyMedium.copyWith(
                color: backgroundColor == AppColors.cardBackground 
                    ? AppColors.text
                    : AppColors.background,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
} 