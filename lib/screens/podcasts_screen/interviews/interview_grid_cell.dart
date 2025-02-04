import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/helpers/constant.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/models/interview_model.dart';
import 'package:radio_skonto/widgets/errorImageWidget.dart';
import 'package:radio_skonto/widgets/like_widget.dart';
import 'package:radio_skonto/widgets/placeholderImageWidget.dart';

class InterviewGridCell extends StatelessWidget {
  const InterviewGridCell({super.key, required this.interview, required this.onTap,});

  final InterviewData interview;
  final Function(InterviewData interview) onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(interview);
      },
      child: GridTile(
          child: SizedBox(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: CachedNetworkImage(
                          height: 96,
                          width: 400,
                          fit: BoxFit.cover,
                          imageUrl: Singleton.instance.checkIsFoolUrl(interview.image),
                          placeholder: (context, url) => const PlaceholderImageWidget(),
                          errorWidget: (context, url, error) => const ErrorImageWidget(),
                        ),
                        //Image.network('https://farm4.staticflickr.com/3224/3081748027_0ee3d59fea_z_d.jpg', fit: BoxFit.cover),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: Text(interview.title, style: AppTextStyles.main12bold, maxLines: 2, overflow: TextOverflow.ellipsis)),
                          // SizedBox( width: 50,
                          //   child: Text('${interview.contentData.cards.length} items', style: AppTextStyles.main12regular),
                          // ),
                        ],),
                      const SizedBox(height: 3),
                      //Text(Singleton.instance.translate('residence_title'), style: AppTextStyles.main10regular),
                    ],
                  ),
                ),
                Positioned(
                    top: 25,
                    right: 25,
                    child: LikeWidget(
                      color: AppColors.white.withAlpha(192),
                      onTap: () {

                      },)
                )
              ],
            ),
          )
      ),
    );
  }
}