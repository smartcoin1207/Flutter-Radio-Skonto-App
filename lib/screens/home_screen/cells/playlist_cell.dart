import 'package:flutter/material.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/constant.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/models/main_screen_data.dart';
import 'package:radio_skonto/widgets/app_cached_network_image.dart';

class PlaylistCellWidget extends StatelessWidget {
  const PlaylistCellWidget({super.key, required this.playlist, required this.onItemTap, required this.index});

  final MainData playlist;
  final Function(int index) onItemTap;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onItemTap(index);
      },
      child: Padding(padding: EdgeInsets.only(left: index == 0 ? 24 : 5, top: 5, bottom: 20, right: 5),
          child: Container(
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
              Singleton.instance.checkIsFoolUrl(playlist.cardImage),
              boxFit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          )
      ),
    );
  }
}