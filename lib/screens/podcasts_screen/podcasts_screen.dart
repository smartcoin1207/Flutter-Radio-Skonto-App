import 'dart:async';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/providers/podcasts_provider.dart';
import 'package:radio_skonto/providers/translations_provider.dart';
import 'package:radio_skonto/screens/podcasts_screen/audio_video/audio_video_podcasts_view.dart';
import 'package:radio_skonto/screens/podcasts_screen/interviews/interviews_view.dart';
import 'package:radio_skonto/widgets/custom_app_bar.dart';
import 'package:radio_skonto/widgets/no_internet_widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

GlobalKey<ContainedTabBarViewState> podcastsBarKey = GlobalKey();

class PodcastsScreen extends StatefulWidget {
  const PodcastsScreen({super.key});

  @override
  State<PodcastsScreen> createState() => _PodcastsScreenState();
}

class _PodcastsScreenState extends State<PodcastsScreen> {
  late StreamSubscription<List<ConnectivityResult>> subscription;
  bool internetIsAvailable = true;
  int currentAppBarIndex = 0;

  @override
  void initState() {
    subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.mobile) || result.contains(ConnectivityResult.wifi)) {
        internetIsAvailable = true;
      } else {
        internetIsAvailable = false;
      }
      setState(() {
      });
    });

    super.initState();
  }

  @override
  dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawerEnableOpenDragGesture: false,
      appBar: const CustomAppBar(),
      body: ChangeNotifierProvider.value(
          value: Provider.of<TranslationsProvider>(context),
          child: Consumer<TranslationsProvider>(builder: (context, translationsProvider, _) {
            return Column(
              children: [
                AnimatedSwitcher(
                  // transitionBuilder: (Widget child, Animation<double> animation) {
                  //   return ScaleTransition(scale: animation, child: child);
                  // },
                  duration: const Duration(milliseconds: 1000),
                  child: internetIsAvailable ? const SizedBox.shrink() : const NoInternetWidget(),
                ),
                Expanded(child: Padding(padding: const EdgeInsets.only(left: 20, right: 20,),
                  child: ContainedTabBarView(
                    key: podcastsBarKey,
                    tabBarProperties: const TabBarProperties(
                      indicatorColor: AppColors.red,
                      labelColor: AppColors.red,
                      //unselectedLabelColor: AppColors.red,
                    ),
                    tabs: [
                      SizedBox(
                          height: 50,
                          child: Center(child: Text(Singleton.instance.translate('audio_podcasts'),
                              style: currentAppBarIndex == 0 ? AppTextStyles.main14regular.copyWith(color: AppColors.red) : AppTextStyles.main14regular)
                          )),
                      SizedBox(
                          height: 50,
                          child: Center(child: Text(Singleton.instance.translate('podcast_video'),
                              style: currentAppBarIndex == 1 ? AppTextStyles.main14regular.copyWith(color: AppColors.red) : AppTextStyles.main14regular)
                          )),
                      SizedBox(
                          height: 50,
                          child: Center(child: Text(Singleton.instance.translate('interviews'),
                              style: currentAppBarIndex == 2 ? AppTextStyles.main14regular.copyWith(color: AppColors.red) : AppTextStyles.main14regular)
                          )),
                    ],
                    views: const [
                      PodcastsWidget(type: PodcastType.audio),
                      PodcastsWidget(type: PodcastType.video),
                      InterviewsWidget(),
                    ],
                    onChange: (index) {
                      setState(() {
                        currentAppBarIndex = index;
                        Provider.of<PodcastsProvider>(context, listen: false).currentAppBarIndex = index;
                      });
                    },
                  ),
                ))
              ],
            );
          })
      ),
    );
  }
}
