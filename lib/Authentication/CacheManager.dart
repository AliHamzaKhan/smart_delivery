

import 'package:get_storage/get_storage.dart';
import 'CacheManagerKey.dart';

mixin CacheManager {
  Future<bool> saveToken(String? token) async {
    final box = GetStorage();
    await box.write(CacheManagerKey.TOKEN.toString(), token);
    return true;
  }

  Future<String?> getToken() async{
    final box = GetStorage();
    return await box.read(CacheManagerKey.TOKEN.toString());
  }

  Future<void> removeToken() async {
    final box = GetStorage();
    await box.remove(CacheManagerKey.TOKEN.toString());
    await box.remove(CacheManagerKey.TIMER.toString());
    box.erase();
   // Get.off(()=>LoginScreen());
  }
  Future<bool> saveTimer(int? time) async {
    final box = GetStorage();
    await box.write(CacheManagerKey.TIMER.toString(), time);
    return true;
  }
  Future<int?> getTimer() async{
    final box = GetStorage();
    return await box.read(CacheManagerKey.TIMER.toString());
  }


}