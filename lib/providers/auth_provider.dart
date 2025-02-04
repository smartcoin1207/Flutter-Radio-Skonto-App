import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_skonto/helpers/api_helper.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/providers/profile_provider.dart';
import 'package:radio_skonto/screens/forgot_password/forgot_password_new_password_screen.dart';
import 'package:radio_skonto/screens/login_screen/login_screen.dart';
import 'package:radio_skonto/screens/navigation_bar/navigation_bar.dart';
import 'package:radio_skonto/screens/verification_screens/email_verification_screen.dart';
import 'package:radio_skonto/screens/verification_screens/phone_verification_screen.dart';
import '../models/place_of_residence_model.dart';

class AuthProvider with ChangeNotifier {

  ResponseState loginResponseState = ResponseState.stateFirsLoad;
  ResponseState registerResponseState = ResponseState.stateFirsLoad;
  ResponseState emailVerificationResponseState = ResponseState.stateFirsLoad;
  ResponseState resendEmailVerificationResponseState = ResponseState.stateFirsLoad;
  ResponseState phoneVerificationResponseState = ResponseState.stateFirsLoad;
  ResponseState phoneResendVerificationResponseState = ResponseState.stateFirsLoad;
  ResponseState changePasswordResponseState = ResponseState.stateFirsLoad;
  ResponseState forgotPasswordResponseState = ResponseState.stateFirsLoad;
  ResponseState forgotPasswordNewPasswordResponseState = ResponseState.stateFirsLoad;
  ResponseState refreshTokenResponseState = ResponseState.stateFirsLoad;

  String registerName = '';
  String registerSurname = '';
  String registerYearOfBirth = '';
  bool registerWomen = false;
  bool registerMan = false;
  bool registerEducationBasic = false;
  bool registerEducationAverage = false;
  bool registerEducationHighest = false;
  String registerEmail = '';
  String registerPhoneCode = '371';
  String registerPhone = '';
  String registerPassword = '';
  String registerRepeatPassword = '';
  bool registerPrivacyPolicy = false;
  bool registerIsButtonRegisterPress = false;

  String registrationEmailToken = '';
  String registrationPhoneToken = '';

  PlaceOfResidenceModel placesOfResidence = PlaceOfResidenceModel(apiVersion: '', data:{});

