import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Screens/LoginScreen.dart';
import '../Screens/NewOrderScreen.dart';
import '../main.dart';

class OnBoard extends StatelessWidget {
  OnBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => authmanager.isLogged.value ? NewOrderScreen() : LoginScreen());
  }
}
