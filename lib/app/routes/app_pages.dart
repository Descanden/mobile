import 'package:get/get.dart';

import '../modules/home/account/bindings/account_binding.dart';
import '../modules/home/account/views/account_view.dart';
import '../modules/home/category/bindings/category_binding.dart';
import '../modules/home/category/views/category_view.dart';
import '../modules/home/home_page/bindings/home_page_binding.dart';
import '../modules/home/home_page/views/home_page_view.dart';
import '../modules/home/login/bindings/login_binding.dart';
import '../modules/home/login/views/login_view.dart';
import '../modules/home/password_manager/bindings/password_manager_binding.dart';
import '../modules/home/password_manager/views/password_manager_view.dart';
import '../modules/home/settings/bindings/settings_binding.dart';
import '../modules/home/settings/views/settings_view.dart';
import '../modules/home/your_profile/bindings/your_profile_binding.dart';
import '../modules/home/your_profile/views/your_profile_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.ACCOUNT,
      page: () => AccountView(),
      binding: AccountBinding(),
    ),
    GetPage(
      name: _Paths.PASSWORD_MANAGER,
      page: () => PasswordManagerView(),
      binding: PasswordManagerBinding(),
    ),
    GetPage(
      name: _Paths.YOUR_PROFILE,
      page: () => YourProfileView(),
      binding: YourProfileBinding(),
    ),
    GetPage(
      name: _Paths.HOME_PAGE,
      page: () => const HomePageView(),
      binding: HomePageBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.CATEGORY,
      page: () => const CategoryView(),
      binding: CategoryBinding(),
    ),
  ];
}
