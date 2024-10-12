import 'package:get/get.dart';

import '../modules/home/AddItem/bindings/add_item_binding.dart';
import '../modules/home/AddItem/views/add_item_view.dart';
import '../modules/home/EditPegawai/bindings/edit_pegawai_binding.dart';
import '../modules/home/EditPegawai/views/edit_pegawai_view.dart';
import '../modules/home/EditSupplier/bindings/edit_supplier_binding.dart';
import '../modules/home/EditSupplier/views/edit_supplier_view.dart';
import '../modules/home/History/bindings/history_binding.dart';
import '../modules/home/History/views/history_view.dart';
import '../modules/home/Journal/bindings/journal_binding.dart';
import '../modules/home/Journal/views/journal_view.dart';
import '../modules/home/Operasional/bindings/operasional_binding.dart';
import '../modules/home/Operasional/views/operasional_view.dart';
import '../modules/home/TambahOperasional/bindings/tambah_operasional_binding.dart';
import '../modules/home/TambahOperasional/views/tambah_operasional_view.dart';
import '../modules/home/TambahPegawai/bindings/tambah_pegawai_binding.dart';
import '../modules/home/TambahPegawai/views/tambah_pegawai_view.dart';
import '../modules/home/TambahSupplier/bindings/tambah_supplier_binding.dart';
import '../modules/home/TambahSupplier/views/tambah_supplier_view.dart';
import '../modules/home/account/bindings/account_binding.dart';
import '../modules/home/account/views/account_view.dart';
import '../modules/home/category/bindings/category_binding.dart';
import '../modules/home/category/views/category_view.dart';
import '../modules/home/description/bindings/description_binding.dart';
import '../modules/home/description/views/description_view.dart';
import '../modules/home/home_page/bindings/home_page_binding.dart';
import '../modules/home/home_page/views/home_page_view.dart';
import '../modules/home/login/bindings/login_binding.dart';
import '../modules/home/login/views/login_view.dart';
import '../modules/home/password_manager/bindings/password_manager_binding.dart';
import '../modules/home/password_manager/views/password_manager_view.dart';
import '../modules/home/pegawai/bindings/pegawai_binding.dart';
import '../modules/home/pegawai/views/pegawai_view.dart';
import '../modules/home/product/bindings/product_binding.dart';
import '../modules/home/product/views/product_view.dart';
import '../modules/home/product2/bindings/product2_binding.dart';
import '../modules/home/product2/views/product2_view.dart';
import '../modules/home/product3/bindings/product3_binding.dart';
import '../modules/home/product3/views/product3_view.dart';
import '../modules/home/settings/bindings/settings_binding.dart';
import '../modules/home/settings/views/settings_view.dart';
import '../modules/home/supplier/bindings/supplier_binding.dart';
import '../modules/home/supplier/views/supplier_view.dart';
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
    GetPage(
      name: _Paths.PRODUCT,
      page: () => const ProductView(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: _Paths.DESCRIPTION,
      page: () => const DescriptionView(),
      binding: DescriptionBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT2,
      page: () => const Product2View(),
      binding: Product2Binding(),
    ),
    GetPage(
      name: _Paths.PRODUCT3,
      page: () => const Product3View(),
      binding: Product3Binding(),
    ),
    GetPage(
      name: _Paths.SUPPLIER,
      page: () => const SupplierView(),
      binding: SupplierBinding(),
    ),
    GetPage(
      name: _Paths.TAMBAH_SUPPLIER,
      page: () => TambahSupplierView(),
      binding: TambahSupplierBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_SUPPLIER,
      page: () => EditSupplierView(),
      binding: EditSupplierBinding(),
    ),
    GetPage(
      name: _Paths.PEGAWAI,
      page: () => const PegawaiView(),
      binding: PegawaiBinding(),
    ),
    GetPage(
      name: _Paths.TAMBAH_PEGAWAI,
      page: () => const TambahPegawaiView(),
      binding: TambahPegawaiBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PEGAWAI,
      page: () => EditPegawaiView(),
      binding: EditPegawaiBinding(),
    ),
    GetPage(
      name: _Paths.OPERASIONAL,
      page: () => OperasionalView(),
      binding: OperasionalBinding(),
    ),
    GetPage(
      name: _Paths.TAMBAH_OPERASIONAL,
      page: () => TambahOperasionalView(),
      binding: TambahOperasionalBinding(),
    ),
    GetPage(
      name: _Paths.ADD_ITEM,
      page: () => const AddItemView(),
      binding: AddItemBinding(),
    ),
    GetPage(
      name: _Paths.HISTORY,
      page: () => const HistoryView(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: _Paths.JOURNAL,
      page: () => const JournalView(),
      binding: JournalBinding(),
    ),
  ];
}
