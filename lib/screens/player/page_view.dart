import 'package:flutter/material.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/constant.dart';
import 'package:radio_skonto/widgets/app_cached_network_image.dart';

class PlayerMainImage extends StatelessWidget {
  final String imageUrl;

  const PlayerMainImage({
    super.key,
    required this.imageUrl
  });

  @override
  Widget build(BuildContext context) {
    const height = 436.0;

    return SizedBox(
      width: double.infinity,
      height: height,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: AppCachedNetworkImage(imageUrl,
                width: double.infinity, height: height),
          ),
          IgnorePointer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: height/4,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment(0, -0.8),
                        end: Alignment.bottomCenter,
                        colors: AppColors.transparentGradient),
                  ),
                ),
                Container(
                  height: height/4,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment(0, 0.8),
                        end: Alignment.topCenter,
                        colors: AppColors.transparentGradient),
                  ),
                )
              ],
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: App.edgeInsets.copyWith(top: App.padding),
                child: Container(
                  width: 134,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.white.withAlpha(150),
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
