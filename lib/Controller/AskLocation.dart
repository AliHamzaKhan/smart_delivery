

import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class AskPermission extends GetxService  {
  late StreamSubscription streamSubscription;
  var latitude = "".obs;
  var longitude = "".obs;
  var address = "Getting address...".obs;


  grantLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.locationAlways,
    ].request();

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(await Permission.location.request().isGranted){

    }
    else if(await Permission.location.isPermanentlyDenied){
      openAppSettings();
    }
    if (!serviceEnabled) {

      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {

        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      openAppSettings();

      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

  }

  @override
  void onInit() {
    super.onInit();
    grantLocation();
  }
}