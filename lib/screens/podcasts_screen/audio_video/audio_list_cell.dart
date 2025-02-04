import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/helpers/constant.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/models/podcasts_model.dart';
import 'package:radio_skonto/providers/download_provider.dart';
import 'package:radio_skonto/widgets/download_routed_button.dart';
import 'package:radio_skonto/widgets/errorImageWidget.dart';
import 'package:radio_skonto/widgets/placeholderImageWidget.dart';
import 'package:radio_skonto/widgets/round_button_with_icon.dart';
import 'package:intl/intl.dart';

class AudioListCell extends StatelessWidget {
  const AudioListCell({super.key, required this.episode, required this.onTap,});

  final Episode episode;
  final Function(Episode episode) onTap;

  String _formattedTime(int timeInSecond) {
    if (timeInSecond == 0) {
      return '';
    }
    final int hour = (timeInSecond / 3600).floor();
    final int minute = ((timeInSecond / 3600 - hour) * 60).floor();
    final int second = ((((timeInSecond / 3600 - hour) * 60) - minute) * 60).floor();

    String h = hour > 0 ? '$hour h ' : '';
    String m = minute > 0 ? '$minute min ' : '';
    String s = second > 0 ? '$second sec' : '';
    return h + m + s;
  }

  @override
  Widget build(BuildContext context) {
    bool isVideo = false;
    if (episode.contentData.cards.first.type.toLowerCase().contains('video')) {
      isVideo = true;
    }
    String date = '';
    String duration = _formattedTime(episode.contentData.cards.first.audioDuration);
    double size = 70;
    bool isYouTube = false;
    if (episode.contentData.cards.first.image.toLowerCase().contains('youtube')) {
      isYouTube = true;
    }
    if (episode.created != null) {
      date = '${DateFormat("dd.MM.yyyy").format(episode.created!.date)}  ';
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onTap(episode);
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: SizedBox(
            height: size,
            child: Row(
              children: [
                SizedBox(width: size, height: size,
                  child: Stack(children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: CachedNetworkImage(
                          fit: isYouTube ? BoxFit.fitWidth : BoxFit.cover,
                          height: size,
                          imageUrl: Singleton.instance.checkIsFoolUrl(episode.contentData.cards.first.image),
                          placeholder: (context, url) => PlaceholderImageWidget(size: size),
                          errorWidget: (context, url, error) => ErrorImageWidget(height: size, width: size,),
                        )
                    ),
                    isVideo ? const SizedBox() : const Center(child: Icon(Icons.play_arrow, color: Colors.white, size: 45,)),
                  ],)
                ),
                Expanded(child: Padding(
                  padding: EdgeInsets.only(left: 15, right: 10, top: isYouTube ? 15 : 5, bottom: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(episode.title, style: AppTextStyles.main12bold, maxLines: 2, overflow: TextOverflow.ellipsis,),
                      Row(
                        children: [
                          Text(date, style: AppTextStyles.main10regular),
                          Text(duration, style: AppTextStyles.main10regular, maxLines: 1,),
                        ],
                      )
                    ],
                  ),
                )
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: 32, width: 32,),
                    // RoutedButtonWithIconWidget(iconName: 'assets/icons/heart_for_button_icon.svg',
                    //   iconColor: AppColors.darkBlack,
                    //   size: 32,
                    //   onTap: () {
                    //
                    //   },
                    //   color: AppColors.gray, iconSize: 15,
                    // ),
                    episode.contentData.cards.isEmpty ||  episode.contentData.cards.first.allowDownloading == false ?
                    const SizedBox() :
                    DownloadRoutedButtonWidget(task: TaskInfo(name: episode.contentData.cards.first.audioFile, link: apiBaseUrl +  episode.contentData.cards.first.audioFile))
                  ],
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}