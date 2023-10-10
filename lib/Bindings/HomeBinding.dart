

import 'package:get/get.dart';

import '../Controller/AskLocation.dart';
import '../Controller/OrderController.dart';
class HomeBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>OrderController());
  }

}