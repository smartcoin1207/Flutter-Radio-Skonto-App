import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/helpers/constant.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/models/main_screen_data.dart';
import 'package:radio_skonto/providers/player_provider.dart';
import 'package:radio_skonto/widgets/app_cached_network_image.dart';
import 'package:radio_skonto/widgets/round_button_with_icon.dart';

class CellFirstMainBig extends StatelessWidget {
  const CellFirstMainBig({super.key, required this.isExpanded, required this.data,});

  final bool isExpanded;
  final MainData data;

  @override
  Widget build(BuildContext context) {
    double leftPadding = 24;
    double rightPadding = 24;
    double containerWidth = 70;
    double screenWidth = MediaQuery.sizeOf(context).width;
    double imageSize = screenWidth - leftPadding - rightPadding;
    if (isExpanded == false) {
      imageSize = imageSize - containerWidth;
    }

    return ChangeNotifierProvider.value(
        value: Provider.of<PlayerProvider>(context),
        child: Consumer<PlayerProvider>(builder: (context, playerProvider, _) {
          return Container(
            color: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.only(left: leftPadding, right: rightPadding, top: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Text(data.name, style: AppTextStyles.main18bold.copyWith(color: AppColors.white)),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(child: Container(
                        height: imageSize,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: AppCachedNetworkImage(
                          //Singleton.instance.checkIsFoolUrl(playerProvider.itemIsChanged == true ?
                          Singleton.instance.checkIsFoolUrl(data.cardImage),
                                //: playerProvider.playNowMediaItem.artUri.toString()),
                          width: imageSize,
                          height: imageSize,
                          boxFit: BoxFit.fill,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),)
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child:
                        isExpanded ? const SizedBox() :
                        Container(width: containerWidth,
                            padding: const EdgeInsets.only(left: 24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: SvgPicture.asset(
                                    'assets/icons/heart_icon.svg',
                                    width: 20,
                                    height: 20,
                                    colorFilter: ColorFilter.mode(Theme.of(context).appBarTheme.iconTheme!.color!, BlendMode.srcIn),
                                  ),
                                  onPressed: () {

                                  },
                                ),
                                const SizedBox(height: 10),
                                IconButton(
                                  icon: SvgPicture.asset(
                                    'assets/icons/like_icon.svg',
                                    width: 25,
                                    height: 25,
                                    colorFilter: ColorFilter.mode(Theme.of(context).appBarTheme.iconTheme!.color!, BlendMode.srcIn),
                                  ),
                                  onPressed: () {

                                  },
                                ),
                                const SizedBox(height: 10),
                                IconButton(
                                  icon: SvgPicture.asset(
                                    'assets/icons/dislike_icon.svg',
                                    width: 25,
                                    height: 25,
                                    colorFilter: ColorFilter.mode(Theme.of(context).appBarTheme.iconTheme!.color!, BlendMode.srcIn),
                                  ),
                                  onPressed: () {

                                  },
                                )
                              ],
                            )
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: isExpanded ? Row(
                      children: [
                        RoutedButtonWithIconWidget(iconName: 'assets/icons/heart_not_empty.svg',
                          iconColor: AppColors.red,
                          size: 50,
                          onTap: () {

                          },
                          color: AppColors.white, iconSize: 20,
                        ),
                        const SizedBox(width: 8),
                        RoutedButtonWithIconWidget(iconName: 'assets/icons/like_icon.svg',
                          iconColor: AppColors.white,
                          size: 50,
                          onTap: () {

                          },
                          color: AppColors.white.withOpacity(0.30), iconSize: 25,
                        ),
                        const SizedBox(width: 8),
                        RoutedButtonWithIconWidget(iconName: 'assets/icons/dislike_icon.svg',
                          iconColor: AppColors.white,
                          size: 50,
                          onTap: () {
                          },
                          color: AppColors.white.withOpacity(0.30), iconSize: 25,
                        )
                      ],
                    ) : const SizedBox(),
                  ),
                  Padding(padding: EdgeInsets.only(top: isExpanded ? 10 : 0, bottom: 5),
                    child: Text(
                      //playerProvider.itemIsChanged == true ?
                        data.name,
                            //: playerProvider.playNowMediaItem.artist?? '',
                        style: AppTextStyles.main24bold.copyWith(color: AppColors.white)),
                  ),
                  // Text(
                  //     //playerProvider.playNowMediaItem.title == '' ?
                  //     data.subtitle,
                  //         //: playerProvider.playNowMediaItem!.title,
                  //     style: AppTextStyles.main14regular.copyWith(color: AppColors.white)),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          );
        }));
  }
}