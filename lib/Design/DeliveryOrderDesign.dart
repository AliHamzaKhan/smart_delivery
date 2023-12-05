

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Constant/Colors.dart';
import '../Controller/OrderController.dart';
import '../Model/Task.dart';
import '../Utils/app_utils.dart';
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
                  if(kDebugMode)
                  Text(
                    order!.deliveryid!.toString() + "-" + order!.visitorderno.toString() ,
                    style: TextStyle(
                        color: alterColor,
                        fontSize: height * 0.022,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTapDown: (TapDownDetails details) {

                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: height * 0.010, vertical: height * 0.005),

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
