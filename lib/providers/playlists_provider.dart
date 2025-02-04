import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:radio_skonto/helpers/api_helper.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/models/playlists_model.dart';

class PlaylistsProvider with ChangeNotifier {

  ResponseState getPlaylistDataResponseState = ResponseState.stateFirsLoad;

  PlaylistModel? playlistData;

  Future<void> getPlaylistData(bool isFromInit) async {
    try {
      getPlaylistDataResponseState = ResponseState.stateLoading;
      if (isFromInit == false) {
        notifyListeners();
      }
      ApiHelper helper = ApiHelper();
      String languageCode = Singleton.instance.getLanguageCodeFromSharedPreferences();
      String apiKey = '/api/playlists/$languageCode';
      final response = await helper.get(apiKey, null);

      if (response != null && response.statusCode == 200) {
        var errorTest = jsonDecode(response.body);
        if (errorTest['error'] != null) {
          getPlaylistDataResponseState = ResponseState.stateError;
          notifyListeners();
        } else {
          try {
            playlistData = PlaylistModel.fromJson(jsonDecode(response.body));
            getPlaylistDataResponseState = ResponseState.stateSuccess;
            notifyListeners();
          } catch (exc) {
            getPlaylistDataResponseState = ResponseState.stateError;
            notifyListeners();
          }
        }
      } else {
        getPlaylistDataResponseState = ResponseState.stateError;
        notifyListeners();
      }
    } catch (exc) {
      getPlaylistDataResponseState = ResponseState.stateError;
      notifyListeners();
    }
  }
}