  Future<void> login(String userName, String password, BuildContext context) async {
    if (userName == '') {
      userName = Singleton.instance.getLoginFromSharedPreferences();
    }
    if (userName == '' || password == '') return;

    loginResponseState = ResponseState.stateLoading;
    notifyListeners();
    String apiKey = '/api/login';
    ApiHelper helper = ApiHelper();

    Map<String, dynamic> finishBody = {'login': userName, 'password': password, "locale": "lv"};
    var body = json.encode(finishBody);

    final response = await helper.post(apiKey, null, body);

    //var test = json.decode(response.body);

    if (json.decode(response.body) != null && json.decode(response.body)['data'] != null) {
      if (json.decode(response.body)['data']['accessToken'] != null) {
        Singleton.instance.writeLoginToSharedPreferences(userName);
        String _token = json.decode(response.body)['data']['accessToken'];
        String _refreshToken = json.decode(response.body)['data']['refreshToken']?? '';
        Singleton.instance.writeRefreshTokenToSharedPreferences(_refreshToken);
        Singleton.instance.writeTokenToSharedPreferences(_token);
        String userNameSaved = Singleton.instance.getUserNameFromSharedPreferences();
        if (userNameSaved == '') {
          Provider.of<ProfileProvider>(context, listen: false).getProfileData(context);
        }
        Navigator.of(context).pop();
      }
      if (json.decode(response.body)['data']['registrationToken'] != null && json.decode(response.body)['data']['isEmailVerified'] != null) {
        Singleton.instance.registrationToken = json.decode(response.body)['data']['registrationToken'];
        bool isEmailVerified = json.decode(response.body)['data']['isEmailVerified'];
        bool isPhoneVerified = json.decode(response.body)['data']['isPhoneVerified'];

        if (isEmailVerified == false) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: ((context) => const EmailVerificationScreen()),
          ));
        } else if (isPhoneVerified == false) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: ((context) => const PhoneVerificationScreen()),
          ));
        }
      }
      loginResponseState = ResponseState.stateSuccess;
      notifyListeners();
    } else {
      loginResponseState = ResponseState.stateError;
      notifyListeners();
    }
  }

  Future<void> register(BuildContext context) async {
    String languageCode = Singleton.instance.getLanguageCodeFromSharedPreferences();
    registerResponseState = ResponseState.stateLoading;
    notifyListeners();
    String apiKey = '/api/registration/$languageCode';
    ApiHelper helper = ApiHelper();

    String? personSex = registerWomen ? 'female' : registerMan ? 'male' : null;
    String? education = registerEducationBasic ? 'basic' : registerEducationAverage ? 'intermediate' : registerEducationHighest ? 'advanced' : null;

    Map<String, dynamic> finishBody = {
      'firstName': registerName,
      'lastName': registerSurname,
      'email': registerEmail,
      'phone': '+' + registerPhoneCode + registerPhone,
      'birthYear': registerYearOfBirth,
      'personSex': personSex,
      'education': education,
      'password': registerPassword,
      'city': null
    };
    var body = json.encode(finishBody);
    final response = await helper.post(apiKey, null, body);

    //var test = json.decode(response.body);

    if (json.decode(response.body) != null && json.decode(response.body)['data'] != null) {

      Singleton.instance.registrationToken = json.decode(response.body)['data']['registrationToken'];
      bool isEmailVerified = json.decode(response.body)['data']['isEmailVerified'];
      bool isPhoneVerified = json.decode(response.body)['data']['isPhoneVerified'];

      registerResponseState = ResponseState.stateSuccess;
      Singleton.instance.showSuccessMassage(Singleton.instance.translate('message_title'), Singleton.instance.translate('success_title'));
      notifyListeners();
      Navigator.of(context).push(MaterialPageRoute(
        builder: ((context) => const EmailVerificationScreen()),
      ));
    } else {
      Singleton.instance.showErrorMassage(
          Singleton.instance.translate('error'),
          Singleton.instance.translate('invalid_request'));
      registerResponseState = ResponseState.stateError;
      notifyListeners();
    }
  }

  Future<void> forgotPassword(String email, BuildContext context) async {
    String languageCode = Singleton.instance.getLanguageCodeFromSharedPreferences();
    forgotPasswordResponseState = ResponseState.stateLoading;
    //notifyListeners();
    String apiKey = '/api/forgot-password/$languageCode';
    ApiHelper helper = ApiHelper();

    Map<String, dynamic> finishBody = {
      'email': email
    };
    var body = json.encode(finishBody);
    final response = await helper.post(apiKey, null, body);

    var test = json.decode(response.body);

    if (response.statusCode == 200) {
      if (json.decode(response.body) != null
          && json.decode(response.body)['data'] != null
          && json.decode(response.body)['data']['status'] != null) {
        forgotPasswordResponseState = ResponseState.stateSuccess;
        Singleton.instance.showSuccessMassage(Singleton.instance.translate('message_title'), Singleton.instance.translate('success_title'));
        notifyListeners();
        Navigator.of(context).push(MaterialPageRoute(
          builder: ((context) => const ForgotPasswordNewPasswordScreen()),
        ));
      }
    } else {
      forgotPasswordResponseState = ResponseState.stateError;
      notifyListeners();
    }
  }

  Future<void> forgotPasswordNewPassword({required String emailCode, required String newPassword, required String repeatNewPassword, required BuildContext context}) async {
    if (newPassword != repeatNewPassword) {
      return;
    }
    String languageCode = Singleton.instance.getLanguageCodeFromSharedPreferences();
    forgotPasswordNewPasswordResponseState = ResponseState.stateLoading;
    //notifyListeners();
    String apiKey = '/api/reset-password/$languageCode';
    ApiHelper helper = ApiHelper();

    Map<String, dynamic> finishBody = {
      'passwordToken': emailCode,
      'newPassword': newPassword,
    };
    var body = json.encode(finishBody);
    final response = await helper.post(apiKey, null, body);

    var test = json.decode(response.body);

    if (response.statusCode == 200) {
      if (json.decode(response.body) != null
          && json.decode(response.body)['data'] != null
          && json.decode(response.body)['data']['status'] != null) {
        Singleton.instance.showSuccessMassage(Singleton.instance.translate('message_title'), Singleton.instance.translate('success_title'));
        Navigator.of(context).push(MaterialPageRoute(
          builder: ((context) => const LoginScreen()),
        ));
      }
      forgotPasswordNewPasswordResponseState = ResponseState.stateSuccess;
      Singleton.instance.showSuccessMassage(Singleton.instance.translate('message_title'), Singleton.instance.translate('success_title'));
      notifyListeners();
    } else {
      forgotPasswordNewPasswordResponseState = ResponseState.stateError;
      notifyListeners();
    }
  }

  Future<void> verificationEmail(String code, BuildContext context) async {
    String languageCode = Singleton.instance.getLanguageCodeFromSharedPreferences();
    emailVerificationResponseState = ResponseState.stateLoading;
    //notifyListeners();
    String apiKey = '/api/verify-email/$languageCode/${Singleton.instance.registrationToken}';
    ApiHelper helper = ApiHelper();

    Map<String, dynamic> finishBody = {
      'emailToken': code
    };
    var body = json.encode(finishBody);
    final response = await helper.post(apiKey, null, body);

    var test = json.decode(response.body);

    if (response.statusCode == 200) {
      if (json.decode(response.body) != null
          && json.decode(response.body)['data'] != null
          && json.decode(response.body)['data']['isEmailVerified'] != null) {

        bool isEmailVerified = json.decode(response.body)['data']['isEmailVerified'];
        bool isPhoneVerified = json.decode(response.body)['data']['isPhoneVerified']?? true;
        if (isEmailVerified == true && isPhoneVerified == false) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: ((context) => const PhoneVerificationScreen()),
          ));
        } else {
          if (json.decode(response.body)['data']['accessToken'] != null) {
            String _token = json.decode(response.body)['data']['accessToken'];
            String _refreshToken = json.decode(response.body)['data']['refreshToken']?? '';
            Singleton.instance.writeRefreshTokenToSharedPreferences(_refreshToken);
            Singleton.instance.writeTokenToSharedPreferences(_token);

            phoneVerificationResponseState = ResponseState.stateSuccess;
            Singleton.instance.showSuccessMassage(Singleton.instance.translate('message_title'), Singleton.instance.translate('success_title'));
            notifyListeners();

            String userNameSaved = Singleton.instance.getUserNameFromSharedPreferences();
            if (userNameSaved == '') {
              Provider.of<ProfileProvider>(context, listen: false).getProfileData(context);
            }

            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: ((context) => const MyNavigationBar()),
              fullscreenDialog: true
            ));
          }
        }
      }

      emailVerificationResponseState = ResponseState.stateSuccess;
      notifyListeners();
    } else {
      emailVerificationResponseState = ResponseState.stateError;
      notifyListeners();
    }
  }

  Future<void> resendVerificationEmail(BuildContext context) async {
    String langCode = Singleton.instance.getLanguageCodeFromSharedPreferences();
    resendEmailVerificationResponseState = ResponseState.stateLoading;
    notifyListeners();
    String apiKey = '/api/retry-email-verification/$langCode/${Singleton.instance.registrationToken}';
    ApiHelper helper = ApiHelper();

    Map<String, String> baseHeader = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    final response = await helper.get(apiKey, baseHeader);

    var test = json.decode(response.body);

    if (response.statusCode == 200) {
      Singleton.instance.showSuccessMassage(Singleton.instance.translate('message_title'), Singleton.instance.translate('success_title'));
      resendEmailVerificationResponseState = ResponseState.stateSuccess;
      notifyListeners();
    } else {
      resendEmailVerificationResponseState = ResponseState.stateError;
      notifyListeners();
    }
  }

  Future<void> verificationPhone(String code, BuildContext context) async {
    String languageCode = Singleton.instance.getLanguageCodeFromSharedPreferences();
    String apiKey = '/api/verify-phone/$languageCode/${Singleton.instance.registrationToken}';
    ApiHelper helper = ApiHelper();

    phoneVerificationResponseState = ResponseState.stateLoading;
    notifyListeners();

    Map<String, dynamic> finishBody = {
      "smsCode": code,
    };
    var body = json.encode(finishBody);
    final response = await helper.post(apiKey, null, body);

    var test = json.decode(response.body);


    if (response.statusCode == 200) {
      if (json.decode(response.body) != null && json.decode(response.body)['data'] != null) {
        if (json.decode(response.body)['data']['accessToken'] != null) {
          String _token = json.decode(response.body)['data']['accessToken'];
          String _refreshToken = json.decode(response.body)['data']['refreshToken']?? '';
          Singleton.instance.writeRefreshTokenToSharedPreferences(_refreshToken);
          Singleton.instance.writeTokenToSharedPreferences(_token);

          phoneVerificationResponseState = ResponseState.stateSuccess;
          Singleton.instance.showSuccessMassage(Singleton.instance.translate('message_title'), Singleton.instance.translate('success_title'));
          notifyListeners();

          String userNameSaved = Singleton.instance.getUserNameFromSharedPreferences();
          if (userNameSaved == '') {
            Provider.of<ProfileProvider>(context, listen: false).getProfileData(context);
          }

          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: ((context) => const MyNavigationBar()),
            fullscreenDialog: true
          ));
        }
      } else {
        phoneVerificationResponseState = ResponseState.stateError;
        notifyListeners();
      }
    } else {
      phoneVerificationResponseState = ResponseState.stateError;
      notifyListeners();
    }
  }

  Future<void> resendVerificationPhone() async {
    String langCode = Singleton.instance.getLanguageCodeFromSharedPreferences();
    phoneResendVerificationResponseState = ResponseState.stateLoading;
    notifyListeners();
    String apiKey = '/api/retry-phone-verification/$langCode/${Singleton.instance.registrationToken}';
    ApiHelper helper = ApiHelper();

    Map<String, String> baseHeader = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    final response = await helper.get(apiKey, baseHeader);

    var test = json.decode(response.body);

    if (response.statusCode == 200) {
      Singleton.instance.showSuccessMassage(Singleton.instance.translate('message_title'), Singleton.instance.translate('success_title'));
      phoneResendVerificationResponseState = ResponseState.stateSuccess;
      notifyListeners();
    } else {
      phoneResendVerificationResponseState = ResponseState.stateError;
      notifyListeners();
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword, String repeatNewPassword, BuildContext context) async {
    if (newPassword != repeatNewPassword) {
      return;
    }
    String langCode = Singleton.instance.getLanguageCodeFromSharedPreferences();
    changePasswordResponseState = ResponseState.stateLoading;
    notifyListeners();
    String apiKey = '/api/profile/change-password/$langCode';
    ApiHelper helper = ApiHelper();

    Map<String, dynamic> finishBody = {
      'oldPassword':oldPassword,
      'newPassword':newPassword};
    var body = json.encode(finishBody);

    final response = await helper.postRequestWithToken(url: apiKey, body: body, context: context);

    var test = json.decode(response.body);

    if (response.statusCode == 200) {
      if (json.decode(response.body) != null && json.decode(response.body)['data'] != null) {
        if (json.decode(response.body)['data']['accessToken'] != null) {
          String _token = json.decode(response.body)['data']['accessToken'];
          String _refreshToken = json.decode(response.body)['data']['refreshToken']?? '';
          Singleton.instance.writeRefreshTokenToSharedPreferences(_refreshToken);
          Singleton.instance.writeTokenToSharedPreferences(_token);
          Singleton.instance.showSuccessMassage(Singleton.instance.translate('message_title'), Singleton.instance.translate('success_title'));
          changePasswordResponseState = ResponseState.stateSuccess;
        }
      }
      changePasswordResponseState = ResponseState.stateError;
      notifyListeners();
    } else {
      changePasswordResponseState = ResponseState.stateError;
      notifyListeners();
    }
  }

  Future<void> getPlacesOfResidence() async {
    try {
      String langCode = Singleton.instance.getLanguageCodeFromSharedPreferences();
      String apiKey = '/api/cities/$langCode';
      ApiHelper helper = ApiHelper();

      Map<String, String> baseHeader = {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      };
      final response = await helper.get(apiKey, baseHeader);
      if (response.statusCode == 200) {
        placesOfResidence = PlaceOfResidenceModel.fromJson(jsonDecode(response.body));
      }
    } on Exception catch (_) {
    }
  }

  void logout(BuildContext context){
    ApiHelper helper = ApiHelper();
    helper.logout(context);
    // Singleton.instance.writeRefreshTokenToSharedPreferences('');
    // Singleton.instance.writeTokenToSharedPreferences('');
    // Singleton.instance.writeUserNameToSharedPreferences('');
    notifyListeners();
  }

  bool canPressNextOnRegister() {
    bool canPress = false;
    if (registerName.isNotEmpty &&
        registerSurname.isNotEmpty &&
        registerYearOfBirth.isNotEmpty &&
        registerEmail.isNotEmpty &&
        registerPhone.isNotEmpty &&
        registerPassword.isNotEmpty &&
        registerRepeatPassword.isNotEmpty &&
        registerPrivacyPolicy == true &&
        registerPassword == registerRepeatPassword) {
      canPress = true;
    }
    return canPress;
  }
}
