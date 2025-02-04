import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_skonto/core/extensions.dart';
import 'package:radio_skonto/helpers/api_helper.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/helpers/validator.dart';
import 'package:radio_skonto/providers/auth_provider.dart';
import 'package:radio_skonto/screens/login_screen/phone_field_widget.dart';
import 'package:radio_skonto/screens/login_screen/year_selector_widget.dart';
import 'package:radio_skonto/widgets/app_text_field_widget.dart';
import 'package:radio_skonto/widgets/custom_check_box.dart';
import 'package:radio_skonto/widgets/rounded_button_widget.dart';
import 'package:radio_skonto/widgets/text_with_first_red_dot_widget.dart';
import 'package:radio_skonto/widgets/text_with_red_dot_widget.dart';

class RegisterWidget extends StatelessWidget {
  const RegisterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Text(Singleton.instance.translate('log_in_or_create_new_account'), style: AppTextStyles.main18bold),
            const SizedBox(height: 40),
            TextWithRedDotWidget(text: Singleton.instance.translate('name_title')),
            10.hs,
            AppTextFieldWidget(onChanged: (text) {
              authProvider.registerName = text;
            }, capitalization: TextCapitalization.words, hintText: Singleton.instance.translate('hint_text'), errorText: validateNotEmptyField(authProvider.registerName, !authProvider.registerIsButtonRegisterPress),),
            const SizedBox(height: 45),
            TextWithRedDotWidget(text: Singleton.instance.translate('surname_title')),
            10.hs,
            AppTextFieldWidget(
                onChanged: (text) {
                  authProvider.registerSurname = text;
                }, capitalization: TextCapitalization.words, hintText: Singleton.instance.translate('hint_text'), errorText: validateNotEmptyField(authProvider.registerSurname, !authProvider.registerIsButtonRegisterPress),),
            const SizedBox(height: 45),
            TextWithRedDotWidget(text: Singleton.instance.translate('year_of_birth')),
            10.hs,
            YearSelectorWidget(onSelectYear: (String text) {
              authProvider.registerYearOfBirth = text;
            }, initText: authProvider.registerYearOfBirth,),
            const SizedBox(height: 45),
            Text(Singleton.instance.translate('gender_title'), style: AppTextStyles.main16regular),
            const SizedBox(height: 20),
            Row(
              children: [
                CustomCheckBoxWidget(
                    value: authProvider.registerWomen,
                    selectedValue: (value) {
                      authProvider.registerMan = false;
                      authProvider.registerWomen = true;
                      authProvider.notifyListeners();
                      },
                    text: Singleton.instance.translate('woman_title')),
                const SizedBox(width: 30),
                CustomCheckBoxWidget(
                    value: authProvider.registerMan,
                    selectedValue: (value) {
                      authProvider.registerWomen = false;
                      authProvider.registerMan = true;
                      authProvider.notifyListeners();
                      },
                    text: Singleton.instance.translate('man_title')),
              ],
            ),
            const SizedBox(height: 45),
            Text(Singleton.instance.translate('the_level_of_education'), style: AppTextStyles.main16regular),
            const SizedBox(height: 20),
            Column(
              children: [
                CustomCheckBoxWidget(
                    value: authProvider.registerEducationBasic,
                    selectedValue: (value) {
                      authProvider.registerEducationBasic = true;
                      authProvider.registerEducationAverage = false;
                      authProvider.registerEducationHighest = false;
                      authProvider.notifyListeners();
                      },
                    text: Singleton.instance.translate('basic_education_title')),
                const SizedBox(height: 25),
                CustomCheckBoxWidget(
                    value: authProvider.registerEducationAverage,
                    selectedValue: (value) {
                      authProvider.registerEducationBasic = false;
                      authProvider.registerEducationAverage = true;
                      authProvider.registerEducationHighest = false;
                      authProvider.notifyListeners();
                    },
                    text: Singleton.instance.translate('average_education_title')),
                const SizedBox(height: 25),
                CustomCheckBoxWidget(
                    value: authProvider.registerEducationHighest,
                    selectedValue: (value) {
                      authProvider.registerEducationBasic = false;
                      authProvider.registerEducationAverage = false;
                      authProvider.registerEducationHighest = true;
                      authProvider.notifyListeners();
                    },
                    text: Singleton.instance.translate('highest_education_title')),
              ],
            ),
            const SizedBox(height: 35),
            TextWithRedDotWidget(text: Singleton.instance.translate('e_mail_address')),
            5.hs,
            AppTextFieldWidget(onChanged: (text) {
              authProvider.registerEmail = text;
              authProvider.notifyListeners();
            }, hintText: Singleton.instance.translate('hint_text'), errorText: validateNotEmptyField(authProvider.registerEmail, !authProvider.registerIsButtonRegisterPress)),
            const SizedBox(height: 45),
            TextWithRedDotWidget(text: Singleton.instance.translate('phone_title')),
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(padding: const EdgeInsets.only(top: 5),
                      child: SizedBox(
                          width: 96,
                          child: PhoneFieldWidget(selectedValue: (val){
                            authProvider.registerPhoneCode = val;
                          })),
                    ),
                    //const Icon(Icons.arrow_drop_down, color: AppColors.black),
                    Expanded(child:
                    AppTextFieldWidget(onChanged: (text) {
                      authProvider.registerPhone = text;
                      authProvider.notifyListeners();
                    },
                    keyboardType: TextInputType.phone,
                    hideLine: true,
                    errorText: validateNotEmptyField(authProvider.registerPhone, !authProvider.registerIsButtonRegisterPress),
                    hintText: Singleton.instance.translate('hint_text')),
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  height: 2,
                  color: AppColors.gray,
                )
              ],
            ),
            const SizedBox(height: 45),
            TextWithRedDotWidget(text: Singleton.instance.translate('password_title')),
            AppTextFieldWidget(onChanged: (text) {
              authProvider.registerPassword = text;
              authProvider.notifyListeners();
            }, hintText: Singleton.instance.translate('hint_text'),
              errorText: validateNotEmptyField(authProvider.registerPassword, !authProvider.registerIsButtonRegisterPress),
              isPassword: true),
            const SizedBox(height: 45),
            TextWithRedDotWidget(text: Singleton.instance.translate('repeat_the_password')),
            AppTextFieldWidget(onChanged: (text) {
              authProvider.registerRepeatPassword = text;
              authProvider.notifyListeners();
            },
                errorText: validateNotEmptyField(authProvider.registerRepeatPassword, !authProvider.registerIsButtonRegisterPress),
                hintText: Singleton.instance.translate('hint_text'), isPassword: true),
            const SizedBox(height: 45),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.scale(
                  scale: 1.5,
                  child: Checkbox(
                      value: authProvider.registerPrivacyPolicy,
                      onChanged: (value) {
                        authProvider.registerPrivacyPolicy = value!;
                        authProvider.notifyListeners();
                      }),
                ),
                Expanded(child: TextWithRedDotWidget(
                    text: Singleton.instance.translate('read_and_agree_policy'),
                    secondBoldText: Singleton.instance.translate('read_and_agree_policy_bold_text'),
                )),
              ],
            ),
            const SizedBox(height: 45),
            TextWithFirstRedDotWidget(text: Singleton.instance.translate('required_fields_title')),
            const SizedBox(height: 45),
            RoutedButtonWidget(
              isLoading: authProvider.registerResponseState == ResponseState.stateLoading ? true : false,
              title: Singleton.instance.translate('next_title'), onTap: () {
              authProvider.registerIsButtonRegisterPress = true;
              if (authProvider.canPressNextOnRegister()) {
                authProvider.register(context);
              } else {

              }
              authProvider.notifyListeners();
            }),
            const SizedBox(height: 100)
          ],
        ),
      ),
    );
  }
}