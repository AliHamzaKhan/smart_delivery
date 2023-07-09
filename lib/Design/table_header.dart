

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Constant/Colors.dart';

tableHeader(){
  return  Container(
    width: Get.width,
    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    margin: EdgeInsets.symmetric(horizontal: 5),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        color: subBackgroundColor),
    child: Row(
      children: [
        Text("ID",style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.center,),
        SizedBox(width: 10,),
        Expanded(flex: 3, child: Text('NAME',  style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.center,)),
        Expanded(flex: 1, child: Text('UNIT', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.center,)),
        Expanded(flex: 1, child: Text('QTY', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.center,)),
        Container(
          width: 50,
          height: 50,
          alignment: Alignment.center,
          child: Icon(Icons.image_outlined, color: textColor, size: 30,),
        )
      ],
    ),
  );
}