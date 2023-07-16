import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Constant/Colors.dart';
import '../../main.dart';

import '../Controller/OrderController.dart';
import '../Design/DeliveryOrderDesign.dart';
import '../Design/NewOrderDrawer.dart';
import 'NewOrderRunningScreen.dart';

class NewOrderScreen extends StatelessWidget {
  NewOrderScreen({Key? key}) : super(key: key);

  var orderController = Get.put(OrderController());
  var height = Get.height;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime currentBackPressTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    permission.getLocation();
    orderController.refreshOrder();
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: appbackgroundColor,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(
                Icons.menu,
                color: alterColor,
              ),
              onPressed: () {
                // orderController.openDrawer();
                scaffoldKey.currentState!.openDrawer();
              }),
          title: Text(
            "Deliveries",
            style: TextStyle(
                color: alterColor,
                fontSize: height * 0.025,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.5),
          ),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: alterColor,
                ),
                onPressed: () async {
                  await orderController.refreshOrder();
                }),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: height * 0.010, horizontal: height * 0.020),
                margin: EdgeInsets.only(right: height * 0.025),
                decoration: BoxDecoration(
                    color: subBackgroundColor,
                    borderRadius: BorderRadius.circular(height * 0.010)),
                child: Obx(() => PopupMenuButton<Filter>(
                      onSelected: (Filter item) {
                        orderController.todosMenu.value = item.name;
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<Filter>>[
                        PopupMenuItem<Filter>(
                          value: Filter.All,
                          child: Text(
                            'All',
                            style: TextStyle(color: textColor),
                          ),
                        ),
                        PopupMenuItem<Filter>(
                          value: Filter.ToDo,
                          child: Text('ToDo', style: TextStyle(color: textColor)),
                        ),
                      ],
                      color: subBackgroundColor,
                      child: Text(
                        orderController.todosMenu.value,
                        style: TextStyle(
                            color: alterColor,
                            fontWeight: FontWeight.bold,
                            fontSize: height * 0.018),
                      ),
                    )),
              ),
            ),
          ],
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: EdgeInsets.all(height * 0.010),
          child: Column(
            children: [
                // Obx(() =>orderController.todosMenu.value=='ToDo' ? (orderController.todoList.isNotEmpty ? Padding(
                //   padding: EdgeInsets.symmetric(horizontal: height * 0.050),
                //   child: TextButton(
                //       onPressed: () async {
                //         await orderController.getTodo();
                //         Get.to(() => NewOrderRunningScreen(
                //           orderController: orderController,
                //         ));
                //         // orderController.isFirstOrder(false);
                //       },
                //       style: TextButton.styleFrom(
                //           backgroundColor: alterColor,
                //           foregroundColor: alterColor,
                //           shape: RoundedRectangleBorder(
                //               borderRadius:
                //               BorderRadius.circular(height * 0.010))),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           Text("START",
                //               style: TextStyle(
                //                   color: subBackgroundColor,
                //                   fontWeight: FontWeight.bold)),
                //           Icon(Icons.fast_forward_outlined,
                //               color: subBackgroundColor)
                //         ],
                //       )),
                // ) : SizedBox()) : SizedBox()),
                //



              Obx(() =>orderController.todosMenu.value=='ToDo' ? (orderController.todoList.isNotEmpty ? Padding(
                padding: EdgeInsets.symmetric(horizontal: height * 0.050),
                child: TextButton(
                    onPressed: () async {
                      await orderController.getTodo();
                      Get.to(() => NewOrderRunningScreen(
                        orderController: orderController,
                      ));
                      // orderController.isFirstOrder(false);
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: alterColor,
                        foregroundColor: alterColor,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(height * 0.010))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("START",
                            style: TextStyle(
                                color: subBackgroundColor,
                                fontWeight: FontWeight.bold)),
                        Icon(Icons.fast_forward_outlined,
                            color: subBackgroundColor)
                      ],
                    )),
              ) : SizedBox()) : SizedBox()),

              Expanded(
                  child: Obx(() => !orderController.isOrderLoaded.value
                      ? (orderController.todosMenu.value != "All"
                          ? ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: orderController.todoList.length,
                              itemBuilder: (context, index) {
                                return DeliveryOrderDesign(
                                  order: orderController.todoList[index],
                                  onTap: () {},
                                  orderController: orderController,
                                );
                              })
                          : ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: orderController.ordersList.length,
                              itemBuilder: (context, index) {
                                return DeliveryOrderDesign(
                                  order: orderController.ordersList[index],
                                  onTap: () {
                                    // Get.to(()=>NewOrderRunningScreen(
                                    //   orderController: orderController,
                                    // ));
                                  },
                                  orderController: orderController,
                                );
                              }))
                      : Center(
                          child: CircularProgressIndicator(
                            color: alterColor,
                          ),
                        )))
            ],
          ),
        ),
        bottomNavigationBar: GetBuilder<OrderController>(builder: (controller) {
          return Container(
            height: height * 0.060,
            decoration: BoxDecoration(
                color: alterColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(height * 0.030),
                  topRight: Radius.circular(height * 0.030),
                )),
            alignment: Alignment.center,
            child: Text(
              controller.deliveryStatus.value,
              style: TextStyle(
                  color: subBackgroundColor,
                  fontSize: height * 0.020,
                  fontWeight: FontWeight.bold),
            ),
          );
        }),
        drawer: NewOrderDrawer(
          controller: orderController,
        ),
      ),
    );
  }
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == '' ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(backgroundColor: appbackgroundColor,content: Row(
        children: [Text('Press Again To Exit', style: TextStyle(color: alterColor),)],
      )));
      return Future.value(false);
    }
    return Future.value(true);
  }
}

enum Filter { All, Completed, Failed, ToDo, Departed }
