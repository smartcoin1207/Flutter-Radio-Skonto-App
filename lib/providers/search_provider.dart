import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:radio_skonto/helpers/api_helper.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/models/search_model.dart';

class SearchProvider with ChangeNotifier {
  ResponseState getSearchResponseState = ResponseState.stateFirsLoad;
  var search = Search.empty();

  final filter = {
    'news': false,
    "podcast": false,
    "interview": false,
    "playlist": false,
    "vacancy": false
  };

  Future<void> getSearch(String query) async {
    String languageCode =
        Singleton.instance.getLanguageCodeFromSharedPreferences();
    getSearchResponseState = ResponseState.stateLoading;
    notifyListeners();
    ApiHelper helper = ApiHelper();
    final apiKey = '/api/search/$query/$languageCode';
    final types = <String>[];
    filter.forEach((key, value) {
      if (value) {
        types.add(key);
      }
    });
    final body = json.encode({'types': types});
    final response = await helper.post(apiKey, null, body);

    if (response.statusCode == 200) {
      var errorTest = jsonDecode(response.body);
      if (errorTest['error'] != null) {
        getSearchResponseState = ResponseState.stateError;
        notifyListeners();
      } else {
        search = searchFromJson(response.body);
        if (search.data.total == 0) {
          filter.forEach((key, value) => filter[key] = false);
        }
        getSearchResponseState = ResponseState.stateSuccess;
        notifyListeners();
      }
    } else {
      getSearchResponseState = ResponseState.stateError;
      notifyListeners();
    }
  }

  void check(String key, bool value) {
    filter[key] = value;
    notifyListeners();
  }

  void setLoadingState() {
    getSearchResponseState = ResponseState.stateLoading;
    notifyListeners();
  }

  void setSuccessState() {
    getSearchResponseState = ResponseState.stateSuccess;
    notifyListeners();
  }
}
