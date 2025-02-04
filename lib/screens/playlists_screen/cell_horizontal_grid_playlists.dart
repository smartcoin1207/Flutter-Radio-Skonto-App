import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/helpers/constant.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/models/main_screen_data.dart';
import 'package:radio_skonto/models/podcasts_model.dart';
import 'package:radio_skonto/widgets/app_cached_network_image.dart';
import 'package:radio_skonto/widgets/like_widget.dart';

class CellHorizontalGridPlaylistWidget extends StatelessWidget {
  const CellHorizontalGridPlaylistWidget({super.key, required this.mainData, required this.onItemTap, required this.index});

  final MainData mainData;
  final Function(int index) onItemTap;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {onItemTap(index);},
      child: Padding(padding: EdgeInsets.only(left: index == 0 ? 24 : 5, top: 5, bottom: 5, right: 5),
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 15, top: 10),
                    width: 128,
                    height: 128,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        App.appBoxShadow
                      ],
                    ),
                    child: AppCachedNetworkImage(
                      Singleton.instance.checkIsFoolUrl(mainData.cardImage),
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 128,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(mainData.name, style: AppTextStyles.main12bold, maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 3),
                        //Text(mainData.subtitle, style: AppTextStyles.main10regular, maxLines: 2, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                  top: 18,
                  right: 10,
                  child: LikeWidget(
                    color: AppColors.white.withAlpha(192),
                    onTap: () {

                    },)
              )
            ],
          ),
      ),
    );
  }
}