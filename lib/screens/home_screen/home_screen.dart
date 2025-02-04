import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:flutter/material.dart';
import 'package:infinite_carousel/infinite_carousel.dart' as ics;
import 'package:provider/provider.dart';
import 'package:radio_skonto/custom_library/custom_app_slider.dart';
import 'package:radio_skonto/helpers/api_helper.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/constant.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/models/main_screen_data.dart';
import 'package:radio_skonto/providers/main_screen_provider.dart';
import 'package:radio_skonto/providers/player_provider.dart';
import 'package:radio_skonto/screens/home_screen/ad/popup_banner_widget.dart';
import 'package:radio_skonto/screens/home_screen/app_bar/app_bar_main_screen.dart';
import 'package:radio_skonto/screens/home_screen/home_screen_main_view.dart';
import 'package:radio_skonto/screens/instructions_screen/instructions_screen.dart';
import 'package:radio_skonto/widgets/no_internet_widget.dart';
import 'package:radio_skonto/widgets/progress_indicator_widget.dart';
import 'package:infinity_page_view_astro/infinity_page_view_astro.dart'
    as infPage;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool internetIsAvailable = true;
  //bool appBarIsExpanded = true;
  late MainData mainData;
  bool firstStart = false;
  bool _internetOnFirstStart = false;
  bool _internetOffFirstStart = false;
  final double _appBarExpandParam = 50;
  final ics.InfiniteScrollController tabBarPageController =
      ics.InfiniteScrollController();
  final infPage.InfinityPageController mainCellPageController =
      infPage.InfinityPageController();
  late MainScreenProvider mainScreenProvider;

  @override
  void initState() {
    super.initState();

    final listener =
        InternetConnection().onStatusChange.listen((InternetStatus status) {
      switch (status) {
        case InternetStatus.connected:
          if (_internetOnFirstStart == true) {
            Provider.of<PlayerProvider>(context, listen: false)
                .setInternetIsAvailableItems(context);
            internetIsAvailable = true;
            setState(() {});
          } else {
            _internetOnFirstStart = true;
          }
          break;
        case InternetStatus.disconnected:
          if (_internetOffFirstStart == true) {
            Provider.of<PlayerProvider>(context, listen: false)
                .setNoInternetItems();
            internetIsAvailable = false;
            setState(() {});
          } else {
            _internetOffFirstStart = true;
          }
          break;
      }
    });

    mainScreenProvider =
        Provider.of<MainScreenProvider>(context, listen: false);
  }

  _openAppBar() {
    if (mainScreenProvider.appBarIsExpanded == false) {
      setState(() {
        mainScreenProvider.appBarIsExpanded = true;
      });
    }
  }

  _closeAppBar() {
    if (mainScreenProvider.appBarIsExpanded == true) {
      setState(() {
        mainScreenProvider.appBarIsExpanded = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBarHeight = MediaQuery.of(context).padding.top + kToolbarHeight;
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification.depth == 1) {
          if (scrollNotification is ScrollStartNotification) {
            if (scrollNotification.metrics.extentBefore > _appBarExpandParam) {
              _closeAppBar();
            } else {
              _openAppBar();
            }
          } else if (scrollNotification is ScrollUpdateNotification) {
            if (scrollNotification.metrics.extentBefore > _appBarExpandParam) {
              _closeAppBar();
            } else {
              _openAppBar();
            }
          } else if (scrollNotification is ScrollEndNotification) {
            if (scrollNotification.metrics.extentBefore > _appBarExpandParam) {
              _closeAppBar();
            } else {
              _openAppBar();
            }
          }
        }
        return true;
      },
      child: ChangeNotifierProvider.value(
          value: Provider.of<MainScreenProvider>(context),
          child: Consumer<MainScreenProvider>(
              builder: (context, mainScreenProvider, _) {
            if (Singleton.instance.needToPlayFirstRadioStationOnStartApp ==
                    true &&
                mainScreenProvider.mainScreenData.data.isNotEmpty) {
              Singleton.instance.needToPlayFirstRadioStationOnStartApp = false;
              Provider.of<PlayerProvider>(context, listen: false)
                  .playAllTypeMedia(
                      mainScreenProvider.mainScreenData.data, 0, '', '');
            }
            if (mainScreenProvider.mainScreenData.data.isNotEmpty) {
              mainData = mainScreenProvider.mainScreenData
                  .data[mainScreenProvider.currentSelectedPlaylistIndex];
              _showPopupBanner(context, mainScreenProvider.mainScreenData);
            }

            List<HomeScreenMainViewWidget> pageViewListWidgets = [];
            for (MainData mData in mainScreenProvider.mainScreenData.data) {
              pageViewListWidgets.add(HomeScreenMainViewWidget(
                  scrollController:
                      mainScreenProvider.scrollControllerHomeScreen,
                  mainData: mData,
                  mainScreenProvider: mainScreenProvider));
            }

            return mainScreenProvider.getMainScreenDataResponseState ==
                        ResponseState.stateLoading ||
                    mainScreenProvider.mainScreenData.data.isEmpty
                ? AppProgressIndicatorWidget(
                    responseState:
                        mainScreenProvider.getMainScreenDataResponseState,
                    onRefresh: () {
                      mainScreenProvider.getMainScreenData(false, context);
                    },
                  )
                : Stack(
                    children: [
                      CustomCarouselSlider(
                        key: const ValueKey<int>(8978665),
                        disableGesture: false,
                        carouselController: context
                            .read<PlayerProvider>()
                            .carouselSliderControllerMainCell,
                        options: CarouselOptions(
                            scrollPhysics: mainScreenProvider.appBarIsExpanded
                                ? null
                                : const NeverScrollableScrollPhysics(),
                            height: 50000,
                            viewportFraction: 1,
                            disableCenter: false,
                            initialPage: 0,
                            enlargeStrategy: CenterPageEnlargeStrategy.height,
                            onScrolled: (scrollDouble) {},
                            enlargeCenterPage: true,
                            onPageChanged: (index, reason) {
                              Future.delayed(Duration.zero, () {
                                print(reason);
                                if (mainScreenProvider.appBarIsExpanded ==
                                    true) {
                                  context
                                      .read<PlayerProvider>()
                                      .carouselSliderControllerAppBar
                                      .animateToPage(index,
                                          duration: const Duration(
                                              milliseconds: 500));
                                  context
                                      .read<PlayerProvider>()
                                      .playAllTypeMedia(
                                          mainScreenProvider
                                              .mainScreenData.data,
                                          index,
                                          '',
                                          '',
                                          manual: true);
                                }
                              });
                            }),
                        items: List.generate(
                            mainScreenProvider.mainScreenData.data.length,
                            ((index) {
                          return pageViewListWidgets[index];
                        })),
                      ),
                      mainScreenProvider.appBarIsExpanded
                          ? const SizedBox()
                          : Positioned(
                              top: 0,
                              child: Image.asset(
                                  mainData.name == 'RADIO SKONTO'
                                      ? backgroundSconto
                                      : mainData.name == 'SKONTO PLUS'
                                          ? backgroundScontoPlus
                                          : mainData.name == 'RADIO TEV'
                                              ? backgroundTev
                                              : mainData.name == 'LOUNGE FM'
                                                  ? backgroundLoungeFm
                                                  : mainData.name == 'TEV LV'
                                                      ? backgroundTevLv
                                                      : backgroundSconto,
                                  fit: BoxFit.fitWidth,
                                  width: MediaQuery.sizeOf(context).width,
                                  alignment: Alignment.topCenter,
                                  height: appBarHeight)),
                      SafeArea(
                          bottom: false,
                          child: Column(
                            children: [
                              AppBarMainScreenWidget(
                                data: mainScreenProvider
                                    .mainScreenData.data.first,
                                onRadioIconTap: (index) {
                                  if (index != null) {
                                    mainScreenProvider.setPlaylistOnHomePage(
                                        index, context);
                                  }
                                },
                                mainDataList:
                                    mainScreenProvider.mainScreenData.data,
                                appBarIsExpanded:
                                    mainScreenProvider.appBarIsExpanded,
                                onItemFocus: (index) {
                                  mainScreenProvider.setPlaylistOnHomePage(
                                      index, context);
                                },
                                currentSelectedDataIndex: mainScreenProvider
                                    .currentSelectedPlaylistIndex,
                                controller: tabBarPageController,
                                carouselSliderController: context
                                    .read<PlayerProvider>()
                                    .carouselSliderControllerAppBar,
                              ),
                              Expanded(
                                  child: Stack(
                                children: [
                                  AnimatedSwitcher(
                                    duration:
                                        const Duration(milliseconds: 1000),
                                    child: internetIsAvailable
                                        ? const SizedBox.shrink()
                                        : const NoInternetWidget(),
                                  ),
                                ],
                              ))
                            ],
                          ))
                    ],
                  );
          })),
    );
  }

  void _showPopupBanner(BuildContext cont, MainScreenData mainScreenData) {
    bool needToShowByTime = true;
    if (mainScreenData.banners.isNotEmpty) {
      final lastBannerShowTimeString =
          Singleton.instance.getTimeWhenBannerIsShowFromSharedPreferences();
      if (lastBannerShowTimeString != '') {
        DateTime lastBannerShowTime = DateTime.parse(lastBannerShowTimeString);
        DateTime nowDay = DateTime.now();
        if (lastBannerShowTime.day == nowDay.day &&
            lastBannerShowTime.month == nowDay.month) {
          needToShowByTime = false;
        }
      }
      bool needShowBanner = false;
      late AdBanner bannerToShow;
      for (var banner in mainScreenData.banners) {
        if (banner.type == 'banner_popup_mobile') {
          needShowBanner = true;
          bannerToShow = banner;
          break;
        }
      }
      if (needShowBanner == true && needToShowByTime == true) {
        Singleton.instance
            .writePopupBannerIdToSharedPreferences(bannerToShow.id.toString());
        Singleton.instance.writeTimeWhenBannerIsShowToSharedPreferences();
        Future.delayed(const Duration(seconds: 7), () {
          showDialog(
              context: cont,
              builder: (BuildContext context) {
                return PopupBannerWidget(banner: bannerToShow);
              });
        });
      }
    }
  }
}
