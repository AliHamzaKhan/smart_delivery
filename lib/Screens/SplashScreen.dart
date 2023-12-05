

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Authentication/AuthenticationManager.dart';
import '../Authentication/OnBoard.dart';
import '../Constant/Colors.dart';

class SplashScreen extends StatelessWidget {
  final AuthenticationManager authmanager = Get.put(AuthenticationManager());

  Future<void> initializeSettings() async {
    authmanager.checkLoginStatus();

    await Future.delayed(Duration(milliseconds: 1500));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthenticationManager>(builder: (controller){
      return  FutureBuilder(
        future: controller.initializeSettings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return waitingView();

          } else {
            if (snapshot.hasError)
              return errorView(snapshot);
            else
              return OnBoard();
          }
        },
      );
    });

  }

  Scaffold errorView(AsyncSnapshot<Object?> snapshot) {
    return Scaffold(
      backgroundColor: appbackgroundColor,
        body: Center(child: Text('Error: ${snapshot.error}',)));
  }

  Scaffold waitingView() {
    return Scaffold(
      backgroundColor: appbackgroundColor,
        body: Container(
          decoration: BoxDecoration(

          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                SizedBox(
                  height: Get.height * 0.5,
                  width: Get.width * 0.8,
                  child: Image.asset('assets/icons/cct_app_icon.png', fit: BoxFit.contain,),
                ),

              ],
            ),
          ),
        ));
  }
}







