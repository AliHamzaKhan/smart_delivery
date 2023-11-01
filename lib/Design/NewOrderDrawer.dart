import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Constant/Colors.dart';
import '../Controller/OrderController.dart';
import '../Model/UserModel.dart';
import '../Utils/widgetStyles.dart';
import 'myDialogues.dart';

class NewOrderDrawer extends StatelessWidget {
  NewOrderDrawer({Key? key, required this.controller, this.scaffoldKey}) : super(key: key);
  UserModel? userModel;
  OrderController controller;
  var scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      height: MediaQuery.of(context).size.height,
      color: appbackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: subBackgroundColor,
            ),
            width: MediaQuery.of(context).size.width / 1.5,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                userModel?.image == ""
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          "assets/images/user_male.png",
                          height: 60.0,
                          width: 60.0,
                        ),
                      )
                    : Container(
                        height: 60.0,
                        width: 60.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: alterColor),
                        child: Text(
                          "${controller.driverName.value[0].toUpperCase()}",
                          style: TextStyle(
                              fontSize: 45,
                              fontWeight: FontWeight.bold,
                              color: appbackgroundColor),
                        ),
                      ),
                SizedBox(height: 10),
                Text("${controller.driverName.value}", style: subStyle),
                

              ],
            ),
          ),
          Divider(
            color: subBackgroundColor,
          ),

          (controller.todoList.isNotEmpty || controller.getCurrentOrder().deliveryrefno != 0) ?
          ListTile(
            onTap: (){
              showAlertMsg(context, onClick: () async{
                Get.back();
               await controller.resetOrders();
              });
              scaffoldKey.currentState!.closeDrawer();
            },
            leading: Icon(Icons.undo, color: alterColor,),
            title: Text('Reset', style: TextStyle(color: alterColor),),
          ) : SizedBox(),

          Spacer(),
          ListTile(
            title: Text(
              'Log out',
              style: subStyle,
            ),
            leading: Icon(Icons.logout, color: alterColor),
            onTap: () {
              Get.defaultDialog(
                  backgroundColor: appbackgroundColor,
                  title: "Logout?",
                  titlePadding: EdgeInsets.all(10),
                  titleStyle: TextStyle(
                      color: textColor,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 5),
                  cancel: TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        "No",
                        style: TextStyle(
                            color: alterColor,
                            fontSize: 20,
                            fontWeight: FontWeight.normal),
                      )),
                  confirm: TextButton(
                      onPressed: () async{
                         await   controller.logout();
                      },
                      child: Text("Yes",
                          style: TextStyle(
                              color: alterColor,
                              fontSize: 20,
                              fontWeight: FontWeight.normal))),
                  content: SizedBox());
            },
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
