import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/helpers/constant.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/models/main_screen_data.dart';
import 'package:radio_skonto/providers/main_screen_provider.dart';
import 'package:radio_skonto/widgets/app_cached_network_image.dart';
import 'package:radio_skonto/widgets/round_button_with_icon.dart';

class PopupBannerWidget extends StatelessWidget {
  const PopupBannerWidget({required this.banner, super.key});

  final AdBanner banner;

  @override
  Widget build(BuildContext context) {

   Provider.of<MainScreenProvider>(context, listen: false).
   sendEventBannerShown('banner', [banner.id]);

    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,
      content: Container(
        //width: double.infinity,
        height: 700,
        child: Padding(padding: const EdgeInsets.only(left: 25, right: 25),
          child: Container(
            width: 600,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    RoutedButtonWithIconWidget(iconName: 'assets/icons/close_icon.svg',
                      iconColor: AppColors.darkBlack,
                      size: 32,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      color: AppColors.gray, iconSize: 12,)
                  ],
                ),
                const SizedBox(height: 15),
                AppCachedNetworkImage(
                  Singleton.instance.checkIsFoolUrl(banner.image),
                  width: double.infinity,
                  height: 510,
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                const SizedBox(height: 15),
                banner.button == true ?
                ElevatedButton(
                  style: ButtonStyle(backgroundColor:MaterialStateProperty.all(AppColors.red)),
                  onPressed: () {
                    if (banner.link != '') {
                      _openLink(banner.link!, context);
                    }
                  },
                  child: SizedBox(
                      height: 42.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(Singleton.instance.translate('see_more_title'), style: AppTextStyles.main16regular.copyWith(color: AppColors.white),),
                        ],
                      )
                  ),
                ) : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openLink(String link, BuildContext context) async {
    Provider.of<MainScreenProvider>(context, listen: false).sendEventBannerClick('banner', banner.id);
    Singleton.instance.openUrl(link, context);
  }
}