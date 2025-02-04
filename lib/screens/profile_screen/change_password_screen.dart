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
import 'package:radio_skonto/widgets/text_with_first_red_dot_widget.dart';
import 'package:radio_skonto/widgets/text_with_red_dot_widget.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  String currentPassword = '';
  String password = '';
  String repeatPassword = '';

  static const _bigPadding = SizedBox(height: 37);
  static const _smallPadding = SizedBox(height: 8);

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
              padding: const EdgeInsets.only(top: 20, bottom: 20, left: 25, right: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _smallPadding,
                  Text(Singleton.instance.translate('change_password_title'), style: AppTextStyles.main18bold),
                  _bigPadding,
                  TextWithRedDotWidget(text: Singleton.instance.translate('current_password')),
                  _smallPadding,
                  AppTextFieldWidget(
                      isPassword: true,
                      onChanged: (text) {
                        setState(() {
                          currentPassword = text;
                        });
                      }, hintText: ''),
                  const SizedBox(height: 50),
                  TextWithRedDotWidget(text: Singleton.instance.translate('password_title')),
                  _smallPadding,
                  AppTextFieldWidget(
                      isPassword: true,
                      onChanged: (text) {
                        setState(() {
                          password = text;
                        });
                      }, hintText: ''),
                  _bigPadding,
                  TextWithRedDotWidget(text: Singleton.instance.translate('repeat_the_password')),
                  _smallPadding,
                  AppTextFieldWidget(
                      isPassword: true,
                      onChanged: (text) {
                        setState(() {
                          repeatPassword = text;
                        });
                      },
                      hintText: '',
                      errorText: password == repeatPassword ? null : Singleton.instance.translate('passwords_not_the_same'),
                  ),
                  _bigPadding,
                  TextWithFirstRedDotWidget(text: Singleton.instance.translate('required_fields_title')),
                  const SizedBox(height: 45),
                  RoutedButtonWidget(
                      isLoading: authProvider.changePasswordResponseState == ResponseState.stateLoading ? true : false,
                      title: Singleton.instance.translate('save_title'), onTap: () {
                    authProvider.changePassword(currentPassword, password, repeatPassword, context);
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
