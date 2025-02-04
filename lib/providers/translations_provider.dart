import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:radio_skonto/helpers/api_helper.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/models/translations_model.dart';

class TranslationsProvider with ChangeNotifier {
  ResponseState getTranslationsDataResponseState = ResponseState.stateFirsLoad;
  late Translations translations;


  Future<bool> getTranslationsData() async {
    getTranslationsDataResponseState = ResponseState.stateLoading;
    ApiHelper helper = ApiHelper();
    String apiKey = '/api/translations';
    final response = await helper.get(apiKey, {});

    if (response != null && response.statusCode == 200) {
      var errorTest = jsonDecode(response.body);
      if (errorTest['error'] != null) {
        getTranslationsDataResponseState = ResponseState.stateError;
        notifyListeners();
        return false;
      } else {
        translations = translationsFromJson(response.body);
        if (translations.data['en'] != null) {
          Singleton.instance.translations = translations;
          Singleton.instance.writeTranslationsToSharedPreferences(response.body);
        } else {
          Singleton.instance.translations = translationsFromJson(Singleton.instance.getTranslationsFromSharedPreferences());
        }
        getTranslationsDataResponseState = ResponseState.stateSuccess;
        notifyListeners();
        return true;
      }
    } else {
      getTranslationsDataResponseState = ResponseState.stateError;
      var tr = translationsFromJson(Singleton.instance.getTranslationsFromSharedPreferences());
      if (tr.apiVersion != '99.0') {
        Singleton.instance.translations = translationsFromJson(Singleton.instance.getTranslationsFromSharedPreferences());
        return true;
      }
      notifyListeners();
      return false;
    }
  }
}