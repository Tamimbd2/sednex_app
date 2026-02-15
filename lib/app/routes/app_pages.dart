import 'package:get/get.dart';

import '../modules/auth/resetpassword/bindings/resetpassword_binding.dart';
import '../modules/auth/resetpassword/views/resetpassword_view.dart';
import '../modules/auth/signin/bindings/signin_binding.dart';
import '../modules/auth/signin/views/signin_view.dart';
import '../modules/auth/signup/bindings/signup_binding.dart';
import '../modules/auth/signup/views/signup_view.dart';
import '../modules/auth/verifyotp/bindings/verifyotp_binding.dart';
import '../modules/auth/verifyotp/views/verifyotp_view.dart';
import '../modules/basicgoods/bindings/basicgoods_binding.dart';
import '../modules/basicgoods/views/basicgoods_view.dart';
import '../modules/busflight/bindings/busflight_binding.dart';
import '../modules/busflight/views/busflight_view.dart';
import '../modules/community/bindings/community_binding.dart';
import '../modules/community/views/community_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/essentialService/bindings/essential_service_binding.dart';
import '../modules/essentialService/views/essential_service_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/informations/bindings/informations_binding.dart';
import '../modules/informations/views/informations_view.dart';
import '../modules/learnarabic/bindings/learnarabic_binding.dart';
import '../modules/learnarabic/views/learnarabic_view.dart';
import '../modules/localtour/bindings/localtour_binding.dart';
import '../modules/localtour/views/localtour_view.dart';
import '../modules/onboard/bindings/onboard_binding.dart';
import '../modules/onboard/views/onboard_view.dart';
import '../modules/sendotp/bindings/sendotp_binding.dart';
import '../modules/sendotp/views/sendotp_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/termsandcondition/bindings/termsandcondition_binding.dart';
import '../modules/termsandcondition/views/termsandcondition_view.dart';
import '../modules/touristSpot/bindings/tourist_spot_binding.dart';
import '../modules/touristSpot/views/tourist_spot_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.ESSENTIAL_SERVICE;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARD,
      page: () => const OnboardView(),
      binding: OnboardBinding(),
    ),
    GetPage(
      name: _Paths.TERMSANDCONDITION,
      page: () => const TermsandconditionView(),
      binding: TermsandconditionBinding(),
    ),
    GetPage(
      name: _Paths.SIGNIN,
      page: () => const SigninView(),
      binding: SigninBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => const SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.SENDOTP,
      page: () => const SendotpView(),
      binding: SendotpBinding(),
    ),
    GetPage(
      name: _Paths.VERIFYOTP,
      page: () => const VerifyotpView(),
      binding: VerifyotpBinding(),
    ),
    GetPage(
      name: _Paths.RESETPASSWORD,
      page: () => const ResetpasswordView(),
      binding: ResetpasswordBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.ESSENTIAL_SERVICE,
      page: () => const EssentialServiceView(),
      binding: EssentialServiceBinding(),
    ),
    GetPage(
      name: _Paths.COMMUNITY,
      page: () => const CommunityView(),
      binding: CommunityBinding(),
    ),
    GetPage(
      name: _Paths.LEARNARABIC,
      page: () => const LearnarabicView(),
      binding: LearnarabicBinding(),
    ),
    GetPage(
      name: _Paths.TOURIST_SPOT,
      page: () => const TouristSpotView(),
      binding: TouristSpotBinding(),
    ),
    GetPage(
      name: _Paths.BUSFLIGHT,
      page: () => const BusflightView(),
      binding: BusflightBinding(),
    ),
    GetPage(
      name: _Paths.LOCALTOUR,
      page: () => const LocaltourView(),
      binding: LocaltourBinding(),
    ),
    GetPage(
      name: _Paths.BASICGOODS,
      page: () => const BasicgoodsView(),
      binding: BasicgoodsBinding(),
    ),
    GetPage(
      name: _Paths.INFORMATIONS,
      page: () => const InformationsView(),
      binding: InformationsBinding(),
    ),
  ];
}
