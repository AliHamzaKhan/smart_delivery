

import 'package:get/get.dart';

import 'CacheManager.dart';


class AuthenticationManager extends GetxController with CacheManager {
 // AuthenticationManager instance = Get.find<AuthenticationManager>();
  final isLogged = false.obs;
  var loading = "Loading".obs;

  void logOut() {
    isLogged.value = false;
    removeToken();
   // update();
  }
   load()async{
     await Future.delayed(Duration(milliseconds: 500));
     loading.value += ".";
     update();
   }

  login(String? token) async {
    isLogged.value = true;
    //Token is cached
    await saveToken(token);
   update();
  }




  checkLoginStatus() async {
    final token = await getToken();
    print("token $token");
    if (token != null) {
      isLogged.value = true;
    }
    else{
      isLogged.value = false;
    }
    return await token;
  }
  Future<void> initializeSettings() async {
    checkLoginStatus();
    //Simulate other services for 3 seconds
    await Future.delayed(Duration(milliseconds: 500));


  }
}