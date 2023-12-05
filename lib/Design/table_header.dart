

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Constant/Colors.dart';

tableHeader(){
  var height = Get.height;
  return  Container(
    width: Get.width,
    padding: EdgeInsets.symmetric(vertical: height * 0.005, horizontal: height * 0.010),
    margin: EdgeInsets.symmetric(horizontal: height * 0.005),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(height * 0.010),
          topRight: Radius.circular(height * 0.010),
        ),
        color: subBackgroundColor),
    child: Row(
      children: [
        SizedBox(
          width: height * 0.010,
        ),
        Expanded(flex: 3, child: Text('ITEM',  style: TextStyle(color: alterColor, fontWeight: FontWeight.bold, fontSize: height * 0.018), textAlign: TextAlign.left,)),
        Expanded(flex: 1, child: Text('UNIT', style: TextStyle(color: alterColor, fontWeight: FontWeight.bold, fontSize:  height * 0.018), textAlign: TextAlign.center,)),
        Expanded(flex: 2, child: Text('QTY', style: TextStyle(color: alterColor, fontWeight: FontWeight.bold, fontSize:  height * 0.018), textAlign: TextAlign.center,)),
        Container(
          width: height * 0.050,
          height: height * 0.050,
          alignment: Alignment.center,
        )
      ],
    ),
  );
}