import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:signature/signature.dart';
import '../../Constant/Colors.dart';
import '../../Utils/DistanceCal.dart';
import '../Controller/OrderController.dart';
import '../Design/ItemDesign.dart';
import '../Design/table_header.dart';
import '../Model/DeliveryItem.dart';
import '../Model/temp_item.dart';

class NewOrderRunningScreen extends StatelessWidget {
  NewOrderRunningScreen({Key? key, required this.orderController})
      : super(key: key);
  OrderController orderController;
  var height = Get.height;

  @override
  Widget build(BuildContext context) {
    getDeliveryItems();
    return WillPopScope(
      onWillPop: () async {
        orderController.itemsImageData.clear();
        orderController.itemsQuantityData.clear();
        orderController.deliveryItems.clear();
        await orderController.refreshOrder();
        return true;
      },
      child: Scaffold(
        backgroundColor: appbackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: alterColor,
              ),
              onPressed: () {
                Get.back();
              }),
          title: Obx(() =>  Text(
            orderController.currentOrder.value == null
                ? "Current Order"
                : orderController.getCurrentOrder().deliveryrefno,
            style: TextStyle(
                color: alterColor,
                fontSize: height * 0.025,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.5),
          ),)
        ),
        body: Obx(() =>  ModalProgressHUD(
          inAsyncCall: orderController.isItemImageUploaded.value,
          child: Container(
            height: Get.height,
            child: Obx(() => orderController.getCurrentOrder().deliveryid == 0
                ? SizedBox()
                : Container(
                height: Get.height,
                child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  orderController.isViewFullDetailsOpen.value ? 
                  GestureDetector(
                    onTap: (){
                      orderController.isViewFullDetailsOpen.value = !orderController.isViewFullDetailsOpen.value;
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: subBackgroundColor,
                          borderRadius:
                          BorderRadius.circular(height * 0.020)),
                      padding: EdgeInsets.symmetric(
                          horizontal: height * 0.020,
                          vertical: height * 0.020),
                      margin: EdgeInsets.symmetric(
                          horizontal: height * 0.005,
                          vertical: height * 0.005),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text(
                          //   orderController.getCurrentOrder().deliveryrefno,
                          //   style: TextStyle(
                          //       color: alterColor,
                          //       fontSize: height * 0.030,
                          //       fontWeight: FontWeight.bold),
                          // ),
                          SizedBox(height: height * 0.010),
                          Text(
                            orderController
                                .getCurrentOrder()
                                .deliveryaddress!,
                            style: TextStyle(
                                color: textColor, fontSize: height * 0.020),
                          ),

                          Text(
                            orderController.getCurrentOrder().notesfordriver!,
                            style: TextStyle(
                                color: textColor, fontSize: height * 0.018),
                          ),
                          SizedBox(height: height * 0.005),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DistanceCal()
                                    .kmToMm(orderController
                                    .getCurrentOrder()
                                    .distance!)
                                    .toStringAsFixed(1) +
                                    " Km",
                                style: TextStyle(
                                    color: alterColor,
                                    fontSize: height * 0.018),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await orderController.getLocation();
                                  await orderController.launchMapViaAddress(
                                      orderController
                                          .getCurrentOrder()!
                                          .deliveryaddress!);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "Map ",
                                      style: TextStyle(
                                          color: alterColor,
                                          fontSize: height * 0.017),
                                    ),
                                    Icon(
                                      Icons.location_on_outlined,
                                      color: alterColor,
                                      size: height * 0.018,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // statusView(
                          //     deliveryId: orderController
                          //         .getCurrentOrder()
                          //         .statusid!),
                        ],
                      ),
                    ),
                  ) : 
                  GestureDetector(
                    onTap: (){
                      orderController.isViewFullDetailsOpen.value = !orderController.isViewFullDetailsOpen.value;
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: height * 0.020,
                          vertical: height * 0.020),
                      margin: EdgeInsets.symmetric(
                          horizontal: height * 0.005,
                          vertical: height * 0.010),
                      decoration: BoxDecoration(
                          color: subBackgroundColor,
                          borderRadius:
                          BorderRadius.circular(height * 0.020)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('View Details', style: TextStyle(
                              color: alterColor, fontSize: height * 0.020, fontWeight: FontWeight.bold)),
                          Icon(Icons.arrow_drop_down,   color: alterColor, size: height * 0.030)
                        ],
                      ),
                    ),
                  ),
                  Obx(()=>Container(
                    height: height * 0.10,
                    child: orderController.isStatusLoaded.value
                        ? SizedBox(
                      height: height * 0.020,
                      child: Padding(
                        padding: EdgeInsets.all(height * 0.010),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: alterColor,
                          ),
                        ),
                      ),
                    )
                        : Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: height * 0.010,
                      ),
                      margin: EdgeInsets.symmetric(horizontal: height * 0.010),
                      child: checkValue(
                          orderController.getCurrentOrder().statusid, context),
                    ),
                  )),


                  GetBuilder<OrderController>(builder: (controller){
                    return !orderController.isDeliveryItemLoaded.value ?
                    (orderController.getCurrentOrder()!.statusid == 8 ? Expanded(child: Column(
                      children: [
                        tableHeader(),
                        (orderController.deliveryItems.isNotEmpty ? Expanded(
                            child: ListView.builder(
                                itemCount: orderController
                                    .deliveryItems.length,
                                itemBuilder: (context, index) {
                                  return ItemDesign(
                                    item: ItemData(
                                        deliveryid: orderController
                                            .deliveryItems[index].deliveryid,
                                        itemId: orderController
                                            .deliveryItems[index].itemId,
                                        itemName: orderController
                                            .deliveryItems[index].itemName,
                                        itemUnit: orderController
                                            .deliveryItems[index].itemUnit,
                                        qty: orderController
                                            .deliveryItems[index].qty),
                                    orderController: orderController,
                                    onImageSelect: (file) {
                                      if (file != null) {
                                        orderController.itemsImageData.add(TempItem(
                                            key: orderController.deliveryItems[index].itemId!,
                                            value: file
                                        ));
                                        print(file);
                                        print(orderController.itemsImageData.length);
                                      }
                                    },
                                    onQuantitySelected: (quantity){

                                      orderController.itemsQuantityData.add(TempItem(
                                          key: orderController.deliveryItems[index].itemId!,
                                          value: quantity
                                      ));
                                      print(orderController.itemsQuantityData.length);
                                      print(quantity);
                                    },
                                  );
                                })) : Text('no items'))
                      ],
                    )) : SizedBox()) : SizedBox();
                  })

                ],
              ),
            )),
          ),
        )),
          bottomNavigationBar : GetBuilder<OrderController>(
            builder: (controller){
              return !orderController.isDeliveryItemLoaded.value ?
              (orderController.getCurrentOrder()!.statusid == 8 ? GestureDetector(
                onTap: () async{
                  await  orderController.uploadItems(deliveryId: orderController.getCurrentOrder()!.deliveryid);
                  await orderController.uploadQuantity(deliveryId: orderController.getCurrentOrder()!.deliveryid);
                },
                child: Container(
                  height: height * 0.050,
                  padding: EdgeInsets.symmetric(vertical: height * 0.015),
                  margin: EdgeInsets.symmetric(vertical: height * 0.010, horizontal: height * 0.030),
                  decoration: BoxDecoration(
                      color: alterColor,
                      borderRadius: BorderRadius.circular(height * 0.010)
                  ),
                  alignment: Alignment.center,
                  child: Text("Update ${orderController.deliveryItems.length} Items",
                    style: TextStyle(color: appbackgroundColor, fontWeight: FontWeight.bold, fontSize: height * 0.017),),
                ),
              ) : SizedBox())
                  : SizedBox();
            },
          ),
      ),
    );
  }

  getDeliveryItems() {
    if (orderController.currentOrder.value != null) {
      orderController.getDeliveryItem(
          deliveryid: orderController.currentOrder.value!.deliveryid!);
    }
  }

  checkValue(value, context) {
    print(orderController.getCurrentOrder()!.statusid);
    switch (value) {
      case 3:
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                  side: BorderSide(width: height * 0.001, color: arrivedColor),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(height * 0.005))),
              onPressed: () async {
                orderController.getCurrentOrder()!.statusid = 8;
                await orderController.updateStatus(
                    deliveryId: orderController.getCurrentOrder()!.deliveryid,
                    statusId: 8);
                // orderController.onChange();
              },
              child: Text(
                "Arrived",
                style: TextStyle(
                    color: arrivedColor,
                    fontSize: height * 0.020,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      case 6:
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: DropdownButton<String>(
                value: orderController.failedReasons.value,
                dropdownColor: subBackgroundColor,
                icon: Icon(
                  Icons.arrow_drop_down_rounded,
                  color: alterColor,
                ),
                isExpanded: true,
                items: <String>[
                  "Shortage",
                  "Request Access",
                  "Wrong Type",
                  "Wrong Size",
                  "Wrong Color",
                  "Did not Order"
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                        color: alterColor,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (reason) {
                  orderController.setFailedReasons(reason);
                  print(reason);
                },
              ),
            ),
            SizedBox(width: height * 0.010),
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                    side: BorderSide(width: 1.0, color: departedColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(height * 0.005))),
                onPressed: () async {
                  await orderController.updateStatus(
                      deliveryId: orderController.getCurrentOrder()!.deliveryid,
                      statusId: 7,
                      reason: orderController.failedReasons.value);
                  orderController.getCurrentOrder()!.statusid = 7;
                  await orderController.nextOrder();
                },
                child: Text(
                  "Departed",
                  style: TextStyle(
                      color: departedColor,
                      fontSize: height * 0.020,
                      fontWeight: FontWeight.bold),
                )),
          ],
        );
      case 5:
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: height * 0.025),
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                    side: BorderSide(width: 1.0, color: departedColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(height * 0.005))),
                onPressed: () async {
                  await orderController.updateStatus(
                      deliveryId: orderController.getCurrentOrder()!.deliveryid,
                      statusId: 7);
                  orderController.getCurrentOrder()!.statusid = 7;
                  await orderController.nextOrder();
                },
                child: Text(
                  "Departed",
                  style: TextStyle(
                      color: departedColor,
                      fontSize: height * 0.020,
                      fontWeight: FontWeight.bold),
                )),
          ],
        );
      case 8:
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                  side: BorderSide(width: 1.0, color: completedColor),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(height * 0.005))),
              onPressed: () async {
                await orderController.updateStatus(
                    deliveryId: orderController.getCurrentOrder()!.deliveryid,
                    statusId: 5);
                orderController.getCurrentOrder()!.statusid = 5;
                await showDialogueApp(
                    context: context,
                    deliveryId: orderController.getCurrentOrder()!.deliveryid);
              },
              child: Text(
                "Completed",
                style: TextStyle(
                    color: completedColor,
                    fontSize: height * 0.020,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(width: height * 0.010),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                  side: BorderSide(width: height * 0.001, color: failedColor),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(height * 0.005))),
              onPressed: () async {
                await orderController.updateStatus(
                    deliveryId: orderController.getCurrentOrder()!.deliveryid,
                    statusId: 6);
                orderController.getCurrentOrder()!.statusid = 6;
              },
              child: Text(
                "Failed",
                style: TextStyle(
                    color: failedColor,
                    fontSize: height * 0.020,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      // case 7:
      //   return Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Text(
      //         "All Orders  Completed",
      //         style: TextStyle(
      //             color: alterColor,
      //             fontSize: height * 0.022,
      //             fontWeight: FontWeight.bold),
      //       ),
      //       // Text(
      //       //   "Signature",
      //       //   style: TextStyle(
      //       //       color: alterColor,
      //       //       fontSize: height * 0.022,
      //       //       fontWeight: FontWeight.bold),
      //       // ),
      //       // SizedBox(height: height * 0.005),
      //       // Container(
      //       //   width: Get.width,
      //       //   height: height * 0.4,
      //       //   padding: EdgeInsets.symmetric(
      //       //       horizontal: height * 0.020, vertical: height * 0.020),
      //       //   // margin: EdgeInsets.symmetric(horizontal: height * 0.010),
      //       //   decoration: BoxDecoration(
      //       //       color: subBackgroundColor,
      //       //       borderRadius: BorderRadius.circular(height * 0.020)),
      //       //   child: Signature(
      //       //     width: Get.width - 40,
      //       //     height: height * 0.4,
      //       //     controller: orderController.signatureController,
      //       //     backgroundColor: subBackgroundColor,
      //       //     dynamicPressureSupported: false,
      //       //   ),
      //       // ),
      //       // InkWell(
      //       //   onTap: () async {
      //       //     if (orderController.signatureController.isNotEmpty) {
      //       //       await orderController.uploadSignature();
      //       //       await orderController.nextOrder();
      //       //     } else {
      //       //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //       //           content: Text(
      //       //         "Please take signature.....",
      //       //         style: TextStyle(color: alterColor),
      //       //       )));
      //       //     }
      //       //   },
      //       //   child: Container(
      //       //       width: Get.width,
      //       //       height: height * 0.055,
      //       //       margin: EdgeInsets.symmetric(
      //       //           horizontal: height * 0.040, vertical: height * 0.020),
      //       //       alignment: Alignment.center,
      //       //       decoration: BoxDecoration(
      //       //           color: alterColor,
      //       //           borderRadius: BorderRadius.circular(height * 0.020)),
      //       //       child: Text(
      //       //         "Send To Server",
      //       //         style: TextStyle(
      //       //             color: subBackgroundColor,
      //       //             fontSize: height * 0.018,
      //       //             fontWeight: FontWeight.bold),
      //       //       )),
      //       // )
      //     ],
      //   );
      default:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "All Orders  Completed",
              style: TextStyle(
                  color: alterColor,
                  fontSize: height * 0.022,
                  fontWeight: FontWeight.bold),
            ),
            // Text(
            //   "Signature",
            //   style: TextStyle(
            //       color: alterColor,
            //       fontSize: height * 0.022,
            //       fontWeight: FontWeight.bold),
            // ),
            // SizedBox(height: height * 0.005),
            // Container(
            //   width: Get.width,
            //   height: height * 0.4,
            //   padding: EdgeInsets.symmetric(
            //       horizontal: height * 0.020, vertical: height * 0.020),
            //   // margin: EdgeInsets.symmetric(horizontal: height * 0.010),
            //   decoration: BoxDecoration(
            //       color: subBackgroundColor,
            //       borderRadius: BorderRadius.circular(height * 0.020)),
            //   child: Signature(
            //     width: Get.width - 40,
            //     height: height * 0.4,
            //     controller: orderController.signatureController,
            //     backgroundColor: subBackgroundColor,
            //     dynamicPressureSupported: false,
            //   ),
            // ),
            // InkWell(
            //   onTap: () async {
            //     if (orderController.signatureController.isNotEmpty) {
            //       await orderController.uploadSignature();
            //       await orderController.nextOrder();
            //     } else {
            //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //           content: Text(
            //         "Please take signature.....",
            //         style: TextStyle(color: alterColor),
            //       )));
            //     }
            //   },
            //   child: Container(
            //       width: Get.width,
            //       height: height * 0.055,
            //       margin: EdgeInsets.symmetric(
            //           horizontal: height * 0.040, vertical: height * 0.020),
            //       alignment: Alignment.center,
            //       decoration: BoxDecoration(
            //           color: alterColor,
            //           borderRadius: BorderRadius.circular(height * 0.020)),
            //       child: Text(
            //         "Send To Server",
            //         style: TextStyle(
            //             color: subBackgroundColor,
            //             fontSize: height * 0.018,
            //             fontWeight: FontWeight.bold),
            //       )),
            // )
          ],
        );
    }
  }

  showDialogueApp({context, deliveryId}) {
    var isUploading = false;
    var isPictureModeSelect = false;
    File? image;
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(height * 0.022)),
            backgroundColor: appbackgroundColor,
            content: StatefulBuilder(builder: (context, setState) {
              return Container(
                width: Get.width,
                height: height * 0.7,
                margin: EdgeInsets.symmetric(vertical: height * 0.010),
                child: isUploading ? Center(child: CircularProgressIndicator()) : (isPictureModeSelect ?
                Container(
                  height: height * 0.7,
                  width: Get.width * 0.8,
                  margin: EdgeInsets.symmetric(vertical: height * 0.010),
                  child: Column(
                    children: [
                      SizedBox(height: height * 0.020),
                      if(isPictureModeSelect)
                        Text('Upload Picture', style: TextStyle(color: alterColor, fontSize: height * 0.018,fontWeight: FontWeight.bold),),

                      SizedBox(height: height * 0.020),
                      image == null
                          ? Icon(
                        Icons.image,
                        size: height * 0.4,
                      )
                          : Image.file(
                        image!,
                        width: Get.width * 0.8,
                        height: height * 0.5,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: height * 0.020),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                              onPressed: () async {
                                if (image == null) {
                                  image =
                                  await orderController.getFromCamera();
                                  setState(() {});
                                } else {
                                  setState(() {
                                    isUploading = true;
                                  });

                                  await orderController.uploadImage(
                                      deliveryId: deliveryId, image: image);
                                  setState(() {
                                    isUploading = false;
                                  });
                                  Get.back();
                                }
                              },
                              style: TextButton.styleFrom(
                                  backgroundColor: alterColor,
                                  foregroundColor: alterColor,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(10))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Text(
                                  image == null ? 'Get Image' : 'Upload',
                                  // 'Upload',
                                  style: TextStyle(color: subBackgroundColor),
                                ),
                              )),
                          SizedBox(width: height * 0.020),
                          TextButton(
                              onPressed: () async {
                                Get.back();
                              },
                              style: TextButton.styleFrom(
                                  backgroundColor: subBackgroundColor,
                                  foregroundColor: subBackgroundColor,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(10))),
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
                ) :
                Column(
                  children: [
                    SizedBox(height: height * 0.020),
                    if(!isPictureModeSelect)
                      Text('Signature', style: TextStyle(color: alterColor, fontSize: height * 0.018,fontWeight: FontWeight.bold),),
                    SizedBox(height: height * 0.020),
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
                        controller: orderController.signatureController,
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
                              setState((){
                                isUploading = true;
                              });

                              await orderController.uploadSignature(
                                  deliveryId: deliveryId);
                              setState((){
                                isUploading = false;
                              });
                              Get.back();
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
                                "Save",
                                style: TextStyle(color: appbackgroundColor),
                              ),
                            )),
                        SizedBox(width: height * 0.020),
                        TextButton(
                            onPressed: () async {
                              // // final picker = ImagePicker();
                              // // final image = await picker.pickImage(source: ImageSource.camera);
                              // showPictureDialogue(context,
                              //     deliveryId: deliveryId);
                              setState((){
                                isPictureModeSelect = true;
                              });
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
                                "Image",
                                style: TextStyle(color: alterColor),
                              ),
                            )),
                        SizedBox(width: height * 0.020),
                        TextButton(
                            onPressed: () async {
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
                ))
              );
            }),
          );
        });
  }

  showPictureDialogue(context, {deliveryId}) {
    File? image;
    bool upload = false;
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(height * 0.022)),
            backgroundColor: appbackgroundColor,
            contentPadding: EdgeInsets.zero,
            content: StatefulBuilder(
              builder: (context, setState) {
                return ModalProgressHUD(
                  inAsyncCall: upload,
                  child: Container(
                    height: height * 0.7,
                    width: Get.width * 0.8,
                    margin: EdgeInsets.symmetric(vertical: height * 0.010),
                    child: Column(
                      children: [
                        SizedBox(width: height * 0.020),
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
                                size: height * 0.4,
                              )
                            : Image.file(
                                image!,
                                width: Get.width * 0.8,
                                height: height * 0.6,
                                fit: BoxFit.cover,
                              ),
                        SizedBox(width: height * 0.020),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                    backgroundColor: alterColor,
                                    foregroundColor: alterColor,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Text(
                                    image == null ? 'Get Image' : 'Upload',
                                    // 'Upload',
                                    style: TextStyle(color: subBackgroundColor),
                                  ),
                                )),
                            SizedBox(width: height * 0.020),
                            TextButton(
                                onPressed: () async {
                                  Get.back();
                                },
                                style: TextButton.styleFrom(
                                    backgroundColor: subBackgroundColor,
                                    foregroundColor: subBackgroundColor,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
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
                  ),
                );
              },
            ),
          );
        });
  }

  statusView({deliveryId}) {
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
}
