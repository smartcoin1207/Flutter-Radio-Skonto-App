import 'package:flutter/material.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/models/main_screen_data.dart';
import 'package:radio_skonto/screens/home_screen/cells/playlist_cell.dart';
import 'package:radio_skonto/screens/playlists_screen/cell_horizontal_grid_playlists.dart';

class PlaylistHorizontalGridWidget extends StatelessWidget {
  const PlaylistHorizontalGridWidget({super.key, required this.onItemTap, required this.mainDataList, required this.title});

  final List<MainData> mainDataList;
  final Function(int index) onItemTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    ScrollController controller = ScrollController();
    //double height = 295.0;

    return mainDataList.isEmpty ?
    const SizedBox() :
    Container(
        //height: height,
        color: AppColors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: const EdgeInsets.only(left: 24, right: 24),
              child: Text(title, maxLines: 2, style: AppTextStyles.main16bold),
            ),
            RawScrollbar(
                controller: controller,
                padding: const EdgeInsets.only(left: 24, right: 24),
                trackVisibility: true,
                thumbVisibility: true,
                trackColor: AppColors.gray,
                thumbColor: AppColors.black,
                trackRadius: const Radius.circular(5),
                radius: const Radius.circular(5),
                thickness: 5,
                child: SizedBox(
                  height: 200,
                  child: ListView.builder(
                      controller: controller,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: mainDataList.length,
                      itemBuilder: (context, index) {
                        return CellHorizontalGridPlaylistWidget(
                            mainData: mainDataList[index],
                            onItemTap: onItemTap,
                            index: index
                        );
                      }
                  ),
                )
            ),
            const SizedBox(height: 10,)
          ],
        )
    );
  }
}