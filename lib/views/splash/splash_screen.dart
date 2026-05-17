import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/notification_permission_service.dart';

class SplashScreen extends StatefulWidget {
  
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // Start the animation
    _controller.forward();

    // Navigate to the next screen after animation completes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Replace '/home' with your desired route
        Get.offAllNamed('/mainScreen');
      }
    });
  }

  Future<void> _handleNavigation() async {
    // Request notification permission on first use
    final permissionService = Get.find<NotificationPermissionService>();
    await permissionService.requestNotificationPermission(context);
    
    // Navigate to main screen
    Get.offAllNamed('/mainScreen');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset(
          'assets/images/instaclinic-logo.json',
          controller: _controller,
          onLoaded: (composition) {
            _controller
              ..duration = composition.duration
              ..forward();
          },
          width: 300,
          height: 300,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

