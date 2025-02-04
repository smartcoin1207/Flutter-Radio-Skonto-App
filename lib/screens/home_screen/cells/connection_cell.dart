import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/models/main_screen_data.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ConnectionCellWidget extends StatelessWidget {
  const ConnectionCellWidget({super.key, required this.mainData});

  final MainData mainData;

  @override
  Widget build(BuildContext context) {
    return _hasData() ?
    Container(
      color: AppColors.white,
      height: 126,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(Singleton.instance.translate('connect_with_us_title'), style: AppTextStyles.main16bold),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              mainData.phoneNumber != '' ? Padding(padding: const EdgeInsets.only(right: 8, left: 8),
                child: GestureDetector(
                  onTap: () {
                    final phoneNumber = mainData.phoneNumber.replaceAll(' ', '');
                    launchUrlString("tel://$phoneNumber");
                  },
                  child: SvgPicture.asset('assets/image/phone_button.svg', height: 50, width: 50,),
                ),
              ) : const SizedBox(),
              mainData.phoneNumber != '' ? Padding(padding: const EdgeInsets.only(right: 8, left: 8),
                child: GestureDetector(
                  onTap: () {_sendSMS(mainData.phoneNumber);},
                  child: SvgPicture.asset('assets/image/button_sms.svg', height: 50, width: 50,),
                ),
              ) : const SizedBox(),
              mainData.emailAddress != '' ? Padding(padding: const EdgeInsets.only(right: 8, left: 8),
                child: GestureDetector(
                  onTap: () {launchUrlString("mailto://${mainData.emailAddress}");},
                  child: SvgPicture.asset('assets/image/button_email.svg', height: 50, width: 50,),
                ),
              ) : const SizedBox(),
              mainData.whatsappSmsNo != '' ? Padding(padding: const EdgeInsets.only(right: 8, left: 8),
                child: GestureDetector(
                  onTap: () {_whatsapp();},
                  child: SvgPicture.asset('assets/image/button_whats_app.svg', height: 50, width: 50,),
                ),
              ) : const SizedBox(),
            ],
          )
        ],
      ),
    ) : const SizedBox();
  }

  _whatsapp() async{
    var contact = mainData.whatsappSmsNo.replaceAll(' ', '');
    var androidUrl = "whatsapp://send?phone=$contact&text=";
    var iosUrl = "https://wa.me/$contact?text=${Uri.parse('')}";

    try{
      if(Platform.isIOS){
        await launchUrl(Uri.parse(iosUrl));
      }
      else{
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception{}
  }

  void _sendSMS(String phone) async {
    final phoneNum = phone.replaceAll(' ', '');
    launchUrlString("sms://$phoneNum");
    // String _result = await sendSMS(message: message, recipients: recipents)
    //     .catchError((onError) {});
  }

  bool _hasData() {
    bool hasData = false;
    if (mainData.phoneNumber != '' || mainData.whatsappSmsNo != '' ||
        mainData.emailAddress != '') {
      hasData = true;
    }
    return hasData;
  }
}