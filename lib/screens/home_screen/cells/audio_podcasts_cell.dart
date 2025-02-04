import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/helpers/constant.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/models/podcasts_model.dart';
import 'package:radio_skonto/widgets/app_cached_network_image.dart';

class AudioPodcastsCellWidget extends StatelessWidget {
  const AudioPodcastsCellWidget({super.key, required this.audioPodcast, required this.onItemTap, required this.index});

  final Podcast audioPodcast;
  final Function(int index) onItemTap;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {onItemTap(index);},
      child: Padding(padding: EdgeInsets.only(left: index == 0 ? 24 : 5, top: 5, bottom: 5, right: 5),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                width: 128,
                height: 138,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    App.appBoxShadow
                  ],
                ),
                child: AppCachedNetworkImage(
                  Singleton.instance.checkIsFoolUrl(audioPodcast.image),
                  width: double.infinity,
                  boxFit: BoxFit.fill,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              Expanded(
                  child: SizedBox(
                    width: 128,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(audioPodcast.title, style: AppTextStyles.main12bold, maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 3),
                        Text('6 ${Singleton.instance.translate('episodes_title')}', style: AppTextStyles.main10regular, maxLines: 2, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  )
              ),
            ],
          )
      ),
    );
  }
}