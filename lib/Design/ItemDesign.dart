import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_delivery/Constant/Colors.dart';
import '../Model/DeliveryItem.dart';

class ItemDesign extends StatefulWidget {
  ItemDesign({Key? key, this.item, this.image, this.orderController, this.onImageSelect, this.onQuantitySelected})
      : super(key: key);
  ItemData? item;
  File? image;
  var orderController;
  var onImageSelect;
  var onQuantitySelected;
  var quantityController = TextEditingController();

  @override
  State<ItemDesign> createState() => _ItemDesignState();
}

class _ItemDesignState extends State<ItemDesign> {
  var height = Get.height;

  @override
  Widget build(BuildContext context) {
    widget.quantityController.text =  widget.item!.qty.toString();
    return Container(
      width: Get.width,
      padding: EdgeInsets.symmetric(vertical: height * 0.007, horizontal: height * 0.010),
      margin: EdgeInsets.symmetric(horizontal: height * 0.005),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(height * 0.010),
            bottomRight: Radius.circular(height * 0.010),
          ),
          color: subBackgroundColor),
      child: Row(
        children: [
          SizedBox(
            width: height * 0.005,
          ),
          Expanded(
              flex: 3,
              child: Text(
                widget.item!.itemName ?? "",
                style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w300,
                    fontSize: height * 0.015),
                textAlign: TextAlign.start,
              )),
          Expanded(
              flex: 1,
              child: Text(
                widget.item!.itemUnit ?? "",
                style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w300,
                    fontSize: height * 0.015),
                textAlign: TextAlign.center,
              )),
          // Expanded(
          //     flex: 1,
          //     child: Text(
          //       "${widget.item!.qty ?? ''}",
          //       style: TextStyle(
          //           color: textColor,
          //           fontWeight: FontWeight.w300,
          //           fontSize: height * 0.015),
          //       textAlign: TextAlign.center,
          //     )),
          Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: height * 0.015),
                child: TextField(
                  controller: widget.quantityController,
                   autofocus: true,
                   textAlign: TextAlign.center,
                   keyboardType: TextInputType.numberWithOptions(decimal: false),
                   onChanged: widget.onQuantitySelected,
                   cursorColor: alterColor,
                   inputFormatters: [
                     FilteringTextInputFormatter.allow(RegExp('[0-9.,]'))
                   ],
                   decoration: InputDecoration(
                     border: UnderlineInputBorder(
                       borderSide: BorderSide(
                         color: alterColor
                       ),

                     ),
                     focusedBorder: UnderlineInputBorder(
                       borderSide: BorderSide(
                           color: alterColor
                       ),

                     ),
                   ),
                  style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w300,
                          fontSize: height * 0.015),
                ),
              ),
              // child: Text(
              //   "${widget.item!.qty ?? ''}",
              //   style: TextStyle(
              //       color: textColor,
              //       fontWeight: FontWeight.w300,
              //       fontSize: height * 0.015),
              //   textAlign: TextAlign.center,
              // )
          ),
          GestureDetector(
            onTap: () async {
              widget.image = await getFromCamera();
              setState(() {
                widget.onImageSelect(widget.image);
              });
            },
            child: Container(
              width: height * 0.050,
              height: height * 0.050,
              child: widget.image == null
                  ? Icon(
                Icons.image,
                size: height * 0.040,
              )
                  : ClipRRect(
                borderRadius: BorderRadius.circular(5),
                    child: Image.file(
                widget.image!,
                width: height * 0.040,
                height: height * 0.035,
                fit: BoxFit.cover,
              ),
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
      imageQuality: 60,
    );
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      return imageFile;
    } else {
      return null;
    }
  }
}
