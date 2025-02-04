import 'package:radio_skonto/interface/listened_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListenedService implements ListenedInterface{
  String listenedKey = 'listened';

  @override
  Future addListened(String idTale) async{
    final prefs = await SharedPreferences.getInstance();
    List<String> lis = prefs.getStringList(listenedKey) ?? [];
    if(lis == []){
      lis = [idTale];
    } else{
      if(lis.contains(idTale) == false) {
        lis.insert(0, idTale);
      } else{
        if(lis.asMap()[0] != idTale){
          lis.removeWhere((item) => item == idTale);
          lis.insert(0, idTale);
        }
      }
    }
    if(lis.length>= 6){
      lis.removeLast();
    }
    await prefs.setStringList(listenedKey, lis);
  }

  @override
  Future<List<String>> getListened() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(listenedKey) ?? [];
  }
}