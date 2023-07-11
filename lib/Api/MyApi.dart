import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import '../Controller/OrderController.dart';
import '../main.dart';

class MyApi {
  static const String BASE_URL = "http://easyrouteplan.com/api/index.php?";
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
    print("userName $userName");
    var location = await getLocation() ?? LatLng(0, 0);
    print(location);
    var deliveries =
        "${BASE_URL}method=driverdelivery&username=$userName&latitude=${location.latitude}&longitude=${location.longitude}";
    print(deliveries);
    var response = await http.get(Uri.parse(deliveries));
    return response.body;
  }

  getDeliveryItems(deliveryid) async {
    var userName = await getAuthToken();
    print("userName $userName");
    var location = await getLocation() ?? LatLng(0, 0);
    print(location);
    var deliveries =
        "${BASE_URL}method=deliveryitems&deliveryid=$deliveryid";
    print(deliveries);
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

    print(url);
    var response = await http.get(Uri.parse(url));
    return response.body;
  }

  getLocation() async {
    return await Get.find<OrderController>().getLocation();
  }

  getAuthToken() async {
    return await authmanager.getToken();
  }

  uploadSignature({deliveryId, signature}) async {
    // var a = utf8.encode(input);
    // var url =
    //     "${BASE_URL}method=uploadsignature&imagedata=$signature&deliveryid=$deliveryId";
    print("signature");

    var form = Map<String, dynamic>();
    form["deliveryid"] = '$deliveryId';
    form["imagedata"] = "data:image/png;base64," + signature;

    var response = await http.post(
      Uri.parse(BASE_URL + 'method=uploadsignature'),
      body: form,
      // headers: {'Content-Type': 'application/json'},
    );
    print(response.body);

    return response.body;
  }

  uploadItem({deliveryId, image, itemId}) async {
    // var a = utf8.encode(input);
    // var url =
    //     "${BASE_URL}method=uploadsignature&imagedata=$signature&deliveryid=$deliveryId";
    print("upload image");

    var form = Map<String, dynamic>();
    form["itemid"] = '$itemId';
    form["deliveryid"] = '$deliveryId';
    form["imagedata"] = "data:image/png;base64," + image;

    var response = await http.post(
      Uri.parse(BASE_URL + 'method=uploaditemphoto'),
      body: form,
      // headers: {'Content-Type': 'application/json'},
    );
    print(response.body);

    return response.body;
  }

  uploadSignatureMultiPort({deliveryId, signature}) async {
    var request = http.MultipartRequest(
        "POST", Uri.parse(BASE_URL + "method=uploadsignature"));
    // request.fields["method"] = "uploadsignature";
    // request.fields["imagedata"] = signature;
    request.fields["deliveryid"] = deliveryId;

    var form = Map<String, dynamic>();

    var pic = await http.MultipartFile.fromString("imagedata", signature,
        filename: 'imagedata');
    request.files.add(pic);
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print(responseString);
  }

  logout() async {
    authmanager.logOut();
  }
}
