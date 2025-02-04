import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_skonto/helpers/api_helper.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/main.dart';
import 'package:radio_skonto/models/interview_model.dart';
import 'package:radio_skonto/providers/detail_provider.dart';
import 'package:radio_skonto/providers/podcasts_provider.dart';
import 'package:radio_skonto/screens/home_screen/ad/one_image_banner_widget.dart';
import 'package:radio_skonto/screens/podcasts_screen/interviews/interview_grid_cell.dart';
import 'package:radio_skonto/widgets/progress_indicator_widget.dart';
import 'package:radio_skonto/widgets/round_button_with_icon.dart';

class InterviewsWidget extends StatelessWidget {
  const InterviewsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: Provider.of<PodcastsProvider>(context),
        child: Consumer<PodcastsProvider>(builder: (context, podcastsProvider, _) {
          List<InterviewData> firstSection = [];
          List<InterviewData> secondSection = [];
          if (podcastsProvider.interviewPodcasts.data.isNotEmpty) {
            for (var i = 0; i < podcastsProvider.interviewPodcasts.data.length; i++) {
              if (i < 4) {
                firstSection.add(podcastsProvider.interviewPodcasts.data[i]);
              } else {
                secondSection.add(podcastsProvider.interviewPodcasts.data[i]);
              }
            }
          }
          return podcastsProvider.getInterviewPodcastsResponseState == ResponseState.stateLoading ?
          AppProgressIndicatorWidget(
            responseState: podcastsProvider.getInterviewPodcastsResponseState,
            onRefresh: () {
              podcastsProvider.getInterviewPodcasts(context, false);
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
                    padding: const EdgeInsets.only(bottom: 75),
                    child: SingleChildScrollView(
                        child: podcastsProvider.interviewPodcasts.data.isEmpty ?
                        const SizedBox() :
                        Column(
                          children: [
                            GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: firstSection.length,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisExtent: 160
                              ),
                              itemBuilder: (_, index) =>
                              firstSection.isEmpty ?
                              const SizedBox() :
                              InterviewGridCell(interview: firstSection[index],
                                onTap: (InterviewData interview) {
                                  context.read<DetailProvider>().openMediaDetail(interview, context);
                                },),
                            ),
                            OneImageBannerWidget(banners: podcastsProvider.interviewPodcasts.banners, padding: 0,),
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
                              secondSection.isEmpty ?
                              const SizedBox() :
                              InterviewGridCell(interview: secondSection[index],
                                onTap: (InterviewData interview) {
                                  context.read<DetailProvider>().openMediaDetail(interview, context);
                                },),
                            ),
                          ],
                        )
                    )
                )
                )
              ],
            ),
          );
        })
    );
  }
}