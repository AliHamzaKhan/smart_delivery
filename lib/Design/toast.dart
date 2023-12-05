

import 'package:flutter/material.dart';
import '../Constant/Colors.dart';

apiToast(context,String? title,String?  message, {int? seconds}){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: alterColor,
      content: Text("$title updated $message "),
      duration: Duration(seconds: seconds ?? 2),
  ));
}
appToast(context,String message, {seconds}){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: alterColor,
      content: Text(message),
    duration: Duration(seconds: seconds ?? 2),));
}