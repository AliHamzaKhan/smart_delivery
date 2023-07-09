

import 'package:shared_preferences/shared_preferences.dart';

import '../Model/UserModel.dart';


class MySharedPreference{
  String user_key = "user" ;
  String map_type_key = "map_type";
  String travel_unit_key = "travel_unit" ;

  MySharedPreference();
  Future isUserAvailable() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(user_key);
  }
  Future addUserDetails(UserModel userModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(user_key,userModel.firstName!).then((value) => (value){
      print("user add $value");
    });
  }
  Future<String> getUserDetails() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String a = prefs.getString(user_key) ?? "";
    return a;
  }
  Future removeUser()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(user_key);
    prefs.clear();
  }

  Future autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString(user_key);

    if (userId != null) {
      // isLoggedIn = true;
      // name = userId;
    }


  }

  Future addMapType(value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var a = prefs.setInt(map_type_key, value).then((value){
      print("map add $value");
    });
    print("map add $a");
  }
  Future<int> getMapType() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int a = prefs.getInt(map_type_key) ?? 0;
    print("map get $a");
    return a;
  }
  Future addTravelUnit(value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var a = prefs.setInt(travel_unit_key, value).then((value){
      print("travel add $value");
    });
    print("travel add $a");
  }
  Future<int> getTravelUnit() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int a = prefs.getInt(travel_unit_key) ?? 0;
    print("travel get $a");
    return a ;
  }
  Future checkMap() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey(map_type_key)){
      print("map_type exists");
      return true;
    }
    else
      return false;
  }
  Future checkTravelUnit() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey(travel_unit_key)){
      print("travel_unit exists");
      return true;
    }
    return false;
  }
}