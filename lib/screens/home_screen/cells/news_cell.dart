import 'package:flutter/material.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/models/main_screen_data.dart';
import 'package:radio_skonto/widgets/app_cached_network_image.dart';

class NewsCellWidget extends StatelessWidget {
  const NewsCellWidget({super.key, required this.news, required this.type, required this.onItemTap, required this.index,});

  final News news;
  final int type;
  final Function(int index) onItemTap;
  final int index;

  @override
  Widget build(BuildContext context) {
    double width = 128;
    return GestureDetector(
      onTap: () {
        onItemTap(index);
      },
      child: Padding(padding: EdgeInsets.only(left: index == 0 ? 24 : 5, top: 5, bottom: 5, right: 5),
          child: Container(
            margin: const EdgeInsets.only(bottom: 30),
            width: width,
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
            child: type == 1 ?
            Column(
              children: [
                Expanded(child: Container()),
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0),
                    ),
                  ),
                  width: double.infinity,
                  height: 97,
                )
              ],
            ) : type == 2 ?
            Stack(
              children: [
                AppCachedNetworkImage(
                  news.card2 == null ? '' : Singleton.instance.checkIsFoolUrl(news.card2!.cards.first.background),
                  width: double.infinity,
                  height: double.infinity,
                  boxFit: BoxFit.fitHeight,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                Positioned(
                    bottom: 50,
                    child: Container(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        //height: 60,
                        width: width,
                        child: Text(
                            news.title,
                            textAlign: TextAlign.center,
                            //maxLines: 4,
                            style: AppTextStyles.main14bold.copyWith(color: AppColors.white, fontWeight: FontWeight.w700)
                        ))
                )
              ],
            ) :
            Container(),
          )
      ),
    );
  }
}