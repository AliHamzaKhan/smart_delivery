

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Constant/Colors.dart';

class AppButton extends StatelessWidget {
  AppButton({Key? key,this.title,required this.onTap, this.child }) : super(key: key);

  String? title;
  var onTap;
  Widget? child;

  @override
  Widget build(BuildContext context) {
    var height = Get.height;

    return TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
            backgroundColor: alterColor,
            foregroundColor: alterColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    height * 0.010))),
        child: child ?? Text(title ?? '',
            style: TextStyle(
                color: subBackgroundColor,
                fontWeight: FontWeight.bold,
                fontSize: height * 0.017)),
    );
  }
}
