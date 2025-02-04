import 'dart:io';
import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:radio_skonto/custom_library/custom_app_slider.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/constant.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/models/main_screen_data.dart';
import 'package:radio_skonto/screens/search/search_screen.dart';
import 'package:radio_skonto/widgets/app_cached_network_image.dart';

class AppBarMainScreenWidget extends StatelessWidget {
  AppBarMainScreenWidget({super.key, required this.onRadioIconTap, required this.mainDataList, required this.appBarIsExpanded, required this.onItemFocus, required this.data, required this.currentSelectedDataIndex, required this.controller, required this.carouselSliderController});

  final MainData data;
  final int currentSelectedDataIndex;
  final Function(int?) onRadioIconTap;
  final Function(int) onItemFocus;
  final List<MainData> mainDataList;
  final bool appBarIsExpanded;
  static const Duration animationDuration = Duration(milliseconds: 350);
  final InfiniteScrollController controller;
  final CarouselSliderController carouselSliderController;

  static const double paddingNormal = 0;
  static const double heightExpanded = 40;

  @override
  Widget build(BuildContext context) {
    final double appBarHeight = appBarIsExpanded ? heightExpanded : paddingNormal;
    return Container(
        color: Colors.transparent,
        child: Stack(
          children: [
            // Positioned(
            //     top: 0,
            //     child: Container(
            //       color: AppColors.red,
            //       child: Image.asset(
            //         mainDataList[currentSelectedDataIndex].name == 'RADIO SKONTO' ? backgroundSconto :
            //         mainDataList[currentSelectedDataIndex].name == 'SKONTO PLUS' ? backgroundScontoPlus :
            //         mainDataList[currentSelectedDataIndex].name == 'RADIO TEV' ? backgroundTev :
            //         mainDataList[currentSelectedDataIndex].name == 'LOUNGE FM' ? backgroundLoungeFm :
            //         mainDataList[currentSelectedDataIndex].name == 'TEV LV' ? backgroundTevLv : backgroundSconto,
            //         fit: BoxFit.fill,
            //         width: MediaQuery.sizeOf(context).width,
            //         height: MediaQuery.sizeOf(context).height,
            //       ),
            //     )
            // ),
            Padding(padding: const EdgeInsets.only(top: paddingNormal, left: 15, right: 15, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.search, color: AppColors.white, size: 28,
                    ),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                        builder: (context) => const SearchScreen(),
                      ),);
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(padding: const EdgeInsets.only(right: 17),
                        child: GestureDetector(
                          child:
                          //Image.file(File('file:///data/user/0/com.radio.skonto.radio_skonto/app_flutter/file_01.svg'), width: 30, height: 30,)
                          SvgPicture.asset(
                            'assets/icons/alarm_icon.svg',
                            width: 21,
                            height: 21,
                            colorFilter: ColorFilter.mode(Theme.of(context).appBarTheme.iconTheme!.color!, BlendMode.srcIn),
                          ),
                        ),
                      ),
                      Padding(padding: const EdgeInsets.only(right: 17),
                        child: GestureDetector(
                          child: SvgPicture.asset(
                            'assets/icons/heart_icon.svg',
                            width: 20,
                            height: 20,
                            colorFilter: ColorFilter.mode(Theme.of(context).appBarTheme.iconTheme!.color!, BlendMode.srcIn),
                          ),
                        ),
                      ),
                      Padding(padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () {
                            Singleton.instance.isMainMenu = true;
                            Scaffold.of(context).openEndDrawer();
                          },
                          child: SvgPicture.asset(
                            'assets/icons/burger_icon.svg',
                            width: 17,
                            height: 17,
                            colorFilter: ColorFilter.mode(Theme.of(context).appBarTheme.iconTheme!.color!, BlendMode.srcIn),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Column(
              children: [
                AnimatedContainer(
                  alignment: FractionalOffset.bottomCenter,
                  duration: animationDuration,
                  height: appBarHeight,
                ),
                AnimatedSwitcher(
                    duration: animationDuration,
                    child:
                    appBarIsExpanded == true ?
                    Container(
                        height: 115,
                        width: double.infinity,
                        child:
                        CustomCarouselSlider(
                          key: const ValueKey<int>(8765),
                          disableGesture: false,
                          carouselController: carouselSliderController,
                          options: CarouselOptions(
                              viewportFraction: 0.26,
                              disableCenter: false,
                              initialPage: currentSelectedDataIndex,
                              enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                              enlargeCenterPage: true,
                              onPageChanged: (index, reason) {
                                Future.delayed(const Duration(milliseconds: 500), () {
                                  onItemFocus(index);
                                });
                              }
                          ),
                          items: List.generate(mainDataList.length, ((index) {
                            return GestureDetector(
                              onTap: () {
                                onRadioIconTap(index);
                              },
                              child: _buildItem(context, index, mainDataList[index], 115),
                            );
                          })),
                        )
                    )
                        :
                    GestureDetector(
                        key: const ValueKey<int>(9983),
                        onTap: () {
                          onRadioIconTap(null);
                        },
                        child: Center(
                          child: _buildItem(context, 0, mainDataList[currentSelectedDataIndex], 48),
                        )
                    )
                ),
              ],
            ),
          ],
        )
    );
  }

  Widget _buildItem(BuildContext context, int index, MainData mainData, double size) {
    double imagePadding = 10;
    double topMargin = size == 48 ? 5.0 : 0.0;
    size == 48 ? imagePadding = 5 : imagePadding = 10;
    bool isSvg = true;
    if (mainData.upperImage.contains('jpg')) {
      isSvg = false;
    }
    if (mainData.upperImage.contains('png')) {
      isSvg = false;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: topMargin),
          padding: EdgeInsets.all(imagePadding),
          height: size,
          width: size,
          decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white
          ),
          child: Center(
            child: isSvg ?
            SvgPicture.network(
              width: size,
              height: size,
              Singleton.instance.checkIsFoolUrl(mainData.upperImage),
            ) :
            AppCachedNetworkImage(
              Singleton.instance.checkIsFoolUrl(mainData.upperImage),
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              )
            ),
          ),
        )
      ],
    );
  }
}