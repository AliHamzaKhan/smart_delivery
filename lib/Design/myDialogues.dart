import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:signature/signature.dart';

import '../Constant/Colors.dart';

showUploadType(context, {orderController, deliveryId}) {
  var height = Get.height;
  bool isSignature = false;
  bool isUploadImage = false;
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          backgroundColor: appbackgroundColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Center(
              child: Text(
            "Select Upload Type",
            style: TextStyle(
                color: alterColor,
                fontSize: height * 0.025,
                fontWeight: FontWeight.bold),
          )),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                height: (isUploadImage || isSignature)
                    ? height * 0.7
                    : height * 0.3,
                alignment: Alignment.bottomCenter,
                width: Get.width,
                padding: EdgeInsets.all(height * 0.020),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if(isSignature)
                      uploadSignatureDialogue(),

                    if(isUploadImage)
                      uploadImageDialogue(),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () async {
                              setState(() {
                                isUploadImage = true;
                                isSignature = false;
                              });
                            },
                            style: TextButton.styleFrom(
                                backgroundColor: alterColor,
                                foregroundColor: alterColor,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Text(
                                "Image",
                                style: TextStyle(color: appbackgroundColor),
                              ),
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        TextButton(
                            onPressed: () async {
                             setState((){
                               isUploadImage = false;
                               isSignature = true;
                             });
                            },
                            style: TextButton.styleFrom(
                                backgroundColor: alterColor,
                                foregroundColor: alterColor,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Text(
                                "Signature",
                                style: TextStyle(color: subBackgroundColor),
                              ),
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        TextButton(
                            onPressed: () async {
                              isUploadImage = false;
                              isSignature = false;
                              Get.back();
                            },
                            style: TextButton.styleFrom(
                                backgroundColor: subBackgroundColor,
                                foregroundColor: subBackgroundColor,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Text(
                                "Skip",
                                style: TextStyle(color: alterColor),
                              ),
                            )),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        );
      });
}

uploadImageDialogue({setState, deliveryId, orderController}) {
  File? image;
  bool upload = false;
  var height = Get.height;
  return ModalProgressHUD(
    inAsyncCall: upload,
    child: Container(
      height: height * 0.5,
      width: Get.width,
      margin: EdgeInsets.symmetric(vertical: height * 0.010),
      child: Column(
        children: [
          // SizedBox(width: height * 0.020),
          Text(
            "Upload Picture",
            style: TextStyle(
                color: alterColor,
                fontSize: height * 0.025,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(width: height * 0.020),
          image == null
              ? Icon(
            Icons.image,
            size: height * 0.2,
          )
              : Image.file(
            image!,
            width: Get.width * 0.8,
            height: height * 0.5,
            fit: BoxFit.cover,
          ),
          SizedBox(width: height * 0.020),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () async {
                    if (image == null) {
                      image =
                      await orderController.getFromCamera();
                      setState(() {});
                    } else {
                      setState(() {
                        upload = true;
                      });

                      await orderController.uploadImage(
                          deliveryId: deliveryId, image: image);
                      setState(() {
                        upload = false;
                      });
                      Get.back();
                    }
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: subBackgroundColor,
                      foregroundColor: subBackgroundColor,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    child: Text(
                      image == null ? 'Get Image' : 'Upload',
                      // 'Upload',
                      style: TextStyle(color: alterColor),
                    ),
                  )),

            ],
          )
        ],
      ),
    ),
  );
}

uploadSignatureDialogue({orderController, deliveryId}) {
  var height = Get.height;
  return Column(
    children: [
      Container(
        width: Get.width,
        height: height * 0.5,
        padding: EdgeInsets.symmetric(
            horizontal: height * 0.020, vertical: height * 0.020),
        decoration: BoxDecoration(
            color: subBackgroundColor,
            borderRadius: BorderRadius.circular(height * 0.020)),
        child: Signature(
          width: Get.width - 40,
          height: height * 0.4,
          // controller: orderController.signatureController,
          controller: SignatureController(),
          backgroundColor: subBackgroundColor,
          dynamicPressureSupported: false,
        ),
      ),
      SizedBox(height: height * 0.020),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
              onPressed: () async {
                await orderController.uploadSignature(
                    deliveryId: deliveryId);
                Get.back();
              },
              style: TextButton.styleFrom(
                  backgroundColor: subBackgroundColor,
                  foregroundColor: subBackgroundColor,
                  padding: EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(10))),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                child: Text(
                  "Save",
                  style: TextStyle(color: alterColor),
                ),
              )),

        ],
      ),
      SizedBox(height: height * 0.020),
    ],
  );
}
