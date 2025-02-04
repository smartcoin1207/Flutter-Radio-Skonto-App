import 'package:flutter/material.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/widgets/app_text_field_widget.dart';
import 'package:radio_skonto/widgets/rounded_button_widget.dart';
import 'package:radio_skonto/widgets/text_with_red_dot_widget.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({
    required this.onChangedEmail,
    required this.onChangedPassword,
    required this.onRegisterPress,
    required this.onForgotPasswordPress,
    required this.onLogInPress,
    required this.isLogInButtonLoading,
    super.key,});

  final Function(String text) onChangedEmail;
  final Function(String text) onChangedPassword;
  final Function() onRegisterPress;
  final Function() onForgotPasswordPress;
  final Function() onLogInPress;
  final bool isLogInButtonLoading;

  @override
  Widget build(BuildContext context) {
    String initialLogin = Singleton.instance.getLoginFromSharedPreferences();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Text(Singleton.instance.translate('log_in_or_create_new_account'), style: AppTextStyles.main18bold),
            const SizedBox(height: 30),
            TextWithRedDotWidget(text: Singleton.instance.translate('e_mail_address')),
            AppTextFieldWidget(onChanged: (text) {
              onChangedEmail(text);
            }, hintText: '', initialText: initialLogin,),
            const SizedBox(height: 30),
            TextWithRedDotWidget(text: Singleton.instance.translate('password_title')),
            AppTextFieldWidget(
                isPassword: true,
                onChanged: (text) {
                  onChangedPassword(text);
            }, hintText: ''),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () {
                      onRegisterPress();
                      },
                    child: Text(Singleton.instance.translate('register_title'), style: AppTextStyles.main16bold)),
                TextButton(onPressed: () {
                  onForgotPasswordPress();
                  }, child: Text(Singleton.instance.translate('forgot_password_title'), style: AppTextStyles.main16bold)),
              ],
            ),
            const SizedBox(height: 25),
            RoutedButtonWidget(
                isLoading: isLogInButtonLoading,
                title: Singleton.instance.translate('log_in_title'),
                onTap: () {
                  onLogInPress();
                }
            ),
            const SizedBox(height: 60)
          ],
        ),
      ),
    );
  }
}