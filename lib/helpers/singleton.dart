import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:radio_skonto/helpers/base_translation.dart';
import 'package:radio_skonto/helpers/constant.dart';
import 'package:radio_skonto/providers/main_screen_provider.dart';
import 'package:radio_skonto/providers/player_provider.dart';
import 'package:radio_skonto/providers/podcasts_provider.dart';
import 'package:radio_skonto/screens/player_helpers/audio_player_handler_impl.dart';
import 'package:radio_skonto/screens/web_view_screen/web_view_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:radio_skonto/models/translations_model.dart' as tr;

class Singleton {
  Singleton._privateConstructor();
  static final Singleton instance = Singleton._privateConstructor();

  late SharedPreferences prefs;
  late AudioPlayerHandler audioHandler;

  var needInitCarPlayWithoutRunApp = true;
  var needToPlayFirstRadioStationOnStartApp = true;
  var _firstInitPlayerAndData = false;

  tr.Translations translations = tr.Translations(apiVersion: '', data: {});

  final AudioPlayer audioPlayer = AudioPlayer();

  String registrationToken = '';
  bool isMainMenu = true;

  PackageInfo packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  Future<void> initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  void firstInitPlayerAndLoadData(BuildContext context) async {
    print('_firstInitPlayerAndData $_firstInitPlayerAndData');
    if (_firstInitPlayerAndData == false) {
      _firstInitPlayerAndData = true;
      var playerProvider = Provider.of<PlayerProvider>(context, listen: false);
      await playerProvider.initPlayerHandle();
      await playerProvider.setupCarPlay(context);
      // await playerProvider.getPlayData();
      print('Fire - playerProvider----$playerProvider');
      final mainScreenProvider =
          Provider.of<MainScreenProvider>(context, listen: false);
      mainScreenProvider.getMainScreenData(true, context,
          playerProvider: playerProvider);

      Provider.of<PodcastsProvider>(context, listen: false).getAllPodcasts(
          context,
          isFromInit: true,
          playerProvider: playerProvider);
    }
  }

  void initPlayerAndLoadData({BuildContext? context}) async {
    print('_firstInitPlayerAndData $_firstInitPlayerAndData');
    if (_firstInitPlayerAndData == false) {
      _firstInitPlayerAndData = true;
      var playerProvider = PlayerProvider();
      await playerProvider.initPlayerHandle();
      await playerProvider.initSetupCarPlay();
      // await playerProvider.getPlayData();
      print('Fire - playerProvider----$playerProvider');
      final mainScreenProvider = MainScreenProvider();
      mainScreenProvider.initMainScreenData(true,
          playerProvider: playerProvider);

      final podcastProvider = PodcastsProvider();
      podcastProvider.initAllPodcasts(
          isFromInit: true, playerProvider: playerProvider);
    }
  }

  void writeTokenToSharedPreferences(String token) {
    prefs.setString('token', token);
  }

  String getTokenFromSharedPreferences() {
    return prefs.getString('token') ?? '';
  }

  void writeLanguageCodeToSharedPreferences(String languageCode) {
    prefs.setString('languageCode', languageCode);
  }

  String getLanguageCodeFromSharedPreferences() {
    return prefs.getString('languageCode') ?? 'en';
  }

  void writeIsAllowWiFiDownloadToSharedPreferences(bool allowWiFi) {
    prefs.setBool('is_allow_wifi_download', allowWiFi);
  }

  bool getIsAllowWiFiDownloadFromSharedPreferences() {
    return prefs.getBool('is_allow_wifi_download') ?? false;
  }

  void writeRefreshTokenToSharedPreferences(String refreshToken) {
    prefs.setString('refreshToken', refreshToken);
  }

  String getRefreshTokenFromSharedPreferences() {
    return prefs.getString('refreshToken') ?? '';
  }

  void writeLoginToSharedPreferences(String refreshToken) {
    prefs.setString('login_pref', refreshToken);
  }

