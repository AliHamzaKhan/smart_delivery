
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../main.dart';

class AskPermission extends GetxService {
  var currentLocation = LatLng(0, 0).obs;
  var serviceEnabled = false.obs;

  Future<void> grantLocation() async {
    final status = await Permission.location.request();

    if (status.isGranted) {
      serviceEnabled(true);
      appDebugPrint(serviceEnabled.value);
    } else if (status.isPermanentlyDenied) {
      serviceEnabled(false);
      appDebugPrint(serviceEnabled.value);
      openAppSettings();
    }
  }

  Future<Position?> getLocation() async {
    if (await Permission.location.isGranted) {
      try {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation,
        );

        currentLocation.value = LatLng(position.latitude, position.longitude);
        appDebugPrint(currentLocation.value);
        appDebugPrint(position);
        appDebugPrint(serviceEnabled.value);

        return position;
      } catch (e) {
        appDebugPrint('Error getting location: $e');
      }
    } else {
      await grantLocation();
    }

    return null;
  }

  @override
  void onInit() {
    super.onInit();
    grantLocation();
  }
}