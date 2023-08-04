

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Authentication/AuthenticationManager.dart';
import '../Authentication/OnBoard.dart';
import '../Constant/Colors.dart';

class SplashScreen extends StatelessWidget {
  final AuthenticationManager authmanager = Get.put(AuthenticationManager());

  Future<void> initializeSettings() async {
    authmanager.checkLoginStatus();

    //Simulate other services for 3 seconds
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
                Center(child: Text("Smart Delivery", style: TextStyle(color: alterColor, fontSize: 30, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal, letterSpacing: 5),)),
                SizedBox(height: 100),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(color: alterColor,),
                ),
                SizedBox(height: 5),
                Text("Loading...", style: TextStyle(color: alterColor),),
              ],
            ),
          ),
        ));
  }
}







