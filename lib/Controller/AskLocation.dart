

import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class AskPermission extends GetxController implements GetxService{
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
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(await Permission.location.request().isGranted){

    }
    else if(await Permission.location.isPermanentlyDenied){
      openAppSettings();
    }
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.

      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      openAppSettings();
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    // return await Geolocator.getCurrentPosition();

    streamSubscription = Geolocator.getPositionStream().listen((position) {
      // latitude.value = position.latitude.toString();
      // longitude.value = position.longitude.toString();
      // getAddressFromLatLng(position);
    });
  }
}