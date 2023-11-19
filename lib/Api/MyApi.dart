import 'dart:convert';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:smart_delivery/Controller/AskLocation.dart';
import '../Controller/OrderController.dart';
import '../Model/temp_item.dart';
import '../main.dart';

class MyApi {
  static const String BASE_URL = "http://easyrouteplan.com/api/index.php?";
  static const String IMAGE_BASE_URL = "http://easyrouteplan.com/api/";
  static const String LOGIN_URL =
      "http://easyrouteplan.com/api/index.php?method=login";
  static const String DELIVERY_ORDERS =
      "http://easyrouteplan.com/api/index.php?method=driverdelivery&username=driver2";

  logIn(email, password) async {
    var response = await http.post(Uri.parse(BASE_URL),
        body: {"method": "login", "username": email, "password": password});
    return response.body;
  }

  singup(email, password) async {
    var response = await http.post(Uri.parse(BASE_URL),
        body: {"method": "login", "username": email, "password": password});
    return response.body;
  }

  getOrders() async {
    var userName = await getAuthToken();
    appDebugPrint("userName $userName");
    var location = await getLocation() ?? LatLng(0, 0);
    appDebugPrint(location);
    var deliveries =
        "${BASE_URL}method=driverdelivery&username=$userName&latitude=${location.latitude}&longitude=${location.longitude}";
    appDebugPrint(deliveries);
    var response = await http.get(Uri.parse(deliveries));
    return response.body;
  }

  getDeliveryItems(deliveryid) async {
    var userName = await getAuthToken();
    appDebugPrint("userName $userName");
    var location = await getLocation() ?? LatLng(0, 0);
    appDebugPrint(location);
    var deliveries =
        "${BASE_URL}method=deliveryitems&deliveryid=$deliveryid";
    appDebugPrint(deliveries);
    var response = await http.get(Uri.parse(deliveries));
    return response.body;
  }

  updateOrder({deliveryId, statusId, reason}) async {
    var location = await getLocation() ?? LatLng(0, 0);
    var url;
    if (reason == null) {
      url =
          "${BASE_URL}method=updatedelivery&deliveryid=${deliveryId.toString()}&statusid=${statusId.toString()}&latitude=${location.latitude.toString()}&longitude=${location.longitude.toString()}"
              .trim();
    } else {
      url =
          "${BASE_URL}method=updatedelivery&deliveryid=${deliveryId.toString()}&statusid=${statusId.toString()}&latitude=${location.latitude.toString()}&longitude=${location.longitude.toString()}&deliveryfailreason=$reason"
              .trim();
    }

    appDebugPrint(url);
    var response = await http.get(Uri.parse(url));
    appDebugPrint(response);
    return response.body;
  }

  getLocation() async {
    var position = await Get.find<AskPermission>().getLocation();
    return LatLng(position!.latitude, position!.longitude);

  }

  getAuthToken() async {
    return await authmanager.getToken();
  }

  uploadSignature({deliveryId, signature}) async {

    appDebugPrint("signature");

    var form = Map<String, dynamic>();
    form["deliveryid"] = '$deliveryId';
    form["imagedata"] = "data:image/png;base64," + signature;

    var response = await http.post(
      Uri.parse(BASE_URL + 'method=uploadsignature'),
      body: form,
    );
    appDebugPrint(response.body);

    return response.body;
  }

  uploadItemPhoto({deliveryId, image, itemId}) async {

    appDebugPrint("upload image");

    var form = Map<String, dynamic>();
    form["itemid"] = '$itemId';
    form["deliveryid"] = '$deliveryId';
    form["imagedata"] = "data:image/png;base64," + image;

    var response = await http.post(
      Uri.parse(BASE_URL + 'method=uploaditemphoto'),
      body: form,
    );
    appDebugPrint(response.body);

    return response.body;
  }

  uploadItemImage({deliveryId,required List<ItemImageUpdate> imageData}) async{

    var url = "${BASE_URL}method=uploaditemphoto";

    List<Map<String, dynamic>> qtyDataJson = imageData.map((e) => e.toJson()).toList();
    var formData = {
      'jdata': jsonEncode({
        "deliveryid": deliveryId,
        "driverid": '1',
        "items": qtyDataJson,
      })
    };

    appDebugPrint(url);
    appDebugPrint(formData);

    var response = await http.post(Uri.parse(url), body: formData);
    return response.body;
  }

  uploadItemQuantity({deliveryId,required List<ItemQuantityUpdate> qtyData}) async{

    var url = "${BASE_URL}method=updatedeliveryitem";
    List<Map<String, dynamic>> qtyDataJson = qtyData.map((e) => e.toJson()).toList();
    var formData = {
      'jdata': jsonEncode({
        "deliveryid": deliveryId,
        "driverid": 1,
        "items": qtyDataJson,
      })
    };
    appDebugPrint(formData);

    appDebugPrint(url);
    appDebugPrint(formData);

    var response = await http.post(Uri.parse(url), body: formData);
    return response.body;
  }

  reOrderList({deliveryid, visitorder, prvdeliveryid, nextdeliveryid}) async{
    // var url = "${BASE_URL}method=updatedeliveryinfo&deliveryid=$deliveryid&visitorder=$visitorder";
    var url = "${BASE_URL}method=updatedeliveryinfo&prvdeliveryid=$prvdeliveryid&nextdeliveryid=$nextdeliveryid&deliveryid=$deliveryid&visitorder=$visitorder";
    appDebugPrint(url);
    var response = await http.get(Uri.parse(url));
    return response.body;
  }



  logout() async {
    authmanager.logOut();
  }
}