  String getLoginFromSharedPreferences() {
    return prefs.getString('login_pref') ?? '';
  }

  void writeUserNameToSharedPreferences(String userName) {
    prefs.setString('user_name', userName);
  }

  String getUserNameFromSharedPreferences() {
    return prefs.getString('user_name') ?? '';
  }

  void writeIsTutorialShownToSharedPreferences() {
    prefs.setBool('is_tutorial_shown', true);
  }

  bool getIsTutorialShownFromSharedPreferences() {
    return prefs.getBool('is_tutorial_shown') ?? false;
  }

  Future<String> getDeviseIdFromSharedPreferences() async {
    String id = prefs.getString('devise_id') ?? '';
    if (id == '') {
      final uniqueId = await _getId();
      id = uniqueId ?? '';
      prefs.setString('devise_id', id);
    }
    return id;
  }

  void writeTimeWhenBannerIsShowToSharedPreferences() {
    prefs.setString('time_when_banner_is_show', DateTime.now().toString());
  }

  String getTimeWhenBannerIsShowFromSharedPreferences() {
    return prefs.getString('time_when_banner_is_show') ?? '';
  }

  void writeTranslationsToSharedPreferences(String translations) {
    prefs.setString('translations', translations);
  }

  String getTranslationsFromSharedPreferences() {
    return prefs.getString('translations') ??
        '{"apiVersion": "99.0", "data": "{"":""}"}';
  }

  void writePopupBannerIdToSharedPreferences(String bannerId) {
    var bannersList = getPopupBannerIdListFromSharedPreferences();
    bannersList.add(bannerId);
    prefs.setStringList('banner_id_list', bannersList);
  }

  List<String> getPopupBannerIdListFromSharedPreferences() {
    return prefs.getStringList('banner_id_list') ?? [];
  }

  void writeDownloadedFileNameToSharedPreferences(String downloadedFileName) {
    var nameList = getDownloadedFileNameListFromSharedPreferences();
    nameList.add(downloadedFileName);
    prefs.setStringList('downloaded_file_name_list', nameList);
  }

  List<String> getDownloadedFileNameListFromSharedPreferences() {
    return prefs.getStringList('downloaded_file_name_list') ?? [];
  }

  String getLanguageCodeByLanguageName(String langName) {
    String finishLangCode = 'en';
    translations.data.forEach((key, value) {
      if (value['name_of_language'] == langName) {
        finishLangCode = key;
      }
    });
    return finishLangCode;
  }

  String getCurrentLanguageName() {
    String finishLangName = 'English';
    String langCode = getLanguageCodeFromSharedPreferences();
    finishLangName = translations.data[langCode]['name_of_language'];
    return finishLangName;
  }

  void clearAllPref() {
    prefs.clear();
  }

  void showErrorMassage(String title, String text) {
    Get.snackbar(
      title,
      text,
      colorText: Colors.white,
      backgroundColor: Colors.redAccent,
      icon: const Icon(Icons.error, color: Colors.white),
    );
  }

  void showSuccessMassage(String title, String text) {
    Get.snackbar(
      title,
      text,
      colorText: Colors.white,
      backgroundColor: Colors.green,
      icon: const Icon(Icons.error, color: Colors.white),
    );
  }

  String translate(String key) {
    String t = '';
    String languageCode =
        Singleton.instance.getLanguageCodeFromSharedPreferences();
    final currentTranslation = translations.data[languageCode];
    if (currentTranslation == null) {
      return baseTranslation[key] ?? key;
    }
    t = currentTranslation[key] ?? '';
    if (t == '') {
      t = baseTranslation[key] ?? key;
    }
    return t;
  }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    }
  }

  void openUrl(String url, BuildContext context) {
    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
        builder: (context) => WebViewScreen(url: url), fullscreenDialog: true));
  }

  String checkIsFoolUrl(String url) {
    return url.contains('http') ? url : apiBaseUrl + url;
  }
}
