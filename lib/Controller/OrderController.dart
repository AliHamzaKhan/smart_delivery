import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Api/MyApi.dart';
import '../Constant/Colors.dart';
import '../Model/DeliveryItem.dart';
import '../Model/Task.dart';
import '../Model/temp_item.dart';
import '../Screens/LoginScreen.dart';
import '../main.dart';

class OrderController extends GetxController {
  var scaffoldKey;
  var isViewFullDetailsOpen = true.obs;
  var todosMenu = "ToDo".obs;
  var deliveryStatus = "0 deliveries".obs;
  var failedReasons = "Shortage".obs;
  RxList<Rows> ordersList = <Rows>[].obs;
  RxList<Rows> todoList = <Rows>[].obs;
  MyApi? api;
  var isOrderLoaded = false.obs;
  var isStatusLoaded = false.obs;
  var isFirstOrder = true.obs;
  late SignatureController signatureController;
  var driverName = ''.obs;

  final currentOrder = Rxn<Rows>();

  final currentOrderItem = Rxn<DeliveryItem>();
  var isDeliveryItemLoaded = false.obs;
  RxList<ItemData> deliveryItems = <ItemData>[].obs;
  var itemsQuantityData = <TempItem>[];
  var isItemQuantityUploaded = false.obs;
  List itemsImageData = <TempItem>[];
  var isItemImageUploaded = false.obs;


  getDeliveryItem({required int deliveryid}) async {
    try {
      isDeliveryItemLoaded(true);
      var response = await MyApi().getDeliveryItems(deliveryid);
      var result = jsonDecode(response);
      print(result);
      DeliveryItem deliveryItem = DeliveryItem.fromJson(result);
      deliveryItems.assignAll(deliveryItem.itemData!);
      print(deliveryItem.itemData!.length);
    } catch (e) {
      print(e);
    } finally {
      isDeliveryItemLoaded(false);
    }
    // return deliveryItems;
  }

  setCurrentOrder({order, controller}) {
    // controller.startTask(order: order);

    currentOrder.value = order;
    update();
    getDeliveryItem(deliveryid: currentOrder.value!.deliveryid!);
    // print("current order $currentOrder");
  }

  getCurrentOrder() => currentOrder.value;

  getOrders() async {
    try {
      isOrderLoaded(true);
      var response = await MyApi().getOrders();
      var result = jsonDecode(response);
      print(result);
      Task task = Task.fromJson(result);
      ordersList.assignAll(task.rows!);
      for (int i = 0; i < ordersList.length; i++) {
        if (ordersList[i].visitorderno == 0) {
          ordersList[i].visitorderno = i * 3;
        }
      }
      ordersList.sort((a, b) => a.visitorderno!.compareTo(b.visitorderno!));
      filteredTodosList();
      update();
    } catch (e) {
      print(e);
    } finally {
      isOrderLoaded(false);
    }
    update();
  }

  refreshOrder() async {
    var temp = ordersList;
    await getOrders();
    ordersList.toList().forEach((order) {
      if (temp.contains(order)) {
        print("duplicate ${order.visitorderno}");
      } else {
        temp.add(order);
      }
    });
    print("duplicate ${temp.length}");
  }

  updateStatus({deliveryId, statusId, reason}) async {
    try {
      isStatusLoaded(true);
      var response = await MyApi().updateOrder(
          deliveryId: deliveryId, statusId: statusId, reason: reason);
      var data = jsonDecode(response);
      print(response);
      currentOrder.value?.deliveryid = deliveryId;
      currentOrder.value?.statusid = statusId;
      print(data);
      if (data["status"] == "success") {
        currentOrder.value?.deliveryid = deliveryId;
        currentOrder.value?.statusid = statusId;
        // await getOrders();
        update();
      }
    } catch (e) {
      print(e);
    } finally {
      isStatusLoaded(false);
    }
    update();
  }

  updateDeliveryDetails(value) {
    deliveryStatus.value = value;
    update();
  }

  filteredTodosList() {
    todoList.value = ordersList.where((order) => order.statusid == 3).toList();
    print('todoList ${todoList.length}');
    updateDeliveryDetails("${todoList.length} left to deliver ");
    update();
  }

  Map statuses = {
    3: "ToDo",
    5: "Completed",
    6: "Failed",
    8: "Arrived",
    7: "Departed",
  };

