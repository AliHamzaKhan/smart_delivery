import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Constant/Colors.dart';
import '../Controller/AskLocation.dart';
import '../Model/Task.dart';
import '../Screens/NewOrderScreen.dart';
import '../main.dart';

class Api {
  static const String BASE_URL = "https://thedessertempire.com/delivery-system/index.php?";
  static const String LOGIN_URL =
      "https://thedessertempire.com/delivery-system/index.php?method=login";
  static const String DELIVERY_ORDERS =
      "https://thedessertempire.com/delivery-system/index.php?method=driverdelivery&username=driver2";

  Task? tasks;

  Api();

  Future<void> login({username1, password1, save}) async {
    authController.setLoading(false);
    appDebugPrint("$username1 $password1 $save");
    appDebugPrint("$BASE_URL");
    try {
      var response = await http.post(
        Uri.parse(
            "${BASE_URL}method=login&username=$username1&password=$password1"),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        appDebugPrint("data $data");
        if (data["status_message"] == "user authenticated") {
          if (save) {
            await authmanager.login(username1);

            Get.toNamed('/new_order_screen');
          }
          await authmanager.login(username1);

          Get.toNamed('/new_order_screen');
        } else {
          ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
              duration: Duration(seconds: 3),
              backgroundColor: subBackgroundColor,
              content: Text(
                'username/password incorrect',
                textAlign: TextAlign.center,
                style: TextStyle(color: alterColor),
              )));
          appDebugPrint("username/password incorrect");
        }
        appDebugPrint("login failed");
      }
      authController.setLoading(true);
    } catch (e) {
      authController.setLoading(true);
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
          duration: Duration(seconds: 3),
          backgroundColor: subBackgroundColor,
          content: Text(
            '${e.toString()}',
            textAlign: TextAlign.center,
            style: TextStyle(color: alterColor),
          )));
      appDebugPrint("login failed due to ${e.toString()}");
    } finally {
      authController.setLoading(true);
    }
  }
}
