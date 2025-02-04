import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_skonto/core/extensions.dart';
import 'package:radio_skonto/helpers/api_helper.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/main.dart';
import 'package:radio_skonto/models/podcasts_model.dart';
import 'package:radio_skonto/providers/player_provider.dart';
import 'package:radio_skonto/providers/podcasts_provider.dart';
import 'package:radio_skonto/screens/home_screen/ad/one_image_banner_widget.dart';
import 'package:radio_skonto/screens/podcasts_screen/podcasts_detail.dart';
import 'package:radio_skonto/screens/podcasts_screen/small_cell.dart';
import 'package:radio_skonto/widgets/progress_indicator_widget.dart';
import 'package:radio_skonto/widgets/round_button_with_icon.dart';

class PodcastsWidget extends StatelessWidget {
  const PodcastsWidget({super.key, required this.type,});

  final PodcastType type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawerEnableOpenDragGesture: false,
      body: ChangeNotifierProvider.value(
        value: Provider.of<PodcastsProvider>(context),
          child: Consumer<PodcastsProvider>(builder: (context, podcastsProvider, _) {
            ResponseState loadingState = ResponseState.stateFirsLoad;
            late Podcasts currentPodcasts;
            if (type == PodcastType.audio) {
              loadingState = podcastsProvider.getAudioPodcastsResponseState;
              currentPodcasts = podcastsProvider.audioPodcasts;
            }
            if (type == PodcastType.video) {
              loadingState = podcastsProvider.getVideoPodcastsResponseState;
              currentPodcasts = podcastsProvider.videoPodcasts;
            }

            return loadingState == ResponseState.stateLoading ?
            AppProgressIndicatorWidget(
              responseState: loadingState,
              onRefresh: () {
                if (type == PodcastType.audio) {
                  podcastsProvider.getAudioPodcasts(context, false);
                }
                if (type == PodcastType.video) {
                  podcastsProvider.getVideoPodcasts(context, false);
                }
                if (type == PodcastType.interview) {
                  podcastsProvider.getInterviewPodcasts(context, false);
                }
              },
            ) :
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                //mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RoutedButtonWithIconWidget(iconName: 'assets/icons/filters_icon.svg',
                    iconColor: AppColors.darkBlack,
                    size: 50,
                    onTap: () {
                      Singleton.instance.isMainMenu = false;
                      scaffoldKey.currentState?.openEndDrawer();
                    },
                    color: AppColors.gray, iconSize: 20,),
                  const SizedBox(height: 5),
                  Expanded(child: Padding(
                    padding: const EdgeInsets.only(bottom: 70),
                    child: ListView.builder(
                      itemCount: currentPodcasts.data.length,
                      shrinkWrap: true,
                      itemBuilder: (context, headerIndex) {
                        List<Podcast> firstSection = [];
                        List<Podcast> secondSection = [];
                        if (currentPodcasts.data[headerIndex].podcasts != null && currentPodcasts.data[headerIndex].podcasts!.isNotEmpty) {
                          if (headerIndex == 1) {
                            for (var i = 0; i < currentPodcasts.data[headerIndex].podcasts!.length; i++) {
                              if (i < 4) {
                                firstSection.add(currentPodcasts.data[headerIndex].podcasts![i]);
                              } else {
                                secondSection.add(currentPodcasts.data[headerIndex].podcasts![i]);
                              }
                            }
                          } else {
                            firstSection.addAll(currentPodcasts.data[headerIndex].podcasts?? []);
                          }
                        }
                        return firstSection.isEmpty ?
                        currentPodcasts.data.length == headerIndex + 1 ? 190.hs : 0.hs :
                        Padding(padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(currentPodcasts.data[headerIndex].name, style: AppTextStyles.main16bold),
                              5.hs,
                              GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: firstSection.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisExtent: 160
                                ),
                                itemBuilder: (_, index) =>
                                    SmallGridCell(podcast: firstSection[index],
                                      onTap: (Podcast podcast) {
                                        context.read<PlayerProvider>().hideNavigationBar();
                                        Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => PodcastDetailScreen(podcast: podcast),
                                          fullscreenDialog: true
                                        ));
                                      },
                                      onFavoriteTap: (Podcast podcast) {
                                        podcastsProvider.onFavoriteTap(podcast);
                                      },),
                              ),
                              headerIndex == 0 ? Padding(padding: EdgeInsets.only(top: 20),
                                child: OneImageBannerWidget(banners: currentPodcasts.banners, padding: 0,)
                              ) : const SizedBox(),
                              secondSection.isEmpty ? const SizedBox() :
                              GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: secondSection.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisExtent: 160
                                ),
                                itemBuilder: (_, index) =>
                                    SmallGridCell(podcast: secondSection[index],
                                      onTap: (Podcast podcast) {
                                        context.read<PlayerProvider>().hideNavigationBar();
                                        Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => PodcastDetailScreen(podcast: podcast),
                                          fullscreenDialog: true
                                        ));
                                      },
                                      onFavoriteTap: (Podcast podcast) {
                                        podcastsProvider.onFavoriteTap(podcast);
                                      },),
                              )
                            ],
                          ),
                        );
                      },
                    )
                  )
                  )],
              ),
            );
          })
      ));
  }
}