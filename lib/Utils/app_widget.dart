import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../Constant/Colors.dart';

getTableWidget(first, second, {textSize, textColor,maxLines}) {
  var height = Get.height;
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '${first} : ',
        style: TextStyle(
            color: textColor ?? textColor,
            fontSize: height * (textSize ?? 0.015),
            fontWeight: FontWeight.bold),
        maxLines: 1,
      ),
      Expanded(
        child: Text(
          second,
          style: TextStyle(
            color: textColor ?? textColor,
            fontSize: height * (textSize ?? 0.015),
          ),
          maxLines: maxLines ?? 2,
        ),
      ),
    ],
  );
}
