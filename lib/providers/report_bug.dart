import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:radio_skonto/helpers/api_helper.dart';
import 'package:radio_skonto/helpers/singleton.dart';

class ReportBugProvider with ChangeNotifier {
  ResponseState sendReportBugResponseState = ResponseState.stateFirsLoad;

  Future<void> sendReportBugData(String messageText, String nameSurname, String email, BuildContext context) async {
    if (messageText == '') {
      return;
    }
    sendReportBugResponseState = ResponseState.stateLoading;
    ApiHelper helper = ApiHelper();
    String languageCode = Singleton.instance.getLanguageCodeFromSharedPreferences();
    String apiKey = '/api/support/send-email/$languageCode';

    Map<String, dynamic> finishBody = {
      'fullname': nameSurname,
      'email': email,
      'message': messageText};
    var body = json.encode(finishBody);

    final response = await helper.post(apiKey, null, body);

    if (response != null && response.statusCode == 200) {
      var errorTest = jsonDecode(response.body);
      if (errorTest['error'] != null) {
        sendReportBugResponseState = ResponseState.stateError;
        notifyListeners();
      } else {
        Navigator.of(context).pop();
        Singleton.instance.showSuccessMassage(Singleton.instance.translate('message_title'), Singleton.instance.translate('success_title'));
        sendReportBugResponseState = ResponseState.stateSuccess;
        notifyListeners();
      }
    } else {
      sendReportBugResponseState = ResponseState.stateError;
      notifyListeners();
    }
  }
}