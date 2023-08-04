

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Constant/Colors.dart';


TextStyle mainHeadStyle = TextStyle(
  color: textColor,
  fontSize: 25,
  fontWeight: FontWeight.bold
);
TextStyle headStyle = TextStyle(
    color: alterColor,
    fontSize: 20,
    fontWeight: FontWeight.bold
);
TextStyle subStyle = TextStyle(
    color: alterColor,
    fontSize: 18,
    fontWeight: FontWeight.bold
);
TextStyle smallStyle = TextStyle(
    color: textColor,
    fontSize: 15,
    fontWeight: FontWeight.bold
);
TextStyle registryPage = TextStyle(
    color: textColor,
    fontSize: 18,
    fontWeight: FontWeight.bold
);

statusView({deliveryId}) {
  var height = Get.height;
  switch (deliveryId) {
    case 6:
      return Text(
        "Failed",
        style: TextStyle(
            color: Colors.redAccent.shade700,
            fontSize: height * 0.018,
            fontWeight: FontWeight.bold),
      );
    case 5:
      return Text(
        "Completed",
        style: TextStyle(
            color: Colors.green.shade900,
            fontSize: height * 0.018,
            fontWeight: FontWeight.bold),
      );
    case 3:
      return Text(
        "Todo",
        style: TextStyle(
            color: alterColor,
            fontSize: height * 0.018,
            fontWeight: FontWeight.bold),
      );
    case 8:
      return Text(
        "Arrived",
        style: TextStyle(
            color: Colors.green.shade900,
            fontSize: height * 0.018,
            fontWeight: FontWeight.bold),
      );
    default:
      return Text("Departed",
          style: TextStyle(
              color: Colors.green,
              fontSize: height * 0.018,
              fontWeight: FontWeight.bold));
  }
}