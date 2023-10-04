import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

import '../Constant/Colors.dart';

getTableWidget(first, second, {textSize, color, maxLines}) {
  var height = Get.height;
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '${first} : ',
        style: TextStyle(
            color: color ?? textColor,
            fontSize: height * (textSize ?? 0.015),
            fontWeight: FontWeight.bold),
        // maxLines: 1,
      ),
      Expanded(
        // child: ReadMoreText(
        //   second,
        //   trimLines: 2,
        //   trimMode: TrimMode.Line,
        //   trimCollapsedText: 'Show more',
        //   trimExpandedText: '...Show less',
        //   // style: TextStyle(
        //   //   color: color ?? textColor,
        //   //   fontSize: height * (textSize ?? 0.015),
        //   // ),
        //   // moreStyle: TextStyle(fontSize: 0.016, fontWeight: FontWeight.bold, color: alterColor),
        //   // lessStyle: TextStyle(fontSize: 0.016, fontWeight: FontWeight.bold, color: alterColor),
        //   preDataTextStyle: TextStyle(fontWeight: FontWeight.w500),
        //   style: TextStyle(color: Colors.black),
        //   colorClickableText: Colors.pink,
        // ),
        child: Text(
          second,
          style: TextStyle(
            color: color ?? textColor,
            fontSize: height * (textSize ?? 0.015),
          ),
          // maxLines: maxLines ?? 2,
        ),
      ),
    ],
  );
}
