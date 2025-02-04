import 'package:radio_skonto/interface/settings_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService implements SettingsInterface{
  String playbackKey = 'playback';

  @override
  Future changeAutoPlayback(bool status) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(playbackKey, status);
  }

  @override
  Future<bool> getAutoPlayback() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(playbackKey) ?? false;
  }

}