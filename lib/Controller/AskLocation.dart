//
//
// import 'dart:async';
//
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class AskPermission extends GetxService  {
//   late StreamSubscription streamSubscription;
//   var latitude = "".obs;
//   var longitude = "".obs;
//   var address = "Getting address...".obs;
//
//
//   // grantLocation() async {
//   //   bool serviceEnabled;
//   //   LocationPermission permission;
//   //
//   //   Map<Permission, PermissionStatus> statuses = await [
//   //     Permission.location,
//   //     Permission.locationAlways,
//   //   ].request();
//   //
//   //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   //   if(await Permission.location.request().isGranted){
//   //
//   //   }
//   //   else if(await Permission.location.isPermanentlyDenied){
//   //     openAppSettings();
//   //   }
//   //   if (!serviceEnabled) {
//   //
//   //     return Future.error('Location services are disabled.');
//   //   }
//   //
//   //   permission = await Geolocator.checkPermission();
//   //   if (permission == LocationPermission.denied) {
//   //     permission = await Geolocator.requestPermission();
//   //     if (permission == LocationPermission.denied) {
//   //
//   //       return Future.error('Location permissions are denied');
//   //     }
//   //   }
//   //
//   //   if (permission == LocationPermission.deniedForever) {
//   //     openAppSettings();
//   //
//   //     return Future.error(
//   //         'Location permissions are permanently denied, we cannot request permissions.');
//   //   }
//   //
//   // }
//   grantLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     // Request permissions for both "location" and "locationAlways" at once
//     Map<Permission, PermissionStatus> statuses = await [
//       Permission.location,
//       Permission.locationAlways,
//     ].request();
//
//     // Check if "location" permission is granted
//     if (statuses[Permission.location]!.isGranted) {
//       // Location permission is granted
//     } else if (statuses[Permission.location]!.isPermanentlyDenied) {
//       // Location permission is permanently denied, open app settings
//       openAppSettings();
//       return Future.error('Location permissions are permanently denied.');
//     }
//
//     // Check if location services are enabled
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }
//
//     // Check location permission status
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       // Request location permission if denied
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied.');
//       }
//     }
//
//     // Handle permanently denied location permission
//     if (permission == LocationPermission.deniedForever) {
//       openAppSettings();
//       return Future.error('Location permissions are permanently denied.');
//     }
//
//     // Location permission is granted, and everything is enabled
//     // You can proceed with your location-based tasks here
//   }
//   @override
//   void onInit() {
//     super.onInit();
//     grantLocation();
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../main.dart';

class AskPermission extends GetxService {
  var currentLocation = LatLng(0, 0).obs;
  var serviceEnabled = false.obs;

  Future<Position?> getLocation() async {
    // Check if the location permission is granted
    if (await Permission.location.isGranted) {
      try {
        // Get the current position using Geolocator
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation,
        );

        // Update the currentLocation value with the obtained coordinates
        currentLocation.value = LatLng(position.latitude, position.longitude);
        appDebugPrint(currentLocation.value);
        appDebugPrint(position);
        appDebugPrint(serviceEnabled.value);

        return position;
      } catch (e) {
        // Handle any errors that may occur during location retrieval
        appDebugPrint('Error getting location: $e');
      }
    } else {
      // If location permission is not granted, ask for it using grantLocation()
      await grantLocation();
    }

    return null;
  }

  grantLocation() async {
    // Check if the location permission is granted
    if (await Permission.location.isGranted) {
      serviceEnabled(true);
      appDebugPrint(serviceEnabled.value);
    } else {
      final status = await Permission.location.request();
      if (status.isGranted) {
        serviceEnabled(true);
        appDebugPrint(serviceEnabled.value);
      } else if (status.isDenied) {
        serviceEnabled(false);
        appDebugPrint(serviceEnabled.value);

        // Display the location permission alert
        Get.dialog(Container(
          child: Column(
            children: [
              Text(
                  'We need access to your location to provide you with nearby services recommendations and improve your overall experience.'),
              TextButton(
                  onPressed: () {
                    grantLocation();
                  },
                  child: Text('Enable Location'))
            ],
          ),
        ));
      } else if (status.isPermanentlyDenied) {
        serviceEnabled(false);
        appDebugPrint(serviceEnabled.value);

        // Display a message to the user explaining how to enable the permission
        // You can also call pbAskLocation() with a message specific to permanently denied status
      }
    }
  }

  // grantLocation() async {
  //   if (await Permission.location.isGranted) {
  //     serviceEnabled(true);
  //     appDebugPrint(serviceEnabled.value);
  //   } else {
  //     // Request the location permission
  //     final status = await Permission.location.request();
  //     if (status.isGranted) {
  //       serviceEnabled(true);
  //       appDebugPrint(serviceEnabled.value);
  //     } else if (status.isDenied) {
  //       serviceEnabled(false);
  //       appDebugPrint(serviceEnabled.value);
  //       appAlerts.customAlert(alertTypes: AlertTypes.error, message: dataParser.strToTitleCase('please enable your location'));
  //       // openAppSettings(); // Open app settings for the user to manually enable the permission
  //     } else if (status.isPermanentlyDenied) {
  //       serviceEnabled(false);
  //       appDebugPrint(serviceEnabled.value);
  //       openAppSettings(); // Open app settings for the user to manually enable the permission
  //     }
  //   }
  // }

  @override
  void onInit() {
    super.onInit();
    // getLocation();
    grantLocation();
  }
}
