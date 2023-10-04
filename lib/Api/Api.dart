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
  // static String LOGIN_URL = "http://easyrouteplan.com/api/index.php?method=login&username=driver1&password=driver1";
  static const String BASE_URL = "http://easyrouteplan.com/api/index.php?";
  static const String LOGIN_URL =
      "http://easyrouteplan.com/api/index.php?method=login";
  static const String DELIVERY_ORDERS =
      "http://easyrouteplan.com/api/index.php?method=driverdelivery&username=driver2";

  Task? tasks;

  Api();

  Future<void> login({username1, password1, save}) async {
    authController.setLoading(false);
    print("$username1 $password1 $save");
    try {
      var response = await http.post(
        Uri.parse(
            "${BASE_URL}method=login&username=$username1&password=$password1"),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print("data $data");
        if (data["status_message"] == "user authenticated") {
          if (save) {
            await authmanager.login(username1);

            Get.toNamed('/new_order_screen');
            // Get.offAll(() => NewOrderScreen());
          }
          await authmanager.login(username1);

          Get.toNamed('/new_order_screen');
          // Get.offAll(() => NewOrderScreen());
        } else {
          ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
              duration: Duration(seconds: 3),
              backgroundColor: subBackgroundColor,
              content: Text(
                'username/password incorrect',
                textAlign: TextAlign.center,
                style: TextStyle(color: alterColor),
              )));
          print("username/password incorrect");
        }
        print("login failed");
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
      print("login failed due to ${e.toString()}");
    } finally {
      authController.setLoading(true);
    }
  }
}
