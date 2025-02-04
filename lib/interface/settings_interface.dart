abstract class SettingsInterface{
  Future changeAutoPlayback(bool status);
  Future<bool> getAutoPlayback();
}