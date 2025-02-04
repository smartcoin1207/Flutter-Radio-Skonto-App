import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:radio_skonto/helpers/constant.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/main.dart';
import 'package:radio_skonto/screens/navigation_bar/navigation_bar.dart';

enum ResponseState { stateFirsLoad, stateLoading, stateSuccess, stateError }

class ApiHelper {
  Future<http.Response> get(String url, Map<String, String>? headers) async {
    var uri = Uri.parse(apiBaseUrl + url);
    var resp = await http.get(uri, headers: headers);
    return _returnResponse(resp);
  }

  Future<http.Response> getWithoutBaseUrl(
      String url, Map<String, String>? headers) async {
    try {
      var uri = Uri.parse(url);
      var resp = await http.get(uri, headers: headers);
      return _returnResponse(resp);
    } catch (exp) {
      return _returnResponse(http.Response('''{"t": "t"}''', 500));
    }
  }

  Future<http.Response> post(
      String url, Map<String, String>? headers, Object? body) async {
    try {
      var uri = Uri.parse(apiBaseUrl + url);
      Map<String, String> baseHeader = {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      };
      if (headers != null) {
        baseHeader.addAll(headers);
      }
      var resp = await http.post(uri, headers: baseHeader, body: body);
      //var decoded = json.decode(resp.body);
      return _returnResponse(resp);
    } catch (exc) {
      return _returnResponse(http.Response('', 500));
    }
  }

  Future<http.Response> getRequestWithToken(
      {required String url,
      Map<String, String>? headers,
      required BuildContext context}) async {
    String token = Singleton.instance.getTokenFromSharedPreferences();
    Map<String, String> baseHeader = {
      'Authorization': 'Bearer $token',
    };
    if (headers != null) {
      baseHeader.addAll(headers);
    }
    var resp = await get(url, baseHeader);
    if (resp.statusCode == 403 || resp.statusCode == 401) {
      String refToken =
          Singleton.instance.getRefreshTokenFromSharedPreferences();
      if (refToken != '') {
        await refreshToken(context);
      }
      return await getRequestWithToken(
          url: url, headers: headers, context: context);
    } else {
      return resp;
    }
  }

  Future<http.Response> initPostRequestWithToken(
      {required String url,
      required String body,
      Map<String, String>? headers}) async {
    String token = Singleton.instance.getTokenFromSharedPreferences();
    Map<String, String> baseHeader = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    if (headers != null) {
      baseHeader.addAll(headers);
    }
    var response = await post(url, baseHeader, body);

    return response;
  }

  Future<http.Response> postRequestWithToken(
      {required String url,
      required String body,
      Map<String, String>? headers,
      required BuildContext context}) async {
    String token = Singleton.instance.getTokenFromSharedPreferences();
    Map<String, String> baseHeader = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    if (headers != null) {
      baseHeader.addAll(headers);
    }
    var response = await post(url, baseHeader, body);
    if (response.statusCode == 403) {
      await refreshToken(context);
      postRequestWithToken(url: url, body: body, context: context);
    }
    return response;
  }

  Future<bool> refreshToken(BuildContext context) async {
    String langCode = Singleton.instance.getLanguageCodeFromSharedPreferences();
    ApiHelper helper = ApiHelper();
    String refreshToken =
        Singleton.instance.getRefreshTokenFromSharedPreferences();
    String apiKey = '/api/token/refresh/$langCode/$refreshToken';
    if (refreshToken != '') {
      //var body = json.encode(finishBody);
      final response = await helper.get(apiKey, null);
      var test = json.decode(response.body);
      if (json.decode(response.body) != null &&
          json.decode(response.body)['data'] != null &&
          json.decode(response.body)['data']['accessToken'] != null &&
          json.decode(response.body)['data']['refreshToken'] != null) {
        String _token = json.decode(response.body)['data']['accessToken'];
        String _refreshToken =
            json.decode(response.body)['data']['refreshToken'] ?? '';
        Singleton.instance.writeRefreshTokenToSharedPreferences(_refreshToken);
        Singleton.instance.writeTokenToSharedPreferences(_token);
        return true;
      }
      if (json.decode(response.body) != null &&
          json.decode(response.body)['error'] != null) {
        logout(context);
        return false;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  void logout(BuildContext context) {
    Singleton.instance.writeRefreshTokenToSharedPreferences('');
    Singleton.instance.writeTokenToSharedPreferences('');
    Singleton.instance.writeUserNameToSharedPreferences('');
    scaffoldKey.currentState?.closeEndDrawer();
  }

  http.Response _returnResponse(http.Response response) {
    http.Response defResp = http.Response('''{"t": "t"}''', 500);
    switch (response.statusCode) {
      case 200:
        //var test = json.decode(response.body);

        // if (json.decode(response.body) != null && json.decode(response.body)['error'] != null
        //     && json.decode(response.body)['error']['info'] != null) {
        //   if (json.decode(response.body)['error']['info'] != null) {
        //     Map error = json.decode(response.body)['error']['info'];
        //     error.forEach((key, value) {
        //       Singleton.instance.showErrorMassage(key, value);
        //     });
        //   } else {
        //     Map error = json.decode(response.body)['error'];
        //     error.forEach((key, value) {
        //       Singleton.instance.showErrorMassage(key, value);
        //     });
        //   }
        // } else if (json.decode(response.body) != null && json.decode(response.body)['error'] != null && json.decode(response.body)['error']['info'] == null) {
        //   Map error = json.decode(response.body)['error'];
        //   error.forEach((key, value) {
        //     Singleton.instance.showErrorMassage(key, value);
        //   });
        // }
        return response;
      case 400:
        Singleton.instance.showErrorMassage(
            Singleton.instance.translate('error'),
            Singleton.instance.translate('invalid_request'));
        return defResp;
      case 401:
        //Singleton.instance.showErrorMassage(Singleton.instance.translate('error'), Singleton.instance.translate('invalid_credentials'));
        return response;
      // case 403:
      //   refreshToken();
      //   //Singleton.instance.showErrorMassage(Singleton.instance.translate('error'), Singleton.instance.translate('unauthorised'));
      //   return defResp;
      case 500:
        // Singleton.instance.showErrorMassage(Singleton.instance.translate('error'), Singleton.instance.translate('unexpected_error'));
        return defResp;
      default:
        Singleton.instance.showErrorMassage('error', 'unexpected_error');
        return defResp;
    }
  }
}
