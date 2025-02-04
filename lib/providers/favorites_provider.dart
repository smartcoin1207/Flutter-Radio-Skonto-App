import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:radio_skonto/helpers/api_helper.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/models/translations_model.dart';

class FavoritesProvider with ChangeNotifier {
  //ResponseState addToFavoriteResponseState = ResponseState.stateFirsLoad;

  Future<bool> addToFavorite(dynamic itemToAdd) async {
    ApiHelper helper = ApiHelper();
    String languageCode = Singleton.instance.getLanguageCodeFromSharedPreferences();
    String apiKey = '/api/favorites/$languageCode';
    Map<String, dynamic> finishBody = {
      "guest": "adsasdwqdqwdqssdqsdqsd",
      "item": "itemId",
      "type": "playlist"
    };
    var body = json.encode(finishBody);
    final response = await helper.post(apiKey, null, body);

    if (response != null && response.statusCode == 200) {
      var errorTest = jsonDecode(response.body);
      if (errorTest['error'] != null) {
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }
}