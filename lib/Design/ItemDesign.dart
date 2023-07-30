import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_delivery/Constant/Colors.dart';
import '../Api/MyApi.dart';
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
    print(MyApi.IMAGE_BASE_URL + widget.item!.photopath!);
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
          

          Expanded(
              flex: 2,
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(

                onTap: (){
                  setState(() {
                    widget.item!.qty =  widget.item!.qty! + 1 ;
                    widget.onQuantitySelected(widget.item!.qty!);
                  });

                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  // width: Get.height * 0.015,
                  // height: Get.height * 0.020,
                  padding: EdgeInsets.symmetric(
                    horizontal: height * 0.005
                  ),
                  color: appbackgroundColor,
                  child: Text('+', style: TextStyle(color: alterColor, fontSize: height * 0.030),),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: height * 0.010
                ),
                child : AnimatedSwitcher(
                  duration: Duration(milliseconds: 200),
                    transitionBuilder: (Widget child, Animation<double> animation){
                      return SlideTransition(
                        child: child,
                        position: Tween<Offset>(
                            begin: Offset(0.0, -0.5),
                            end: Offset(0.0, 0.0))
                            .animate(animation),
                      );
                    },
                  child: Text(
                "${widget.item!.qty ?? ''}",
                    key: ValueKey<String>(widget.item!.qty.toString()),
                  style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: height * 0.025),
                  textAlign: TextAlign.center,
                ),
                ),

              ),
              GestureDetector(
                onTap: (){
                  if(widget.item!.qty! <= 0){
                    return;
                  }
                  setState(() {
                    widget.item!.qty =  widget.item!.qty! - 1 ;
                    widget.onQuantitySelected(widget.item!.qty!);
                  });

                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  // width: Get.height * 0.015,
                  // height: Get.height * 0.020,
                  margin: EdgeInsets.only(
                    right: height * 0.005
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: height * 0.005
                  ),
                  color: appbackgroundColor,
                  child: Text('−', style: TextStyle(color: alterColor, fontSize: height * 0.030),),
                ),
              ),
            ],
          )),
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
              child : widget.image == null ?
              // CachedNetworkImage(
              //   imageUrl: MyApi.IMAGE_BASE_URL + widget.item!.photopath!,
              //   imageBuilder: (context, imageProvider) => Container(
              //     width: height * 0.050,
              //     height: height * 0.050,
              //     decoration: BoxDecoration(
              //       image: DecorationImage(
              //           image: imageProvider,
              //           fit: BoxFit.cover,
              //       ),
              //     ),
              //   ),
              //   placeholder: (context, url) => Icon(
              //     Icons.image,
              //     size: height * 0.040,
              //   ),
              //   errorWidget: (context, url, error) =>  Icon(
              //     Icons.image,
              //     size: height * 0.040,
              //   ),
              // )
              ClipRRect(
                 borderRadius: BorderRadius.circular(height * 0.005),
                child: Image.network(
                  width: height * 0.050,
                  height: height * 0.050,
                  MyApi.IMAGE_BASE_URL + widget.item!.photopath!,
                  fit: BoxFit.cover,
                  errorBuilder: ( context, exception,
                  stackTrace) {
                    return Icon(
                      Icons.image,
                      size: height * 0.040,
                    );
                  },),
              )                  :

              ClipRRect(
                borderRadius: BorderRadius.circular(height * 0.005),
                child: Image.file(
                  widget.image!,
                  width: height * 0.040,
                  height: height * 0.035,
                  fit: BoxFit.cover,
                ),
              ),

            //   child: widget.image == null
            //       ? (( widget.item!.photopath == '' || widget.item!.photopath == 'null' || widget.item!.photopath == null) ?
            //   Icon(
            //     Icons.image,
            //     size: height * 0.040,
            //   ) :
            //   Image.network(MyApi.IMAGE_BASE_URL + widget.item!.photopath!,
            //     width: height * 0.040,
            //     height: height * 0.035,
            //     fit: BoxFit.cover,))
            //       : ClipRRect(
            //     borderRadius: BorderRadius.circular(height * 0.005),
            //         child: Image.file(
            //     widget.image!,
            //     width: height * 0.040,
            //     height: height * 0.035,
            //     fit: BoxFit.cover,
            //   ),
            //       ),
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
