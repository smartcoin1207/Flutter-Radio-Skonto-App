import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:radio_skonto/core/extensions.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/helpers/constant.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/models/main_screen_data.dart';
import 'package:radio_skonto/widgets/app_cached_network_image.dart';
import 'package:radio_skonto/widgets/like_widget.dart';

class CellVerticalGridPlaylistWidget extends StatelessWidget {
  const CellVerticalGridPlaylistWidget({super.key, required this.mainData, required this.onItemTap, required this.index, required this.size, required this.textSectionHeight});

  final MainData mainData;
  final Function(int index) onItemTap;
  final int index;
  final double size;
  final double textSectionHeight;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {onItemTap(index);},
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: size,
                height: size,
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
              Padding(padding: EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: double.infinity),
                    15.hs,
                    Text(mainData.name, style: AppTextStyles.main12bold, maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start,),
                    const SizedBox(height: 3),
                    Text(mainData.subtitle, style: AppTextStyles.main10regular, maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
              top: 15,
              right: 33,
              child: LikeWidget(
                color: AppColors.white.withAlpha(192),
                onTap: () {

                },)
          )
        ],
      ),
    );
  }
}