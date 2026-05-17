import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RouteGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final supabase = Supabase.instance.client;
    if (supabase.auth.currentUser == null) {
      // Store the intended route
      Get.put<String>(route ?? '/home', tag: 'intended_route');
      return const RouteSettings(name: '/login');
    }
    return null;
  }
} 