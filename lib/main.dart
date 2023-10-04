import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_delivery/Controller/OrderController.dart';

import 'Authentication/AuthenticationManager.dart';
import 'Bindings/HomeBinding.dart';
import 'Constant/MyRoutes.dart';
import 'Controller/AskLocation.dart';
import 'Controller/AuthController.dart';
import 'Controller/order_controller_service.dart';
import 'Screens/NewOrderRunningScreen.dart';
import 'Screens/SplashScreen.dart';
import 'Utils/MyTheme.dart';


AuthenticationManager authmanager = Get.put(AuthenticationManager());

AuthController authController = Get.put(AuthController());


Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(AskPermission());
  // Get.put(OrderControllerService(), permanent: true);
  await GetStorage.init();
  runApp(const MyApp());
}

appDebugPrint(msg){
  if(kDebugMode){
    print(msg);
  }
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Smart Delivery',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      getPages: MyRoutes.routes,
      initialBinding: HomeBinding(),
      initialRoute: MyRoutes.initial,
      builder: EasyLoading.init(),
      // home: NewOrderRunningScreen(orderController: Get.put(OrderController()),),
      // home: SplashScreen(),
      //    home: TaskScreen(),
    );
  }
}


