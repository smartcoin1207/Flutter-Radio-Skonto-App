import 'package:flutter/material.dart';
import 'package:radio_skonto/core/extensions.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/helpers/constant.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/models/search_model.dart';
import 'package:radio_skonto/widgets/app_cached_network_image.dart';

class SearchItemWidget extends StatelessWidget {
  final SearchItem item;
  final Function(int index, String type, SearchItem item) onItemTap;

  const SearchItemWidget({super.key, required this.item, required this.onItemTap});

  @override
  Widget build(BuildContext context) {
    const size = 64.0;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onItemTap(item.id, item.entityType, item);
      },
      child: SizedBox(
        height: size,
        child: Row(
          children: [
            AppCachedNetworkImage(
              Singleton.instance.checkIsFoolUrl(item.image),
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            16.ws,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title,
                      style: AppTextStyles.main12bold,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  4.hs,
                  Expanded(
                    child: Text(item.title,
                        style: AppTextStyles.main10regular,
                        overflow: TextOverflow.ellipsis),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
