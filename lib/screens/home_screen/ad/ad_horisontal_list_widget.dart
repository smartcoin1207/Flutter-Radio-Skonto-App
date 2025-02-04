import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/constant.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/models/main_screen_data.dart';
import 'package:radio_skonto/providers/main_screen_provider.dart';
import 'package:radio_skonto/widgets/app_cached_network_image.dart';
import 'package:radio_skonto/widgets/button_read_more_in_white_frame.dart';
import 'package:radio_skonto/widgets/round_button_with_icon.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AdHorizontalListWidget extends StatefulWidget {
  const AdHorizontalListWidget(
      {super.key, required this.banners});

  @override
  State<AdHorizontalListWidget> createState() => _AdHorizontalListWidgetState();

  final List<AdBanner> banners;
}

class _AdHorizontalListWidgetState extends State<AdHorizontalListWidget> {

  int currentSelectedIndex = 0;
  PageController controller = PageController(viewportFraction:  0.35);
  List<AdBanner> filteredBanners = [];
  Timer? _nextPageTimer;
  bool _isWidgetIsWisible = false;

  @override
  void initState() {
    for (AdBanner b in widget.banners) {
      if (b.type == 'banner_template_3_mobile') {
        filteredBanners.add(b);
      }
    }
    _nextPageTimer = Timer.periodic(const Duration(seconds: 3), (Timer t) => _autoNextPageAction());
    _sentStatistic();
    super.initState();
  }

  void _autoNextPageAction() {
    if (_isWidgetIsWisible == true) {
      if (controller.page != null && controller.page! >= filteredBanners.length - 1) {
        _nextPageTimer?.cancel();
      }
      controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
    }
  }

  void _sentStatistic() {
    if (filteredBanners.isNotEmpty && filteredBanners.length <= currentSelectedIndex) {
      final provider = Provider.of<MainScreenProvider>(context, listen: false);
      final selectedBanner = filteredBanners[currentSelectedIndex];
      bool needSendStatistic = true;
      if (provider.listOfSentHorizontalAdIds.isNotEmpty) {
        for (int alreadyAdded in provider.listOfSentHorizontalAdIds) {
          if (alreadyAdded == selectedBanner.id) {
            needSendStatistic = false;
          }
        }
        if (needSendStatistic == true) {
          provider.sendEventBannerShown('banner', [selectedBanner.id]);
          provider.listOfSentHorizontalAdIds.add(selectedBanner.id);
        }
      } else {
        provider.sendEventBannerShown('banner', [selectedBanner.id]);
        provider.listOfSentHorizontalAdIds.add(selectedBanner.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _sentStatistic();
    return filteredBanners.isEmpty ?
      const SizedBox() :
    VisibilityDetector(
      key: Key('AdHorizontalListWidget-key'),
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction > 0.5) {
          _isWidgetIsWisible = true;
        }
      },
      child: Container(
        width: double.infinity,
        color: AppColors.white,
        child: Container(
            height: 361,
            margin: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 33),
            decoration: BoxDecoration(
              color: AppColors.black,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                GestureDetector(
                  onTap: () {
                    if (filteredBanners[currentSelectedIndex].link != '') {
                      Singleton.instance.openUrl(filteredBanners[currentSelectedIndex].link!, context);
                      Provider.of<MainScreenProvider>(context, listen: false).sendEventBannerClick(
                          'banner',
                          filteredBanners[currentSelectedIndex].id);
                    }
                  },
                  child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 600),
                      child: AppCachedNetworkImage(
                        key: UniqueKey(),
                        Singleton.instance.checkIsFoolUrl(filteredBanners[currentSelectedIndex].image),
                        width: double.infinity,
                        height: 361,
                        boxFit: BoxFit.cover,
                        decoration: BoxDecoration(
                          color: AppColors.black,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            App.appBoxShadow
                          ],
                        ),
                      )
                  ),
                ),
                Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                        margin: const EdgeInsets.only(left: 0, right: 0),
                        height: 92,
                        decoration: BoxDecoration(
                          color: AppColors.white.withAlpha(30),
                          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(padding: const EdgeInsets.only(left: 15),
                              child: RoutedButtonWithIconWidget(iconName: 'assets/icons/arrow_left.svg',
                                iconColor: AppColors.white,
                                size: 50,
                                onTap: () {
                                  if (currentSelectedIndex > 0) {
                                    setState(() {
                                      currentSelectedIndex--;
                                    });
                                  }
                                  controller.jumpToPage(currentSelectedIndex);
                                },
                                color: AppColors.white.withAlpha(64),
                                iconSize: 15,
                              ),
                            ),
                            SizedBox(
                              width: 195,
                              child: PageView(
                                onPageChanged: (index) {
                                  setState(() {
                                    currentSelectedIndex = index;
                                  });
                                },
                                controller: controller,
                                scrollDirection: Axis.horizontal,
                                children: filteredBanners.map((item) =>
                                    Center(
                                      child: AppCachedNetworkImage(
                                        opacity: 0.5,
                                        Singleton.instance.checkIsFoolUrl(item.image),
                                        boxFit: BoxFit.cover,
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: AppColors.black,
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                      ),
                                    )
                                ).toList(),
                              ),
                            ),
                            Padding(padding: const EdgeInsets.only(right: 15),
                              child: RoutedButtonWithIconWidget(iconName: 'assets/icons/arrow_right.svg',
                                iconColor: AppColors.white,
                                size: 50,
                                onTap: () {
                                  if (currentSelectedIndex < filteredBanners.length - 1) {
                                    setState(() {
                                      currentSelectedIndex++;
                                    });
                                  }
                                  controller.jumpToPage(currentSelectedIndex);
                                },
                                color: AppColors.white.withAlpha(64),
                                iconSize: 15,
                              ),
                            ),
                          ],
                        )
                    )
                ),
                Padding(padding: const EdgeInsets.only(left: 18, right: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      filteredBanners[currentSelectedIndex].button == false ?
                      const SizedBox() :
                      Row(
                        children: [
                          const SizedBox(width: 10),
                          ButtonReadMoreInWhiteFrameWidget(
                              title: Singleton.instance.translate('read_more_title'),
                              onTap: () {
                                if (filteredBanners[currentSelectedIndex].link != '') {
                                  Singleton.instance.openUrl(filteredBanners[currentSelectedIndex].link!, context);
                                  Provider.of<MainScreenProvider>(context, listen: false).sendEventBannerClick(
                                      'banner',
                                      filteredBanners[currentSelectedIndex].id);
                                }
                              }
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            )
        ),
      ),
    );
  }
}