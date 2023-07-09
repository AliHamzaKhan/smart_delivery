

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
    box.erase();
   // Get.off(()=>LoginScreen());
  }
}