import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_skonto/helpers/api_helper.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/helpers/validator.dart';
import 'package:radio_skonto/providers/auth_provider.dart';
import 'package:radio_skonto/providers/report_bug.dart';
import 'package:radio_skonto/screens/verification_screens/phone_verification_screen.dart';
import 'package:radio_skonto/widgets/app_text_field_widget.dart';
import 'package:radio_skonto/widgets/rounded_button_widget.dart';
import 'package:radio_skonto/widgets/text_with_red_dot_widget.dart';

class ReportBugScreen extends StatefulWidget {
  const ReportBugScreen({super.key});

  @override
  State<ReportBugScreen> createState() => _ReportBugScreenState();
}

class _ReportBugScreenState extends State<ReportBugScreen> {
  String messageText = '';
  String nameSurname = '';
  String email = '';

  bool firstLoad = true;

  @override
  void initState() {
    super.initState();
    firstLoad = true;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: Provider.of<ReportBugProvider>(context),
        child: Consumer<ReportBugProvider>(builder: (context, bugProvider, _) {
          return Scaffold(
            appBar: AppBar(
              leading: const BackButton(
                  color: AppColors.white
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(Singleton.instance.translate('report_bug'), style: AppTextStyles.main24bold, textAlign: TextAlign.center),
                    const SizedBox(height: 20),
                    TextWithRedDotWidget(text: Singleton.instance.translate('message_title')),
                    AppTextFieldWidget(
                      minLine: 5,
                      onChanged: (text) {
                        messageText = text;
                      },
                      hintText: Singleton.instance.translate('write_hint_text'),
                        errorText: validateNotEmptyField(messageText, firstLoad),
                    ),
                    const SizedBox(height: 30),
                    Text(Singleton.instance.translate('name_and_surname_title'), style: AppTextStyles.main16regular),
                    AppTextFieldWidget(
                        onChanged: (text) {
                          setState(() {
                            nameSurname = text;
                          });
                        }, hintText: ''),
                    const SizedBox(height: 30),
                    Text(Singleton.instance.translate('e_mail_address'), style: AppTextStyles.main16regular),
                    AppTextFieldWidget(
                      onChanged: (text) {
                        setState(() {
                          email = text;
                        });
                      },
                      hintText: ''
                    ),
                    const SizedBox(height: 30),
                    RoutedButtonWidget(
                        isLoading: bugProvider.sendReportBugResponseState == ResponseState.stateLoading ? true : false,
                        title: Singleton.instance.translate('submit_title'), onTap: () {
                          setState(() {
                            firstLoad = false;
                          });
                          bugProvider.sendReportBugData(messageText, nameSurname, email, context);
                    }),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          );
        }
        )
    );
  }
}
