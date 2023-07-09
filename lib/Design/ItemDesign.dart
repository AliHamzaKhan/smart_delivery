import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_delivery/Constant/Colors.dart';
import '../Model/DeliveryItem.dart';

class ItemDesign extends StatelessWidget {
  ItemDesign({Key? key, this.item, this.image, this.orderController, this.onImageSelect})
      : super(key: key);
  ItemData? item;
  var image;
  var height = Get.height;
  var orderController;
  var onImageSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          color: subBackgroundColor),
      child: Row(
        children: [
          Text(
            "${item!.itemId ?? ''}",
            style: TextStyle(
                color: alterColor, fontWeight: FontWeight.bold, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
              flex: 3,
              child: Text(
                item!.itemName ?? "",
                style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w300,
                    fontSize: 15),
                textAlign: TextAlign.start,
              )),
          Expanded(
              flex: 1,
              child: Text(
                item!.itemUnit ?? "",
                style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w300,
                    fontSize: 15),
                textAlign: TextAlign.center,
              )),
          Expanded(
              flex: 1,
              child: Text(
                "${item!.qty ?? ''}",
                style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w300,
                    fontSize: 15),
                textAlign: TextAlign.center,
              )),
          GestureDetector(
            onTap: () async {
              image = await getFromCamera();
              onImageSelect(image);
            },
            child: Container(
              width: height * 0.050,
              height: height * 0.050,
              child: image == null
                  ? Icon(
                Icons.image,
                size: height * 0.040,
              )
                  : Image.file(
                image,
                width: height * 0.040,
                height: height * 0.040,
                fit: BoxFit.cover,
              ),
            ),
          )
        ],
      ),
    );
  }
  
  Future<File?> getFromCamera() async {
    var pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      return imageFile;
    } else {
      return null;
    }
  }
}
