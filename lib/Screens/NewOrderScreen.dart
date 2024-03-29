import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Constant/Colors.dart';
import '../Controller/OrderController.dart';
import '../Design/DeliveryOrderDesign.dart';
import '../Design/HorizontalLine.dart';
import '../Design/NewOrderDrawer.dart';
import '../Design/buttons.dart';
import '../Design/toast.dart';
import '../Model/Task.dart';
import 'NewOrderRunningScreen.dart';

class NewOrderScreen extends StatelessWidget {
  NewOrderScreen({Key? key}) : super(key: key);

  var orderController = Get.put(OrderController(), permanent: true);
  var height = Get.height;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime currentBackPressTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
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
                            style: TextStyle(
                                color: textColor, fontSize: height * 0.018),
                          ),
                        ),
                        PopupMenuItem<Filter>(
                          value: Filter.ToDo,
                          child: Text('ToDo',
                              style: TextStyle(
                                  color: textColor, fontSize: height * 0.018)),
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
              Obx(() => orderController.todosMenu.value == 'ToDo'
                  ? (orderController.todoList.isNotEmpty ||
                  orderController.getCurrentOrder().deliveryid != 0
                      ? Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: height * 0.050),
                          child: orderController.startDelivery.value
                              ? AppProgressBar()
                              : AppButton(
                                  onTap: () async {
                                    await orderController.getTodo();
                                    Get.to(() => NewOrderRunningScreen(
                                          orderController: orderController,
                                        ));
                                  },
                                  child: startButton(orderController.getCurrentOrder().deliveryid == 0
                                      ? "START"
                                      : (orderController.getCurrentOrder().statusid == 3
                                          ? 'START'
                                          : "Continue ${orderController.getCurrentOrder().deliveryrefno ?? ''}")),
                                )

                          )
                      : SizedBox())
                  : Container(
                      )),
              Expanded(
                  child: Obx(() => !orderController.isOrderLoaded.value
                      ? (orderController.todosMenu.value != "All"
                          ? ReorderableListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: orderController.todoList.length,
                              itemBuilder: (context, index) {
                                return DeliveryOrderDesign(
                                  key: Key(
                                      "${orderController.todoList[index].visitorderno}"),
                                  order: orderController.todoList[index],
                                  onTap: () {},
                                  orderController: orderController,
                                );
                              },
                              onReorder: (int oldIndex, int newIndex) {

                                if (oldIndex < newIndex) {
                                  newIndex -= 1;
                                }
                                final Rows movedItem = orderController.todoList.removeAt(oldIndex);
                                orderController.todoList.insert(newIndex, movedItem);
                               var prvNext = orderController.reOrderVisitNo(newIndex);
                                print('newIndex: ${newIndex + 1} : movedItem ${movedItem.deliveryid}');
                                orderController.reOrderVisit(movedItem.deliveryid!, newIndex + 1, prvNext); // todo
                              })
                          : ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: orderController.ordersList.length,
                              itemBuilder: (context, index) {
                                var order = orderController.ordersList[index];
                                return DeliveryOrderDesign(
                                  order: order,
                                  onTap: () {},
                                  orderController: orderController,
                                  isResetButton: order.statusid == 3 ? false : true,
                                  onResetClick: () async {
                                    await orderController.updateStatus(
                                        inRunning: true,
                                        deliveryId: order.deliveryid,
                                        statusId: 3,
                                        result: (value){
                                          if(value != null){
                                            if(value){
                                              var a = order.deliveryrefno;
                                              var b = orderController.getCurrentOrder().deliveryrefno;
                                              print('matched ==  a : $a , b : $b , c : $value');
                                              print('matched $b');
                                              if(a == b){
                                                print('matched id ');
                                                orderController.setCurrentOrder(
                                                    order: Rows.fromJson({})
                                                );
                                              }
                                            }
                                          }
                                        }
                                    );
                                   await orderController.refreshOrder();
                                  },
                                );
                              }))
                      : AppProgressBar()))
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
          scaffoldKey: scaffoldKey,
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

  startButton(text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text,
            style: TextStyle(
                color: subBackgroundColor,
                fontWeight: FontWeight.bold,
                fontSize: height * 0.017)),
        Icon(
          Icons.fast_forward_outlined,
          color: subBackgroundColor,
          size: height * 0.025,
        )
      ],
    );
  }
}

enum Filter { All, Completed, Failed, ToDo, Departed }
