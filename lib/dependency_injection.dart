import 'package:pemrograman_mobile/app/modules/connection/connection_binding.dart';

class DependencyInjection {
  static void init() {
    ConnectionBinding().dependencies();
  }
}
