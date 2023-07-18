

import 'package:flutter/material.dart';

import '../Constant/Colors.dart';

apiToast(context,String? title,String?  message){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(

      backgroundColor: alterColor,
      content: Text("$title updated $message ")));
}
appToast(context,String message){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: alterColor,
      content: Text(message)));
}