import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';

import '../Api/MyApi.dart';
import '../Design/toast.dart';
import '../Model/DeliveryItem.dart';
import '../Model/temp_item.dart';

class DeliveryItemController extends GetxController {
  ItemData? item;
  File? image;
  var orderController;
  var onImageSelect;
  var onQuantitySelected = 0;
  var deliveryId = 0.obs;
  var isDeliveryItemLoaded = true.obs;
  RxList<ItemData> deliveryItems = <ItemData>[].obs;
  var itemsQuantityData = <TempItem>[];
  var isItemQuantityUploaded = false.obs;
  List itemsImageData = <TempItem>[];
  var isItemImageUploaded = false.obs;
  var isSignatureUploaded = false.obs;

  List<ItemQuantityUpdate> quantityUpdate = [];
  List<ItemImageUpdate> imageUpdate = [];


  getFromArgs() {
    deliveryId = Get.arguments['id'];
  }

  getDeliveryItems() async {
    isDeliveryItemLoaded(true);
    try {
      var response = await MyApi().getDeliveryItems(deliveryId.value);
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
  }
  addQuantity({required int itemId, required int qty}) {
    if (quantityUpdate.isEmpty) {
      quantityUpdate.add(ItemQuantityUpdate(itemid: itemId, qty: qty));
      print('one');
      return;
    }

    bool itemExists = quantityUpdate.any((item) => item.itemid == itemId);
    if (itemExists) {
      int index = quantityUpdate.indexWhere((item) => item.itemid == itemId);
      quantityUpdate[index].qty = qty;
    } else {
      quantityUpdate.add(ItemQuantityUpdate(itemid: itemId, qty: qty));
    }

    print('quantityUpdate');
    print(quantityUpdate.length);
    print('temid: $itemId, qty: $qty');
  }
  addImage({required int itemId, required String? image}) {
    if (imageUpdate.isEmpty) {
      imageUpdate.add(ItemImageUpdate(itemid: itemId, imagedata: image));
      return;
    }

    bool itemExists = imageUpdate.any((item) => item.itemid == itemId);
    if (itemExists) {
      int index = imageUpdate.indexWhere((item) => item.itemid == itemId);
      imageUpdate[index].imagedata = image;
    } else {
      imageUpdate.add(ItemImageUpdate(itemid: itemId, imagedata: image));
    }

    print('imageUpdate');
    print(imageUpdate.length);
    print('itemId: $itemId, imagedata:  $image');
  }
  uploadSingleImage({deliveryId, image, itemId}) async {
    var response = await MyApi()
        .uploadItemPhoto(deliveryId: deliveryId, image: image, itemId: itemId);
    print(response);

    var data = jsonDecode(response);

    if (data["status"] == 'success') {
      apiToast(Get.context!, 'Images', "successfully", seconds: 1);
    } else {
      apiToast(Get.context!, 'Images', "failed", seconds: 1);
    }
    // apiToast(Get.context, 'Images', response["status"]);
  }
  uploadQuantityItems({required deliveryId}) async {
    if (quantityUpdate.isEmpty) {
      print(quantityUpdate.length);
      print('no Quantity');
    } else {
      try {
        isItemImageUploaded(true);
        var response = await MyApi().uploadItemQuantity(
            deliveryId: deliveryId, qtyData: quantityUpdate);
        print(response);
        var data = jsonDecode(response);
        if (data["status"] == 'success') {
          apiToast(Get.context!, 'Quantity', "successfully");
        } else {
          apiToast(Get.context!, 'Quantity', 'failed');
        }

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
        quantityUpdate.clear();
        isItemImageUploaded(false);
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    getFromArgs();
    getDeliveryItems();
  }
}
