

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionController extends GetxController{
  var currentLocation = ''.obs;

  getLocation() async {
    await grantLocation();
    if (await Geolocator.isLocationServiceEnabled()) {

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);

      update();
      return position;
    }
  }

  grantLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.locationAlways,
    ].request();
    print(statuses[Permission.location]);
    if (await Permission.location.request().isGranted) {

    } else if (await Permission.location.isPermanentlyDenied) {
      openAppSettings();
    }
  }
  @override
  void onInit() {
    super.onInit();
    getLocation();
    grantLocation();
  }
}