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
  static const PRODUCT = _Paths.PRODUCT;
  static const DESCRIPTION = _Paths.DESCRIPTION;
  static const PRODUCT2 = _Paths.PRODUCT2;
  static const PRODUCT3 = _Paths.PRODUCT3;
  static const SUPPLIER = _Paths.SUPPLIER;
  static const TAMBAH_SUPPLIER = _Paths.TAMBAH_SUPPLIER;
  static const EDIT_SUPPLIER = _Paths.EDIT_SUPPLIER;
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
  static const PRODUCT = '/product';
  static const DESCRIPTION = '/description';
  static const PRODUCT2 = '/product2';
  static const PRODUCT3 = '/product3';
  static const SUPPLIER = '/supplier';
  static const TAMBAH_SUPPLIER = '/tambah-supplier';
  static const EDIT_SUPPLIER = '/edit-supplier';
} 
