import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Constant/Colors.dart';
import '../../main.dart';

import '../Controller/AskLocation.dart';
import '../Controller/OrderController.dart';
import '../Design/DeliveryOrderDesign.dart';
import '../Design/NewOrderDrawer.dart';
import '../Design/toast.dart';
import '../Model/Task.dart';
import 'NewOrderRunningScreen.dart';

class NewOrderScreen extends StatelessWidget {
  NewOrderScreen({Key? key}) : super(key: key);

  var orderController = Get.put(OrderController());
  var height = Get.height;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime currentBackPressTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    Get.find<AskPermission>().grantLocation();
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
                size: height * 0.030,
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
                  size: height * 0.030,
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
                            style: TextStyle(color: textColor, fontSize: height * 0.018),
                          ),
                        ),
                        PopupMenuItem<Filter>(
                          value: Filter.ToDo,
                          child:
                              Text('ToDo', style: TextStyle(color: textColor, fontSize: height * 0.018)),
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
              // Obx(
              //   () => (orderController.isFirstOrder.value
              //       /*&&  orderController.getCurrentOrder().deliveryrefno !=  null*/)
              //       ?
              Obx(() => orderController.todosMenu.value == 'ToDo'
                  ? (orderController.todoList.isNotEmpty
                      ? Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: height * 0.050),
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
                                      borderRadius: BorderRadius.circular(
                                          height * 0.010))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("START",
                                      style: TextStyle(
                                          color: subBackgroundColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: height * 0.017
                                      )),
                                  Icon(Icons.fast_forward_outlined,
                                      color: subBackgroundColor, size: height * 0.025,)
                                ],
                              )),
                        )
                      : SizedBox())
                  : Container(
                // child: Text('Please Check If Your Internet Connection in enable then press refresh button at top', style: TextStyle(color: alterColor),),
              )),
              Expanded(
                  child: Obx(() => !orderController.isOrderLoaded.value
                      ? (orderController.todosMenu.value != "All"
                          ?
                  ReorderableListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: orderController.todoList.length,
                      itemBuilder: (context, index) {
                        return DeliveryOrderDesign(
                          key: Key("${orderController.todoList[index].visitorderno}"),
                          order: orderController.todoList[index],
                          onTap: () {
                          },
                          orderController: orderController,
                        );
                      },
                      onReorder: (int oldIndex, int newIndex) {
                        // print('oldIndex $oldIndex');
                        // print('newIndex $newIndex');
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        final Rows movedItem = orderController.todoList.removeAt(oldIndex);
                        orderController.todoList.insert(newIndex, movedItem);
                        orderController.reOrderVisit(movedItem.deliveryid!, newIndex + 1);
                        // if(start != current){
                        //   // print(orderController.todoList[start].deliveryrefno);
                        //   // print('start $start');
                        //   // print('current $current');
                        //   // orderController.reOrderVisit(orderController.todoList[start].deliveryid!, current);
                        // }

                        // print('oldIndex $oldIndex');
                        // print('newIndex $newIndex');
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
                                  isResetButton: orderController.ordersList[index].statusid == 3 ? false : true,
                                  onResetClick: () async{

                                    await orderController.updateStatus(
                                        deliveryId: orderController.ordersList[index].deliveryid,
                                        statusId: 3);
                                    orderController.refreshOrder();
                                  },
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
      appToast(Get.context!, 'Press Again To Exit');
      return Future.value(false);
    }
    return Future.value(true);
  }
}

enum Filter { All, Completed, Failed, ToDo, Departed }
