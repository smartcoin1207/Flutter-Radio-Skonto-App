import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:radio_skonto/core/extensions.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/models/main_screen_data.dart';
import 'package:radio_skonto/screens/home_screen/cells/playlist_cell.dart';
import 'package:radio_skonto/screens/playlists_screen/cell_horizontal_grid_playlists.dart';
import 'package:radio_skonto/screens/playlists_screen/cell_vertical_grid_playlist.dart';

class PlaylistVerticalGridWidget extends StatelessWidget {
  const PlaylistVerticalGridWidget({super.key, required this.onItemTap, required this.mainDataList, required this.title});

  final List<MainData> mainDataList;
  final Function(int index) onItemTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    const double lrPadding = 24.0;
    const double betweenCellPadding = 12.0;
    double cellSize = (MediaQuery.of(context).size.width - lrPadding* 2 - betweenCellPadding) / 2;
    const double textSectionHeight = 128.0;

    return mainDataList.isEmpty ?
    const SizedBox() :
    Container(
        color: AppColors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: const EdgeInsets.only(left: lrPadding, right: lrPadding),
              child: Text(title, maxLines: 2, style: AppTextStyles.main16bold),
            ),
            16.hs,
            GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: mainDataList.length,
                itemBuilder: (context, index) {
                  return CellVerticalGridPlaylistWidget(
                      mainData: mainDataList[index],
                      onItemTap: onItemTap,
                      index: index,
                      size: cellSize,
                      textSectionHeight: textSectionHeight,);
                },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: textSectionHeight/cellSize + 0.1
              ),
            ),
            const SizedBox(height: 100,)
          ],
        )
    );
  }
}