import 'package:get/get.dart';

import '../../injection.dart';
import 'l_s_controller.dart';
import 'main_controller.dart';

class GetBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => di<LSController>());
    Get.lazyPut(() => di<MainConntroller>());
  }
}
