import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/helpers/constant.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/models/main_screen_data.dart';
import 'package:radio_skonto/widgets/app_cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SocialMediaCellWidget extends StatelessWidget {
  const SocialMediaCellWidget({super.key, required this.mainData});

  final MainData mainData;

  @override
  Widget build(BuildContext context) {
    double size = 44.0;
    return _hasData() ?
    Container(
      color: AppColors.white,
      height: 126,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(Singleton.instance.translate('follow_us_title'), style: AppTextStyles.main16bold),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              mainData.facebookLink != '' ? Padding(padding: const EdgeInsets.only(right: 8, left: 8),
                child: GestureDetector(
                  onTap: () {
                    //launchUrlString("fb://facewebmodal/f?href=${mainData.facebookLink}");
                    launchUrlString(mainData.facebookLink);
                    //_openLink(mainData.facebookLink, context);
                    },
                  child: SvgPicture.asset('assets/image/facebook_icon_round.svg', height: size, width: size,),
                ),
              ) : const SizedBox(),
              mainData.instagramLink != '' ? Padding(padding: const EdgeInsets.only(right: 8, left: 8),
                child: GestureDetector(
                  onTap: () {
                    launchUrlString(mainData.instagramLink);
                    //_openLink(mainData.instagramLink, context);
                    },
                  child: SvgPicture.asset('assets/image/instagramm_icon_round.svg', height: size, width: size,),
                ),
              ) : const SizedBox(),
              mainData.tiktokLink != '' ? Padding(padding: const EdgeInsets.only(right: 8, left: 8),
                child: GestureDetector(
                  onTap: () {
                    launchUrlString(mainData.tiktokLink);
                  },
                  child: SvgPicture.asset('assets/image/tic_toc_icon_round.svg', height: size, width: size,),
                ),
              ) : const SizedBox(),
              mainData.linkedinLink != '' ? Padding(padding: const EdgeInsets.only(right: 8, left: 8),
                child: GestureDetector(
                  onTap: () {
                    launchUrlString(mainData.linkedinLink);
                  },
                  child: SvgPicture.asset('assets/image/lincendin_icon_round.svg', height: size, width: size,),
                ),
              ) : const SizedBox(),
              mainData.twitterXLink != '' ? Padding(padding: const EdgeInsets.only(right: 8, left: 8),
                child: GestureDetector(
                  onTap: () {
                    launchUrlString(mainData.twitterXLink);
                  },
                  child: SvgPicture.asset('assets/image/x_icon_round.svg', height: size, width: size,),
                ),
              ) : const SizedBox(),
            ],
          )
        ],
      ),
    ) : const SizedBox();
  }

  bool _hasData() {
    bool hasData = false;
    if (mainData.facebookLink != '' || mainData.instagramLink != '' ||
        mainData.tiktokLink != '' || mainData.linkedinLink != '' ||
        mainData.twitterXLink != '') {
      hasData = true;
    }
    return hasData;
  }

  void _openLink(String link, BuildContext context) async {
    Singleton.instance.openUrl(link, context);
  }
}