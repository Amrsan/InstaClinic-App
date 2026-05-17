import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instaclinics/controllers/address_controller.dart';
import 'package:instaclinics/views/web/dashboard_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'routes/app_pages.dart';
import 'services/auth_service.dart';
import 'services/database_service.dart';
import 'services/fcm_service.dart';
import 'services/notification_permission_service.dart';
import 'constants/app_colors.dart';
import 'controllers/auth_controller.dart';
import 'views/auth/reset_password.dart';
import 'views/web/login_view.dart';
import 'translations/app_translations.dart';
import 'views/splash/splash_screen.dart';
import 'controllers/payment_controller.dart';
import 'controllers/profile_controller.dart';
import 'controllers/notification_controller.dart';

void main() async {
  // Initialize Flutter binding first
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load();

  // Initialize Supabase with error handling
  if (dotenv.env['SUPABASE_URL'] == null ||
      dotenv.env['SUPABASE_URL']!.isEmpty ||
      dotenv.env['SUPABASE_ANON_KEY'] == null ||
      dotenv.env['SUPABASE_ANON_KEY']!.isEmpty) {
    throw Exception('Supabase URL or Anon Key not found in .env file');
  }

  await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
      debug: true,
    // Enable debug mode for development
      );

  await Get.putAsync<AuthService>(() async {
    final svc = AuthService();
    await svc.initialize();
    return svc;
  });
  // final authC = Get.put(AuthController());
  // await authC.init(); // ← await here, so init finishes first
  final appLinks = AppLinks();

  // 1️⃣ Cold start
  final initialUri = await appLinks.getInitialLink();
  if (initialUri != null) {
    try {
      await Supabase.instance.client.auth.recoverSession(initialUri.toString());
    } catch (e) {
      print('Error recovering session from initial URI: $e');
    }
  }

  // 2️⃣ Hot resume
  appLinks.uriLinkStream.listen((uri) {
    try {
      Supabase.instance.client.auth.recoverSession(uri.toString());
    } catch (e) {
      print('Error recovering session from URI stream: $e');
    }
  });

  // 3️⃣ Redirect to your password‑entry UI when recovery session is ready:
  Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    if (data.event == AuthChangeEvent.passwordRecovery) {
      Get.to(() => ResetPasswordScreen());
    }
  });
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize FCM Service with delay for iOS APNS setup
  final fcmService = FCMService();

  try {
    await fcmService.initialize();
    print('✅ FCM Service initialized successfully');
    
    // Handle authentication state changes for automatic token saving
    await fcmService.handleAuthStateChange();
  } catch (e) {
    print('⚠️ FCM initialization had issues: $e');
    print('🔄 Will retry FCM token generation later...');
  }
  
  Get.put(fcmService);
  
  // Print FCM token to console
  fcmService.printFCMToken();

  // Register services in the correct order
  Get.put(AuthService());
  Get.put(DatabaseService());
  Get.put(AuthController());
  Get.put(ProfileController());
  Get.put(PaymentController());
  Get.put(AddressController());
  Get.put(NotificationController());
  Get.put(NotificationPermissionService());
  
  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // Web-specific app configuration
      return GetMaterialApp(
        title: 'InstaClinic Admin',
        debugShowCheckedModeBanner: false,
        translations: AppTranslations(),
        locale: Get.deviceLocale,
        fallbackLocale: const Locale('en', 'US'),
        theme: ThemeData(
          primaryColor: AppColors.primary,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: AppColors.primary,
            secondary: AppColors.primary,
          ),
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'Poppins',
        ),
        home: WebLoginView(),
        getPages: [
          GetPage(name: '/login', page: () => WebLoginView()),
          GetPage(name: '/dashboard', page: () => WebDashboardView()),
        ],
      );
    } else {
      // Mobile app configuration
      return GetMaterialApp(
        title: 'InstaClinic',
        debugShowCheckedModeBanner: false,
        translations: AppTranslations(),
        locale: Get.deviceLocale,
        fallbackLocale: const Locale('en', 'US'),
        theme: ThemeData(
          primaryColor: AppColors.primary,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: AppColors.primary,
            secondary: AppColors.primary,
          ),
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'Poppins',
        ),
        initialRoute: '/splash',
        getPages: [
          GetPage(name: '/splash', page: () => const SplashScreen()),
          ...AppPages.routes,
        ],
      );
    }
  }
}
