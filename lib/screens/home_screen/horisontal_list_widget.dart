import 'package:flutter/material.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/models/main_screen_data.dart';
import 'package:radio_skonto/providers/main_screen_provider.dart';
import 'package:radio_skonto/screens/home_screen/cells/audio_podcasts_cell.dart';
import 'package:radio_skonto/screens/home_screen/cells/interview_cell.dart';
import 'package:radio_skonto/screens/home_screen/cells/news_cell.dart';
import 'package:radio_skonto/screens/home_screen/cells/playlist_cell.dart';
import 'package:radio_skonto/screens/home_screen/cells/video_cell.dart';

class HorizontalListWidget extends StatelessWidget {
  const HorizontalListWidget({super.key, required this.type, required this.mainData, required this.onItemTap, required this.onSeeMoreTap});

  final MainScreenCellType type;
  final MainData mainData;
  final Function(int index) onItemTap;
  final Function() onSeeMoreTap;

  @override
  Widget build(BuildContext context) {
    ScrollController controller = ScrollController();
    double height = 410.0;
    bool hasData = false;
    String title = '';
    int itemCount = 0;
    if (type == MainScreenCellType.news) {
      if (mainData.news != null && mainData.news!.isNotEmpty) {
        hasData = true;
        title = Singleton.instance.translate('related_news_title');
        itemCount = mainData.news!.length;
      }
    }
    if (type == MainScreenCellType.playlist) {
      if (mainData.playlists != null && mainData.playlists!.isNotEmpty) {
        hasData = true;
        title = Singleton.instance.translate('related_playlists_title');
        itemCount = mainData.playlists!.length;
        height = 270;
      }
    }
    if (type == MainScreenCellType.audio) {
      if (mainData.audioPodcasts != null && mainData.audioPodcasts!.isNotEmpty) {
        hasData = true;
        title = Singleton.instance.translate('podcasts_and_shows_title_audio');
        itemCount = mainData.audioPodcasts!.length;
        height = 340;
      }
    }
    if (type == MainScreenCellType.video) {
      if (mainData.videoPodcasts != null && mainData.videoPodcasts!.isNotEmpty) {
        hasData = true;
        title = Singleton.instance.translate('podcasts_and_shows_title_video');
        itemCount = mainData.videoPodcasts!.length;
        height = 330;
      }
    }
    if (type == MainScreenCellType.interview) {
      if (mainData.interviews != null && mainData.interviews!.isNotEmpty) {
        hasData = true;
        title = Singleton.instance.translate('related_interviews_title');
        itemCount = mainData.interviews!.length;
        height = 350;
      }
    }

    return hasData == false ?
    const SizedBox() :
    Container(
        height: height - 24,
        color: AppColors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: const EdgeInsets.only(top: 11, left: 24, right: 24),
              child: Row(
                children: [
                  Expanded(child: Text(title, maxLines: 2, style: AppTextStyles.main16bold),),
                  TextButton(onPressed: () {
                    onSeeMoreTap();
                  },
                    child: Text(Singleton.instance.translate('see_more_title'), style: AppTextStyles.main14regular.copyWith(decoration: TextDecoration.underline, fontWeight: FontWeight.w400)),
                  )
                ],
              ),
            ),
            Expanded(
                child: RawScrollbar(
                    controller: controller,
                    padding: const EdgeInsets.only(left: 24, right: 24),
                    trackVisibility: true,
                    thumbVisibility: true,
                    trackColor: AppColors.gray,
                    thumbColor: AppColors.black,
                    trackRadius: const Radius.circular(5),
                    radius: const Radius.circular(5),
                    thickness: 5,
                    child:  ListView.builder(
                        controller: controller,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: itemCount,
                        itemBuilder: (context, index) {
                          if (type == MainScreenCellType.news) {
                            return NewsCellWidget(news: mainData.news![index], type: 2, onItemTap: (int index) {onItemTap(index);}, index: index,);
                          } else if (type == MainScreenCellType.playlist) {
                            return PlaylistCellWidget(playlist: mainData.playlists![index], onItemTap: (int index) {onItemTap(index);}, index: index,);
                          } else if (type == MainScreenCellType.audio) {
                            return AudioPodcastsCellWidget(audioPodcast: mainData.audioPodcasts![index], onItemTap: (int index) {onItemTap(index);}, index: index,);
                          } else if (type == MainScreenCellType.video) {
                            return VideoPodcastsCellWidget(videoPodcast: mainData.videoPodcasts![index], onItemTap: (int index) {onItemTap(index);}, index: index,);
                          } else if (type == MainScreenCellType.interview) {
                            return InterviewCellWidget(interview: mainData.interviews![index], onItemTap: (int index) {onItemTap(index);}, index: index,);
                          }
                          else {
                            return const Text('*');
                          }
                        }
                    )
                )
            ),
            const SizedBox(height: 10,)
          ],
        )
    );
  }
}