import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_skonto/helpers/api_helper.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/providers/auth_provider.dart';
import 'package:radio_skonto/screens/navigation_bar/navigation_bar.dart';
import 'package:radio_skonto/widgets/app_text_field_widget.dart';
import 'package:radio_skonto/widgets/rounded_button_widget.dart';
import 'package:radio_skonto/widgets/text_with_red_dot_widget.dart';

class PhoneVerificationScreen extends StatefulWidget {
  const PhoneVerificationScreen({super.key});

  @override
  State<PhoneVerificationScreen> createState() => _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  String smsCode = '';
  late Timer timer;
  int timerCount = 60;

  @override
  void initState() {
    super.initState();
    startTimer();
    Singleton.instance.writeRefreshTokenToSharedPreferences('');
    Singleton.instance.writeTokenToSharedPreferences('');
    Singleton.instance.writeUserNameToSharedPreferences('');
  }

  void startTimer() {
    timerCount = 60;
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (Timer timer) {
      if (timerCount != 0) {
        setState(() {
          timerCount--;
        });
      }
    },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: ChangeNotifierProvider.value(
            value: Provider.of<AuthProvider>(context),
            child: Consumer<AuthProvider>(builder: (context, authProvider, _) {
              String timerCountString = timerCount <= 0 ? '' : ' $timerCount';
              return Scaffold(
                appBar: AppBar(
                  leading: BackButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: ((context) => const MyNavigationBar()),
                          fullscreenDialog: true
                        ));
                      },
                      color: AppColors.white
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(Singleton.instance.translate('phone_number_verification'), style: AppTextStyles.main24bold, textAlign: TextAlign.center),
                      const SizedBox(height: 20),
                      Text(Singleton.instance.translate('phone_number_verification_description'), textAlign: TextAlign.center, style: AppTextStyles.main16regular),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          TextWithRedDotWidget(text: Singleton.instance.translate('code_received_by_sms'))
                        ],
                      ),
                      AppTextFieldWidget(
                          onChanged: (text) {
                            smsCode = text;
                          }, hintText: Singleton.instance.translate('write_hint_text')),
                      const SizedBox(height: 30),
                      RoutedButtonWidget(
                          isLoading: authProvider.phoneVerificationResponseState == ResponseState.stateLoading ? true : false,
                          title: Singleton.instance.translate('submit_title'),
                          onTap: () {
                            authProvider.verificationPhone(smsCode, context);
                          }),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: timerCount > 0 ? null : () {
                          timerCount = 60;
                          authProvider.resendVerificationPhone();
                        },
                        child: Text('${Singleton.instance.translate('send_sms_again_title')} ${timerCount == 0 ? '' : timerCount}', style: AppTextStyles.main16regular.copyWith(decoration: TextDecoration.underline)),
                      ),
                      // TextButton(onPressed: () {
                      //   if (timerCount <= 0) {
                      //     timerCount = 60;
                      //     authProvider.resendVerificationPhone();
                      //   }
                      // },
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: [
                      //         Text(Singleton.instance.translate('send_sms_again_title'), style: AppTextStyles.main16regular.copyWith(decoration: TextDecoration.underline)),
                      //         Text(timerCountString, style: AppTextStyles.main16regular)
                      //       ],
                      //     )
                      // )
                    ],
                  ),
                ),
              );
            })
        )
    );
  }
}
