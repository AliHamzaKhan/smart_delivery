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
import '../Design/toast.dart';
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
  var isSignatureUploaded = false.obs;

  List<ItemQuantityUpdate> quantityUpdate = [];
  List<ItemImageUpdate> imageUpdate = [];

  addQuantity({required int itemId,required int qty}) {


    if(quantityUpdate.isEmpty){
      quantityUpdate.add(ItemQuantityUpdate(itemid: itemId, qty: qty));
      print('one');
      return;
    }


    bool itemExists = quantityUpdate.any((item) => item.itemid == itemId);
    if (itemExists) {
      // Item with the given itemId exists, update its quantity
      int index = quantityUpdate.indexWhere((item) => item.itemid == itemId);
      quantityUpdate[index].qty = qty;
    } else {
      // Item does not exist, add a new ItemQuantityUpdate to the list
      quantityUpdate.add(ItemQuantityUpdate(itemid: itemId, qty: qty));
    }
    // bool itemExists = false;

    // for (int i = 0; i < quantityUpdate.length; i++) {
    //   if (quantityUpdate[i].itemid == itemId) {
    //     quantityUpdate[i].qty = qty;
    //     itemExists = true;
    //     print('second');
    //     break;
    //   }
    //   if (!itemExists) {
    //     quantityUpdate.add(ItemQuantityUpdate(itemid: itemId, qty: qty));
    //     print('third');
    //   }
    //
    // }
    print('quantityUpdate');
    print(quantityUpdate.length);
    print('temid: $itemId, qty: $qty');
  }
  addImage({required int itemId,required String? image}) {


    if(imageUpdate.isEmpty){
      imageUpdate.add(ItemImageUpdate(itemid: itemId, imagedata:  image));
      return;
    }


    bool itemExists = imageUpdate.any((item) => item.itemid == itemId);
    if (itemExists) {
      // Item with the given itemId exists, update its quantity
      int index = imageUpdate.indexWhere((item) => item.itemid == itemId);
      imageUpdate[index].imagedata = image;
    } else {
      // Item does not exist, add a new ItemQuantityUpdate to the list
      imageUpdate.add(ItemImageUpdate(itemid: itemId, imagedata: image));
    }
    // bool itemExists = false;

    // for (int i = 0; i < imageUpdate.length; i++) {
    //   if (imageUpdate[i].itemid == itemId) {
    //     imageUpdate[i].imagedata = image;
    //     itemExists = true;
    //     break;
    //   }
    //   if (!itemExists) {
    //        imageUpdate.add(ItemImageUpdate(itemid: itemId, imagedata:  image));
    //   }
    //   print(imageUpdate.length);
    //   print('temid: $itemId, imagedata:  $image');
    // }
    print('imageUpdate');
    print(imageUpdate.length);
    print('temid: $itemId, imagedata:  $image');
  }

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

  // getOrders() async {
  //   try {
  //     isOrderLoaded(true);
  //     var response = await MyApi().getOrders();
  //     var result = jsonDecode(response);
  //     print(result);
  //     Task task = Task.fromJson(result);
  //     ordersList.assignAll(task.rows!);
  //     for (int i = 0; i < ordersList.length; i++) {
  //       if (ordersList[i].visitorderno == 0) {
  //         ordersList[i].visitorderno = i * 3;
  //       }
  //       else{
  //         break;
  //       }
  //     }
  //     ordersList.sort((a, b) => a.visitorderno!.compareTo(b.visitorderno!));
  //     filteredTodosList();
  //     update();
  //   } catch (e) {
  //     print(e);
  //   } finally {
  //     isOrderLoaded(false);
  //   }
  //   update();
  // }

  getOrders() async {
    try {
      isOrderLoaded(true);
      var response = await MyApi().getOrders();
      var result = jsonDecode(response);
      print(result);
      Task task = Task.fromJson(result);
      ordersList.assignAll(task.rows!);

      // Create a map to track the visitorderno values and their frequency
      var visitordernoMap = <int, int>{};

      for (int i = 0; i < ordersList.length; i++) {
        int? visitorderno = ordersList[i].visitorderno;
        if (visitorderno == 0) {
          // Calculate a new visitorderno based on the index
          visitorderno = i * 3;
          ordersList[i].visitorderno = visitorderno;
        }

        // Increment the frequency of the visitorderno in the map
        visitordernoMap[visitorderno!] =
            (visitordernoMap[visitorderno] ?? 0) + 1;
      }

      // Iterate over the ordersList again and update visitorderno for duplicates
      for (int i = 0; i < ordersList.length; i++) {
        int? visitorderno = ordersList[i].visitorderno;
        if (visitordernoMap[visitorderno]! > 1) {
          visitorderno = visitorderno! + i;
          ordersList[i].visitorderno = visitorderno;
          visitordernoMap[visitorderno] =
              (visitordernoMap[visitorderno] ?? 0) + 1;
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

  reOrderVisit(int deliverId, int current) async {
    print('deliverId $deliverId');
    print('current $current');

    try {
      var response = await MyApi().reOrderList(
        deliveryid: deliverId,
        visitorder: current,
      );
      print(response);
      if (response['status'] == 'success') {}
    } catch (e) {
    } finally {
      refreshOrder();
    }
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
      } else {
        setCurrentOrder(
          order: todoList.last,
        );
        updateDeliveryDetails('0 left to deliver');
        todoList.removeLast();
        todoList.refresh();

        if (todoList.isEmpty) {
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
    } else {
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

  uploadItemsImage({required deliveryId}) async {
    if (imageUpdate.isEmpty) {
      print(itemsImageData.length);
      print('no items');
    } else {
      try {
        isItemImageUploaded(true);
        var response = await MyApi().uploadItemImage(
            deliveryId: deliveryId,
            imageData: imageUpdate);
        print(response);

        apiToast(Get.context!, 'Images' , response['status']);

        // List<Future> requestFutures = [];
        //
        // for (int i = 0; i < itemsImageData.length; i++) {
        //   try {
        //     var convert = await itemsImageData[i].value.readAsBytes();
        //     var requestFuture = MyApi().uploadItemPhoto(
        //       deliveryId: deliveryId,
        //       image: await base64String(convert),
        //       itemId: itemsImageData[i].key,
        //     );
        //
        //     requestFutures.add(requestFuture);
        //   } catch (e) {
        //     print(e);
        //   }
        // }
        //
        // List<dynamic> responses = await Future.wait(requestFutures);
        // List<String> statuses = [];
        // for (var response in responses) {
        //   var data = jsonDecode(response);
        //   print(data["status"]);
        //   statuses.add(data["status"]);
        //   if (statuses.contains('success')) {
        //     apiToast(Get.context, 'Images', data["status"]);
        //   } else {
        //     apiToast(Get.context, 'Images', 'failed');
        //   }
        // }
        //
        // itemsImageData.clear();
      } catch (e) {
        print(e);
      } finally {
        isItemImageUploaded(false);
      }
    }
  }

  uploadQuantityItems({required deliveryId}) async {
    if (quantityUpdate.isEmpty) {
      print(quantityUpdate.length);
      print('no Quantity');
    } else {
      try {
        isItemImageUploaded(true);
        var response = await MyApi().uploadItemQuantity(
              deliveryId: deliveryId,
               qtyData: quantityUpdate);
        print(response);

        apiToast(Get.context!, 'Quantity', response['status']);

        // List<Future> requestFutures = [];
        // for (int i = 0; i < itemsQuantityData.length; i++) {
        //   var requestFuture = MyApi().uploadItemQuantity(
        //     deliveryId: deliveryId,
        //     itemId: itemsQuantityData[i].key,
        //     qty: itemsQuantityData[i].value,
        //   );
        //
        //   requestFutures.add(requestFuture);
        // }
        // List<dynamic> responses = await Future.wait(requestFutures);
        // List<String> statuses = [];
        //
        // for (var response in responses) {
        //   print(response);
        //   var data = jsonDecode(response);
        //   print(data["status"]);
        //   statuses.add(data["status"]);
        //   if (statuses.contains('success')) {
        //     apiToast(Get.context, 'Quantity', 'success');
        //   } else {
        //     apiToast(Get.context, 'Quantity', 'failed');
        //   }
        // }
        // itemsQuantityData.clear();


      } catch (e) {
        print(e);
      } finally {
        isItemImageUploaded(false);
      }
    }
  }



  uploadImage({deliveryId, image}) async {
    var convert = await image.readAsBytesSync();
    try {
      isSignatureUploaded(true);
      print(convert);
      var response = await MyApi().uploadSignature(
          deliveryId: deliveryId, signature: await base64String(convert));
      print(response);
      var data = jsonDecode(response);
      print(data["status"]);
      if (data["status"] == 'success') {
        apiToast(Get.context, 'Image', data["status"]);
      } else {
        apiToast(Get.context, 'Image', 'failed');
      }
    } catch (e) {
      print(e);
    } finally {
      isSignatureUploaded(false);
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
      isSignatureUploaded(true);
      var response = await MyApi().uploadSignature(
          deliveryId: deliveryId, signature: await exportSignature());
      var data = jsonDecode(response);
      print(data["status"]);
      if (data["status"] == 'success') {
        apiToast(Get.context, 'Signature', data["status"]);
      } else {
        apiToast(Get.context, 'Signature', data["status"]);
      }
    } catch (e) {
    } finally {
      isSignatureUploaded(false);
      signatureController.clear();
      update();
    }
  }

  // addUpdateItem({int? deliveryId,int? itemId,String? imageData,int? qty}) async{
  //   // if(imageData != null){
  //   //   if(itemUpdateData.isEmpty){
  //   //     itemUpdateData.add(ItemUpdate(imagedata: imageData , qty: null, itemid: itemId));
  //   //   }
  //   // }
  //   // if(qty != null){
  //   //   itemUpdateData.add(ItemUpdate(imagedata: null , qty: qty, itemid: itemId));
  //   // }
  //   //
  //   // ItemUpdate? existingItemWithQty = itemUpdateData.firstWhere(
  //   //       (item) => item.itemId == itemId && item.qty != null,
  //   //   orElse: () => null,
  //   // );
  //   // ItemUpdate? existingItemWithImage = itemUpdateData.firstWhere(
  //   //       (item) => item.itemId == itemId && item.image != null,
  //   //   orElse: () => null,
  //   // );
  //   //
  //   // if (existingItemWithImage != null) {
  //   //   existingItemWithImage.qty = qty ?? existingItemWithImage.qty;
  //   // } else if (existingItemWithQty != null) {
  //   //
  //   //   existingItemWithQty.imagedata = imageData ?? existingItemWithQty.imagedata;
  //   // } else {
  //   //
  //   //   itemUpdateData.add(ItemUpdate(itemid: itemId, imagedata: imageData, qty: qty));
  //   // }
  //
  //   ItemUpdate? existingItemWithImage = itemUpdateData.firstWhere(
  //         (item) => item.itemId == itemId && item.imageData != null,
  //     orElse: () => null,
  //   );
  //
  //   // Check if an ItemUpdate with the same itemId and qty is already present
  //   ItemUpdate? existingItemWithQty = itemUpdateData.firstWhere(
  //         (item) => item.itemId == itemId && item.qty != null,
  //     orElse: () => null,
  //   );
  //
  //   if (existingItemWithImage != null) {
  //     // If an item with the same itemId and image is found, update the qty
  //     existingItemWithImage.qty = qty ?? existingItemWithImage.qty;
  //   } else if (existingItemWithQty != null) {
  //     // If an item with the same itemId and qty is found, update the image
  //     existingItemWithQty.imagedata = imageData ?? existingItemWithQty.imagedata;
  //   } else {
  //     // If no existing item is found, add a new ItemUpdate object to the list
  //     itemUpdateData.add(ItemUpdate(itemid: itemId, imagedata: imageData, qty: qty));
  //   }
  //
  //
  // }


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
