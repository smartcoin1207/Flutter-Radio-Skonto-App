import 'package:flutter/material.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class PlaceholderImageWidget extends StatelessWidget {
  const PlaceholderImageWidget({
    super.key,
    this.size,
  });

  final double? size;

  @override
  Widget build(BuildContext context) {
    double s = size == null || size! > 100 ? 100 : size!;
    return Center(
        child: SizedBox(
          width: s,
          height: s,
          child: Shimmer.fromColors(
            baseColor: AppColors.gray,
            highlightColor: AppColors.white,
            child: Icon(Icons.image_outlined, size: s,),
          ),
        )
    );
  }
}
