import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/helpers/constant.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/models/main_screen_data.dart';
import 'package:radio_skonto/models/podcasts_model.dart';
import 'package:radio_skonto/widgets/app_cached_network_image.dart';

class VideoPodcastsCellWidget extends StatelessWidget {
  const VideoPodcastsCellWidget({super.key, required this.videoPodcast, required this.onItemTap, required this.index});

  final Podcast videoPodcast;
  final Function(int index) onItemTap;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onItemTap(index);
      },
      child: Padding(padding: EdgeInsets.only(left: index == 0 ? 24 : 5, top: 5, bottom: 5, right: 5),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(-2, 15), // changes position of shadow
                    ),
                  ],
                ),
                child: AppCachedNetworkImage(
                  Singleton.instance.checkIsFoolUrl(videoPodcast.image),
                  width: double.infinity,
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
                        Text(videoPodcast.title, style: AppTextStyles.main12bold, maxLines: 2, overflow: TextOverflow.ellipsis),
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