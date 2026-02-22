import 'package:get/get.dart';

import '../modules/Shop/bindings/shop_binding.dart';
import '../modules/Shop/views/allCategory.dart';
import '../modules/Shop/views/allproducts.dart';
import '../modules/Shop/views/productsDetails.dart';
import '../modules/Shop/views/shop_view.dart';
import '../modules/aboutus/bindings/aboutus_binding.dart';
import '../modules/aboutus/views/aboutus_view.dart';
import '../modules/articles/bindings/articles_binding.dart';
import '../modules/articles/views/articles_view.dart';
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
import '../modules/bkashRate/bindings/bkash_rate_binding.dart';
import '../modules/bkashRate/views/bkash_rate_view.dart';
import '../modules/busflight/bindings/busflight_binding.dart';
import '../modules/busflight/views/busflight_view.dart';
import '../modules/changePassword/bindings/change_password_binding.dart';
import '../modules/changePassword/views/change_password_view.dart';
import '../modules/community/bindings/community_binding.dart';
import '../modules/community/views/community_view.dart';
import '../modules/communityFeed/bindings/community_feed_binding.dart';
import '../modules/communityFeed/views/community_feed_view.dart';
import '../modules/createpost/bindings/createpost_binding.dart';
import '../modules/createpost/views/createpost_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/editprofile/bindings/editprofile_binding.dart';
import '../modules/editprofile/views/editprofile_view.dart';
import '../modules/embassy/bindings/embassy_binding.dart';
import '../modules/embassy/views/embassy_view.dart';
import '../modules/essentialService/bindings/essential_service_binding.dart';
import '../modules/essentialService/views/essential_service_view.dart';
import '../modules/goldRate/bindings/gold_rate_binding.dart';
import '../modules/goldRate/views/gold_rate_view.dart';
import '../modules/help/bindings/help_binding.dart';
import '../modules/help/views/help_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/hospitals/bindings/hospitals_binding.dart';
import '../modules/hospitals/views/hospitals_view.dart';
import '../modules/informations/bindings/informations_binding.dart';
import '../modules/informations/views/informations_view.dart';
import '../modules/language/bindings/language_binding.dart';
import '../modules/language/views/language_view.dart';
import '../modules/learnarabic/bindings/learnarabic_binding.dart';
import '../modules/learnarabic/views/learnarabic_view.dart';
import '../modules/localtour/bindings/localtour_binding.dart';
import '../modules/localtour/views/localtour_view.dart';
import '../modules/namaj/bindings/namaj_binding.dart';
import '../modules/namaj/views/namaj_view.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/onboard/bindings/onboard_binding.dart';
import '../modules/onboard/views/onboard_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/ramadancalander/bindings/ramadancalander_binding.dart';
import '../modules/ramadancalander/views/ramadancalander_view.dart';
import '../modules/restaurents/bindings/restaurents_binding.dart';
import '../modules/restaurents/views/restaurents_view.dart';
import '../modules/sendotp/bindings/sendotp_binding.dart';
import '../modules/sendotp/views/sendotp_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/termsandcondition/bindings/termsandcondition_binding.dart';
import '../modules/termsandcondition/views/termsandcondition_view.dart';
import '../modules/termsandconditions/bindings/termsandconditions_binding.dart';
import '../modules/termsandconditions/views/termsandconditions_view.dart';
import '../modules/touristSpot/bindings/tourist_spot_binding.dart';
import '../modules/touristSpot/views/tourist_spot_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

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
    GetPage(
      name: _Paths.EMBASSY,
      page: () => const EmbassyView(),
      binding: EmbassyBinding(),
    ),
    GetPage(
      name: _Paths.HOSPITALS,
      page: () => const HospitalsView(),
      binding: HospitalsBinding(),
    ),
    GetPage(
      name: _Paths.RESTAURENTS,
      page: () => const RestaurentsView(),
      binding: RestaurentsBinding(),
    ),
    GetPage(
      name: _Paths.ARTICLES,
      page: () => const ArticlesView(),
      binding: ArticlesBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.CREATEPOST,
      page: () => const CreatepostView(),
      binding: CreatepostBinding(),
    ),
    GetPage(
      name: _Paths.EDITPROFILE,
      page: () => const EditprofileView(),
      binding: EditprofileBinding(),
    ),
    GetPage(
      name: _Paths.CHANGE_PASSWORD,
      page: () => const ChangePasswordView(),
      binding: ChangePasswordBinding(),
    ),
    GetPage(
      name: _Paths.TERMSANDCONDITIONS,
      page: () => const TermsandconditionsView(),
      binding: TermsandconditionsBinding(),
    ),
    GetPage(
      name: _Paths.HELP,
      page: () => const HelpView(),
      binding: HelpBinding(),
    ),
    GetPage(
      name: _Paths.ABOUTUS,
      page: () => const AboutusView(),
      binding: AboutusBinding(),
    ),
    GetPage(
      name: _Paths.LANGUAGE,
      page: () => const LanguageView(),
      binding: LanguageBinding(),
    ),
    GetPage(
      name: _Paths.SHOP,
      page: () => const ShopView(),
      binding: ShopBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_DETAILS,
      page: () => const ProductDetailsView(),
    ),
    GetPage(
      name: _Paths.ALL_PRODUCTS,
      page: () => const AllProductsView(),
      binding: ShopBinding(), // Reusing ShopBinding
    ),
    GetPage(
      name: _Paths.ALL_CATEGORIES,
      page: () => const AllCategoriesView(),
      binding: ShopBinding(), // Reusing ShopBinding for categories data
    ),
    GetPage(
      name: _Paths.COMMUNITY_FEED,
      page: () => const CommunityFeedView(),
      binding: CommunityFeedBinding(),
    ),
    GetPage(
      name: _Paths.NAMAJ,
      page: () => const NamajView(),
      binding: NamajBinding(),
    ),
    GetPage(
      name: _Paths.BKASH_RATE,
      page: () => const BkashRateView(),
      binding: BkashRateBinding(),
    ),
    GetPage(
      name: _Paths.GOLD_RATE,
      page: () => const GoldRateView(),
      binding: GoldRateBinding(),
    ),
    GetPage(
      name: _Paths.RAMADANCALANDER,
      page: () => const RamadancalanderView(),
      binding: RamadancalanderBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
  ];
}
