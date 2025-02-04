import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_skonto/core/extensions.dart';
import 'package:radio_skonto/helpers/api_helper.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/providers/auth_provider.dart';
import 'package:radio_skonto/widgets/app_text_field_widget.dart';
import 'package:radio_skonto/widgets/rounded_button_widget.dart';
import 'package:radio_skonto/widgets/text_with_red_dot_widget.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String emailCode = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: Provider.of<AuthProvider>(context),
        child: Consumer<AuthProvider>(builder: (context, authProvider, _) {
          return Scaffold(
            appBar: AppBar(
              leading: const BackButton(
                  color: AppColors.white
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  100.hs,
                  Text(Singleton.instance.translate('forgot_password_title'), style: AppTextStyles.main24bold, textAlign: TextAlign.center),
                  45.hs,
                  Row(
                    children: [
                      TextWithRedDotWidget(text: Singleton.instance.translate('e_mail_address'))
                    ],
                  ),
                  10.hs,
                  AppTextFieldWidget(
                      onChanged: (text) {
                        emailCode = text;
                      }, hintText: Singleton.instance.translate('write_hint_text')),
                  40.hs,
                  RoutedButtonWidget(
                      isLoading: authProvider.forgotPasswordResponseState == ResponseState.stateLoading ? true : false,
                      title: Singleton.instance.translate('restore_title'), onTap: () {
                    authProvider.forgotPassword(emailCode, context);
                  }),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          );
        }
        )
    );
  }
}
