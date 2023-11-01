

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Constant/Colors.dart';
import '../Controller/OrderController.dart';
import '../Model/Task.dart';
import '../Utils/DistanceCal.dart';
import '../Utils/app_widget.dart';
import '../Utils/dataParser.dart';

class DeliveryOrderDesign extends StatelessWidget {
  DeliveryOrderDesign({Key? key, this.order, this.onTap,required this.orderController, this.isResetButton = false , this.onResetClick}) : super(key: key);
  Rows? order;
  var onTap;
  OrderController orderController;
  var height = Get.height;
  bool isResetButton;
  var onResetClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: key,
      onTap: onTap,
      child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: height * 0.010, vertical: height * 0.010
          ),
          margin: EdgeInsets.only(
            top: height * 0.010
          ),
          child: Column(
            children: [
              SizedBox(height: height * 0.010),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(width: height * 0.005),
                      Row(
                        children: [
                          Text(
                            order!.deliveryrefno!,
                            style: TextStyle(
                                color: alterColor,
                                fontSize: height * 0.022,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(width:height * 0.005),
                    ],
                  ),
                  // Text(
                  //   order!.deliveryid!.toString(),
                  //   style: TextStyle(
                  //       color: alterColor,
                  //       fontSize: height * 0.022,
                  //       fontWeight: FontWeight.bold),
                  // ),
                  Row(
                    children: [
                      GestureDetector(
                        onTapDown: (TapDownDetails details) {

                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: height * 0.010, vertical: height * 0.005),
                          // decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(10),
                          //    border: Border.all(color: getColor(order!.statusid))
                          // ),
                          child: getStatusName(order!.statusid),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: height * 0.010),

              getTableWidget('Address', AppDataParser().getStringData(order!.deliveryaddress!) ),

              SizedBox(height: height * 0.010),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if(order!.timeFrom! != '')
                    Expanded(child: getTableWidget('From',order!.timeFrom! ),),

                  if(order!.timeTo! != '')
                    Expanded(child: getTableWidget('To', order!.timeTo!),)


                ],
              ),

              SizedBox(height: height * 0.010),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //
              //     // checkValue(order!.statusid),
              //   ],
              // ),
              if(order!.tel != '')
                getTableWidget('Tel', "${order!.tel}"),

              if(order!.notes != '')
                getTableWidget('Notes', "${order!.notes}"),






              SizedBox(height: height * 0.005),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(DistanceCal().kmToMm(order!.distance).toStringAsFixed(1)),
                      SizedBox(width: height * 0.005),
                      Text("Km"),
                    ],
                  ),
                  TextButton(
                    onPressed: () async {
                      await orderController.launchMapViaAddress(
                          orderController
                              .getCurrentOrder()!
                              .deliveryaddress!);
                    },
                    child: Row(
                      children: [
                        Text(
                          "Map ",
                          style: TextStyle(color: alterColor, fontSize: height * 0.017),
                        ),
                        Icon(
                          Icons.location_on,
                          color: alterColor,
                          size: height * 0.018,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              if(isResetButton)
              TextButton(onPressed: onResetClick, child: Text('Reset Order', style: TextStyle(color: Colors.redAccent, fontSize:  height * 0.020),)),
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(height * 0.010),
            color: subBackgroundColor,

          ),
      ),
    );
  }

  // checkValue(value)   {
  //   switch (value) {
  //     case 3:
  //       return Row(
  //         mainAxisAlignment: MainAxisAlignment.end,
  //         children: [
  //           TextButton(
  //               onPressed: () async {
  //                 order!.statusid = 8;
  //               },
  //               child: Container(
  //                 padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  //                 decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(5),
  //                     border: Border.all(
  //                       color: Colors.green,
  //                     )),
  //                 child: Text(
  //                   "Arrived",
  //                   style: TextStyle(
  //                       color: Colors.green,
  //                       fontSize: 20,
  //                       fontWeight: FontWeight.bold),
  //                 ),
  //               )),
  //
  //         ],
  //       );
  //     case 6:
  //       return Row(
  //         mainAxisAlignment: MainAxisAlignment.end,
  //         children: [
  //           TextButton(
  //               onPressed: () async {
  //                 order!.statusid = 7;
  //               },
  //               child: Text(
  //                 "Departed",
  //                 style: TextStyle(
  //                     color: Colors.green.shade900,
  //                     fontSize: 20,
  //                     fontWeight: FontWeight.bold),
  //               )),
  //         ],
  //       );
  //     case 5:
  //       return Row(
  //         mainAxisAlignment: MainAxisAlignment.end,
  //         children: [
  //           SizedBox(height: 25),
  //           TextButton(
  //               onPressed: () async {
  //                 order!.statusid = 7;
  //
  //               },
  //               child: Text(
  //                 "Departed",
  //                 style: TextStyle(
  //                     color: Colors.green.shade900,
  //                     fontSize: 20,
  //                     fontWeight: FontWeight.bold),
  //               )),
  //         ],
  //       );
  //     case 8:
  //       return Row(
  //         mainAxisAlignment: MainAxisAlignment.end,
  //         children: [
  //           TextButton(
  //               onPressed: () async {
  //                 order!.statusid = 5;
  //
  //               },
  //               child: Container(
  //                 padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  //                 decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(5),
  //                     border: Border.all(
  //                       color: Colors.green.shade900,
  //                     )),
  //                 child: Text(
  //                   "Completed",
  //                   style: TextStyle(
  //                       color: Colors.green.shade900,
  //                       fontSize: 20,
  //                       fontWeight: FontWeight.bold),
  //                 ),
  //               )),
  //           TextButton(
  //               onPressed: () async {
  //                 order!.statusid = 6;
  //               },
  //               child: Container(
  //                 padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  //                 decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(5),
  //                     border: Border.all(
  //                       color: Colors.redAccent.shade700,
  //                     )),
  //                 child: Text(
  //                   "Failed",
  //                   style: TextStyle(
  //                       color: Colors.redAccent.shade700,
  //                       fontSize: 20,
  //                       fontWeight: FontWeight.bold),
  //                 ),
  //               )),
  //         ],
  //       );
  //     case 7:
  //       return SizedBox();
  //   }
  // }

  // getColor(status) {
  //   switch (status) {
  //     case 6:
  //       return Colors.redAccent.shade700;
  //     case 5:
  //       return Colors.green.shade900;
  //     case 3:
  //       return alterColor;
  //     default:
  //       return Colors.green;
  //   }
  // }

  getStatusName(status) {
    switch (status) {
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
