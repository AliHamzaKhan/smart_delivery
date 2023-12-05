

import 'package:get/get.dart';
import '../Api/Api.dart';

class AuthController extends GetxController implements GetxService{
  static AuthController instance = Get.find<AuthController>();
  RxBool loading = true.obs;

  Future login({username,password, save}) async{
     await Api().login(
       username1: username,
       password1: password,
       save: save,
     );
  }

  setLoading(value){
    loading.value = value;
    update();
  }
  getLoading() => loading.value;
}