part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const LOGIN = _Paths.LOGIN;
  static const HOME_PAGE = _Paths.HOME_PAGE;
  static const ACCOUNT = _Paths.ACCOUNT;
  static const PASSWORD_MANAGER = _Paths.PASSWORD_MANAGER;
  static const YOUR_PROFILE = _Paths.YOUR_PROFILE;
  static const SETTINGS = _Paths.SETTINGS;
  static const CATEGORY = _Paths.CATEGORY;
}

abstract class _Paths {
  _Paths._();
  static const LOGIN = '/login';
  static const HOME_PAGE = '/home-page';
  static const ACCOUNT = '/account';
  static const PASSWORD_MANAGER = '/password-manager';
  static const YOUR_PROFILE = '/your-profile';
  static const SETTINGS = '/settings';
  static const CATEGORY = '/category';
}
