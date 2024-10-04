part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME_PAGE = _Paths.HOME_PAGE;
  static const ACCOUNT = _Paths.ACCOUNT;
  static const PASSWORD_MANAGER = _Paths.PASSWORD_MANAGER;
}

abstract class _Paths {
  _Paths._();
  static const HOME_PAGE = '/home-page';
  static const ACCOUNT = '/account';
  static const PASSWORD_MANAGER = '/password-manager';
}
