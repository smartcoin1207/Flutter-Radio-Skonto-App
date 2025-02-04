import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:radio_skonto/core/extensions.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/helpers/constant.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/screens/player_helpers/audio_player_handler_impl.dart';
import 'package:share_plus/share_plus.dart';

class SettingViewByThreeDot extends StatefulWidget {
  const SettingViewByThreeDot({super.key, required this.itIsStream, required this.author, required this.title});

  final bool itIsStream;
  final String author;
  final String title;

  @override
  State<StatefulWidget> createState() => _SettingViewByThreeDotState();
}

class _SettingViewByThreeDotState extends State<SettingViewByThreeDot> {

  final AudioPlayerHandler audioHandler = Singleton.instance.audioHandler;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return StreamBuilder<double>(
      stream: audioHandler.speed,
      builder: (context, snapshot) {
        double speed = snapshot.data?? 1.0;
        return Container(
          color: AppColors.darkBlack,
          width: width,
          padding: App.edgeInsets.copyWith(top: App.padding),
          height: height * 0.75,
          child: Column(
            children: [
              Container(
                width: 134,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.white.withAlpha(150),
                  borderRadius: BorderRadius.all(Radius.circular(2)),
                ),
              ),
              30.hs,
              Text(
                widget.title,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: AppTextStyles.main18bold.copyWith(
                    color: AppColors.white, overflow: TextOverflow.ellipsis),
              ),
              10.hs,
              Text(
                widget.author,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: AppTextStyles.main18regular.copyWith(
                    color: AppColors.white, overflow: TextOverflow.ellipsis),
              ),
              30.hs,
              Row(
                children: [
                  Text(
                    Singleton.instance.translate('speed_title'),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: AppTextStyles.main18bold.copyWith(
                        color: AppColors.white, overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
              10.hs,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  circleSpeedView('1.0x', speed),
                  circleSpeedView('1.3x', speed),
                  circleSpeedView('1.5x', speed),
                  circleSpeedView('1.7x', speed),
                  circleSpeedView('2.0x', speed),
                ],
              ),
              30.hs,
              Row(
                children: [
                  Text(
                    Singleton.instance.translate('share_title'),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: AppTextStyles.main18bold.copyWith(
                        color: AppColors.white, overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
              10.hs,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  circleIconView(1, 'assets/icons/whatsapp_icon.svg', 16),
                  circleIconView(2, 'assets/icons/facebook_icon.svg', 19),
                  circleIconView(3, 'assets/icons/instagram_icon.svg', 16),
                  circleIconView(4, 'assets/icons/email_icon.svg', 13),
                  circleIconView(5, 'assets/icons/copy_icon.svg', 16),
                ],
              )
            ],
          ),
        );
      }
    );
  }

  Widget circleSpeedView(String text, double speed) {
    String selectedSpeed = text.replaceAll('x', '');
    bool isSelected = double.parse(selectedSpeed) == speed;
    return GestureDetector(
      onTap: () {
        setSpeed(text);
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
            color: AppColors.gray,
            borderRadius: BorderRadius.circular(24)
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: isSelected ? AppTextStyles.main16bold.copyWith(color: AppColors.darkBlack) : AppTextStyles.main16regular.copyWith(color: AppColors.black),
          ),
        ),
      ),
    );
  }

  Widget circleIconView(int index, String iconName, double size) {
    return GestureDetector(
      onTap: () {
        Share.share('Linc to share');
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
            color: AppColors.gray,
            borderRadius: BorderRadius.circular(24)
        ),
        child: Center(
          child: SvgPicture.asset(iconName,
              colorFilter:
              const ColorFilter.mode(AppColors.darkBlack, BlendMode.srcIn),
              width: size,
              height: size),
        ),
      ),
    );
  }

  void setSpeed(String text) {
    double speed = 0.0;
    if (text == '1.0x') {speed = 1.0;}
    if (text == '1.3x') {speed = 1.3;}
    if (text == '1.5x') {speed = 1.5;}
    if (text == '1.7x') {speed = 1.7;}
    if (text == '2.0x') {speed = 2.0;}
    audioHandler.setSpeed(speed);
  }
}
