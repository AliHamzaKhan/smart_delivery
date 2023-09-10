

import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class AskPermission extends GetxService  {
  late StreamSubscription streamSubscription;
  var latitude = "".obs;
  var longitude = "".obs;
  var address = "Getting address...".obs;


  // grantLocation() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //
  //   Map<Permission, PermissionStatus> statuses = await [
  //     Permission.location,
  //     Permission.locationAlways,
  //   ].request();
  //
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if(await Permission.location.request().isGranted){
  //
  //   }
  //   else if(await Permission.location.isPermanentlyDenied){
  //     openAppSettings();
  //   }
  //   if (!serviceEnabled) {
  //
  //     return Future.error('Location services are disabled.');
  //   }
  //
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //
  //       return Future.error('Location permissions are denied');
  //     }
  //   }
  //
  //   if (permission == LocationPermission.deniedForever) {
  //     openAppSettings();
  //
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }
  //
  // }
  grantLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Request permissions for both "location" and "locationAlways" at once
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.locationAlways,
    ].request();

    // Check if "location" permission is granted
    if (statuses[Permission.location]!.isGranted) {
      // Location permission is granted
    } else if (statuses[Permission.location]!.isPermanentlyDenied) {
      // Location permission is permanently denied, open app settings
      openAppSettings();
      return Future.error('Location permissions are permanently denied.');
    }

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Check location permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Request location permission if denied
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    // Handle permanently denied location permission
    if (permission == LocationPermission.deniedForever) {
      openAppSettings();
      return Future.error('Location permissions are permanently denied.');
    }

    // Location permission is granted, and everything is enabled
    // You can proceed with your location-based tasks here
  }
  @override
  void onInit() {
    super.onInit();
    grantLocation();
  }
}