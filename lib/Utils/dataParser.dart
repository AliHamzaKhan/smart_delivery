

class AppDataParser{

  String getStringData(String data){
    return data.replaceAll(RegExp(r'\s+'), ' ');
  }

}