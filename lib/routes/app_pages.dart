import 'package:get/get.dart';
import '../views/auth/login_view.dart';
import '../views/auth/reset_password.dart';
import '../views/auth/signup_view.dart';
import '../views/auth/otp_verification_view.dart';
import '../views/auth/profile_completion_view.dart';
import '../views/dialysis/dialysis_booking_view.dart';
import '../views/emergancy/confirm_book_eme.dart';
import '../views/home/home_view.dart';
import '../views/booking/booking_view.dart';
import '../views/booking/confirmation_view.dart';
import '../views/address/address_view.dart';
import '../views/payment/payment_view.dart';
import '../views/payment/test_payment_view.dart';
import '../views/profile/profile_view.dart';
import '../views/splash/splash_view.dart';
import '../controllers/auth_controller.dart';
import '../controllers/booking_controller.dart';
import '../controllers/address_controller.dart';
import '../controllers/payment_controller.dart';
import '../controllers/profile_controller.dart';
import '../views/web/login_view.dart';
import '../controllers/specialized_booking_controller.dart';
import '../views/mainScreen/mainscreen.dart';
part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.LOGIN;
  static const String SPLASH = '/splash';
  static const String LOGIN = '/login';
  static const String SIGNUP = '/signup';
  static const String OTP_VERIFICATION = '/otp-verification';
  static const String PROFILE_COMPLETION = '/profile-completion';
  static const String HOME = '/home';
  static const String MAINSCREEN = '/mainScreen';
  static const String BOOKING = '/booking';
  static const String BOOKING_CONFIRMATION = '/booking/confirmation';
  static const String DIALYSIS_BOOKING = '/dialysis-booking';
  static const String EME_BOOKING_CONFIRMATION = '/eme-booking-confirmation';
  static const String ADDRESS = '/address';
  static const String PAYMENT = '/payment';
  static const String TEST_PAYMENT = '/test-payment';
  static const String PROFILE = '/profile';
  static const String RESET_PASSWORD = '/reset-password';

  static final routes = [
    // Splash Route
    GetPage(
      name: SPLASH,
      page: () => const SplashView(),
    ),

    // Auth Routes
    GetPage(
      name: LOGIN,
      page: () => const LoginView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AuthController>(() => AuthController());
      }),
    ),
    GetPage(
      name: SIGNUP,
      page: () => const SignUpView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AuthController>(() => AuthController());
      }),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: OTP_VERIFICATION,
      page: () => const OTPVerificationView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AuthController>(() => AuthController());
      }),
    ),
    GetPage(
      name: PROFILE_COMPLETION,
      page: () => const ProfileCompletionView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AuthController>(() => AuthController());
      }),
    ),
    GetPage(
      name: MAINSCREEN,
      page: () => const MainScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AuthController>(() => AuthController());
      }),
    ),

    // Main Routes
    GetPage(
      name: HOME,
      page: () => HomeView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AuthController>(() => AuthController());
        Get.lazyPut<BookingController>(() => BookingController());
      }),
      transition: Transition.fadeIn,
    ),

    // Booking Routes
    GetPage(
      name: BOOKING,
      page: () => const BookingView(),
      binding: BindingsBuilder(() {
        Get.put(BookingController());
      }),
    ),
    GetPage(
      name: BOOKING_CONFIRMATION,
      page: () => ConfirmationView(),
      binding: BindingsBuilder(() {
        Get.put(BookingController());
      }),
    ),

    GetPage(
      name: DIALYSIS_BOOKING,
      page: () => const DialysisBookingView(),
      binding: BindingsBuilder(() {
        Get.put(BookingController());
      }),
    ),
    GetPage(
      name: EME_BOOKING_CONFIRMATION,
      page: () => EmeBookingConfirmationView(),
      binding: BindingsBuilder(() {
        Get.put(BookingController());
      }),
    ),

    // Address Route
    GetPage(
      name: ADDRESS,
      page: () => const AddressView(),
      binding: BindingsBuilder(() {
        Get.put(AddressController());
      }),
    ),
    // Payment Route
    GetPage(
      name: PAYMENT,
      page: () => PaymentView(),
      binding: BindingsBuilder(() {
        Get.put(PaymentController());
      }),
    ),

    // Profile Route
    GetPage(
      name: PROFILE,
      page: () => const ProfileView(),
    ),

    // Web Routes
    GetPage(
      name: Routes.LOGIN,
      page: () => WebLoginView(),
    ),
    // GetPage(
    //   name: Routes.DASHBOARD,
    //   page: () =>  WebDashboardView(),
    // ),
  ];
}
