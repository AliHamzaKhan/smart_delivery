

import 'package:get/get.dart';
import 'package:smart_delivery/Bindings/HomeBinding.dart';
import '../Screens/LoginScreen.dart';
import '../Screens/NewOrderRunningScreen.dart';
import '../Screens/NewOrderScreen.dart';
import '../Screens/SplashScreen.dart';

class MyRoutes{

  static const String initial = '/splash_screen';
  static final routes = [
    GetPage(name: "/login_screen", page:()=> LoginScreen()),
    GetPage(name: "/splash_screen", page:()=> SplashScreen()),
    GetPage(name: "/new_order_screen", page:()=> NewOrderScreen(), binding: HomeBinding()),
  ];
}