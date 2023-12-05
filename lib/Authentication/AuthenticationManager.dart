

import 'package:get/get.dart';

import 'CacheManager.dart';


class AuthenticationManager extends GetxController with CacheManager {
  final isLogged = false.obs;
  var loading = "Loading".obs;

  void logOut() {
    isLogged.value = false;
    removeToken();
  }
   load()async{
     await Future.delayed(Duration(milliseconds: 500));
     loading.value += ".";
     update();
   }

  login(String? token) async {
    isLogged.value = true;
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
    await Future.delayed(Duration(milliseconds: 500));


  }
}