  setFailedReasons(value) {
    failedReasons.value = value;
    update();
  }

  getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    // currentLocation.value = LatLng(position.latitude, position.longitude);
    print("position $position");
    return LatLng(position.latitude, position.longitude);
  }

  getFirstOrder(controller) {
    print(todoList.length);
    if (todoList.length >= 0) {
      setCurrentOrder(order: todoList[0], controller: controller);
      update();
    } else {}
  }

  getTodo() {
    todoList.sort((a, b) => a.visitorderno!.compareTo(b.visitorderno!));
    print('todoList ${todoList.length}');
    setCurrentOrder(order: todoList[0]);
    update();
  }

  nextOrder() {
    if (todoList.isNotEmpty) {
      if (todoList.length > 1) {
        for (var a in todoList) {
          if (a.deliveryrefno == getCurrentOrder().deliveryrefno) {
            var index = todoList.indexOf(a);
            setCurrentOrder(
              order: todoList[index + 1],
            );
            updateDeliveryDetails('${todoList.length - 1} left to deliver');
            todoList.removeAt(index);
            todoList.refresh();

            update();
            break;
          }
        }
      }
      else {
        setCurrentOrder(
          order: todoList.last,
        );
        updateDeliveryDetails('0 left to deliver');
        todoList.removeLast();
        todoList.refresh();

        if(todoList.isEmpty){
          setCurrentOrder(order: Rows(deliveryid: 0));
          itemsQuantityData.clear();
          itemsImageData.clear();
          deliveryItems.clear();
          update();
        }
        return;
      }
      print('no orders remaining temp ');
      print(todoList.length);
    }

    else{
      print('no orders remaining');
      setCurrentOrder(order: Rows(deliveryid: 0));
      itemsQuantityData.clear();
      itemsImageData.clear();
      deliveryItems.clear();
      update();
    }
  }

  // nextOrder() {
  //
  //   if (todoList.last == true) {
  //     setCurrentOrder(
  //       order: todoList.last,
  //     );
  //     print("last order");
  //     todoList.removeLast();
  //     todoList.refresh();
  //     update();
  //     return;
  //   }
  //   if (todoList.last != true) {
  //     for (var i in todoList) {
  //       if (i.visitorderno == getCurrentOrder().visitorderno) {
  //         var a = todoList.indexOf(i);
  //         // print("order  ${a + 1}");
  //         setCurrentOrder(
  //           order: todoList[a + 1],
  //         );
  //         // print("latest element ${todoList[a + 1].deliveryrefno}");
  //         todoList.removeAt(a);
  //         todoList.refresh();
  //         update();
  //         break;
  //       } else {
  //         todoList.clear();
  //         todoList.refresh();
  //         print("no order");
  //         update();
  //         break;
  //       }
  //     }
  //   } else {
  //     todoList.clear();
  //     todoList.refresh();
  //     print("no order");
  //     update();
  //     return;
  //   }
  // }

  uploadItems({required deliveryId}) async {
    if (itemsImageData.isEmpty) {
      print(itemsImageData.length);
      print('no items');
    } else {
      try {
        isItemImageUploaded(true);
        List<Future> requestFutures = [];

        for (int i = 0; i < itemsImageData.length; i++) {
          try {
            var convert = await itemsImageData[i].value.readAsBytes();
            var requestFuture = MyApi().uploadItem(
              deliveryId: deliveryId,
              image: await base64String(convert),
              itemId: itemsImageData[i].key,
            );

            requestFutures.add(requestFuture);
          } catch (e) {
            print(e);
          }
        }

        List<dynamic> responses = await Future.wait(requestFutures);

        for (var response in responses) {
          var data = jsonDecode(response);
          print(data["status"]);
        }

        itemsImageData.clear();
      } catch (e) {
        print(e);
      }
      finally{
        isItemImageUploaded(false);
      }

      // isItemImageUploaded(true);
      // for(int i=0; i<itemsImageData.length; i++){
      //   print(itemsImageData);
      //   print(itemsImageData[i]);
      //   try{
      //     var convert = await itemsImageData[i].value.readAsBytesSync();
      //     print(convert);
      //     var response = await MyApi().uploadItem(
      //         deliveryId: deliveryId, image: await base64String(convert), itemId: itemsImageData[i].key);
      //     var data = jsonDecode(response);
      //     print(data["status"]);
      //   }
      //   catch(e){
      //     print(e);
      //   }
      //   finally{
      //     itemsImageData.clear();
      //   }
      // }
      // isItemImageUploaded(false);
    }
  }
  uploadQuantity({required deliveryId}) async {
    if (itemsQuantityData.isEmpty) {
      print(itemsQuantityData.length);
      print('no Quantity');
    } else {
      try {
        List<Future> requestFutures = [];
        for (int i = 0; i < itemsQuantityData.length; i++) {
          var requestFuture = MyApi().uploadQuantity(
            deliveryId: deliveryId,
            itemId: itemsQuantityData[i].key,
            qty: itemsQuantityData[i].value,
          );

          requestFutures.add(requestFuture);
        }
        List<dynamic> responses = await Future.wait(requestFutures);

        for (var response in responses) {
          print(response);
          var data = jsonDecode(response);
          print(data["status"]);
        }
        itemsQuantityData.clear();
      } catch (e) {
        print(e);
      }
      ///////////////////////////////////////
      // isItemQuantityUploaded(true);
      // for(int i=0; i<itemsQuantityData.length; i++){
      //   print(itemsQuantityData);
      //   print(itemsQuantityData[i]);
      //   print(i);
      //   try{
      //     var response = await MyApi().uploadQuantity(
      //       deliveryId: deliveryId,
      //       itemId: itemsQuantityData[i].key,
      //       qty: itemsQuantityData[i].value
      //     );
      //    print(response);
      //     var data = jsonDecode(response);
      //     print(data["status"]);
      //   }
      //   catch(e){
      //     print(e);
      //   }
      //   finally{
      //     itemsQuantityData.clear();
      //   }
      // }
      // isItemQuantityUploaded(false);
    }
  }


  uploadImage({deliveryId, image}) async {
    var convert = await image.readAsBytesSync();
    try {
      isStatusLoaded(true);
      var response = await MyApi().uploadSignature(
          deliveryId: deliveryId, signature: await base64String(convert));
      var data = jsonDecode(response);
      print(data["status"]);
    } catch (e) {
      print(e);
    } finally {
      isStatusLoaded(false);
      update();
    }
  }

  Future<File?> getFromCamera() async {
    var pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      return imageFile;
    } else {
      return null;
    }
  }

  uploadSignature({deliveryId}) async {
    try {
      isStatusLoaded(true);
      var response = await MyApi().uploadSignature(
          deliveryId: deliveryId, signature: await exportSignature());
      var data = jsonDecode(response);
      print(data["status"]);
    } catch (e) {
    } finally {
      isStatusLoaded(false);
      signatureController.clear();
      update();
    }
  }

  exportSignature() async {
    final signature = await signatureController.toPngBytes();
    var a = await base64String(signature!);
    // log(a);
    return a;
  }

  String base64String(Uint8List data) {
    return base64Encode(data);
  }

  launchMapViaAddress(String address) async {
    String encodedAddress = Uri.encodeComponent(address);
    var uri = Uri.parse("google.navigation:q=$encodedAddress&mode=d");
    String googleMapUrl =
        "https://www.google.com/maps/search/?api=1&query=$encodedAddress";
    String appleMapUrl = "http://maps.apple.com/?q=$encodedAddress";
    if (Platform.isAndroid) {
      try {
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        }
      } catch (error) {
        throw ("Cannot launch Google map");
      }
    }
    if (Platform.isIOS) {
      try {
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        }
      } catch (error) {
        throw ("Cannot launch Apple map");
      }
    }
  }

  logout() async {
    authmanager.logOut();
    ordersList.clear();
    currentOrder.value = null;
    Get.offAll(() => LoginScreen());
  }

  void openDrawer() {
    scaffoldKey.currentState!.openDrawer();
  }

  void closeDrawer() {
    scaffoldKey.currentState!.openEndDrawer();
  }

  @override
  void onInit() async {
    super.onInit();
    if (authmanager.isLogged.value) {
      driverName.value = await authmanager.checkLoginStatus();
    }
    getOrders();
    scaffoldKey = GlobalKey<ScaffoldState>();
    signatureController = SignatureController(
      penStrokeWidth: 5,
      exportBackgroundColor: Colors.white,
      penColor: alterColor,
    );
  }
}
