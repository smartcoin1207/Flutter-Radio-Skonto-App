import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:radio_skonto/helpers/app_colors.dart';

class LikeWidgetSmall extends StatelessWidget {
  const LikeWidgetSmall({required this.onTap, super.key});

  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    const size = 32.0;
    return SizedBox(
        height: size,
        width: size,
        child: ElevatedButton(
          style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.all(5)),
              backgroundColor: MaterialStateProperty.all(AppColors.white.withAlpha(192)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(size/2)
                  )
              )
          ),
          onPressed: () {
            onTap();
          },
          child: Padding(padding: const EdgeInsets.only(top: 3),
            child: SvgPicture.asset('assets/icons/heart_for_button_icon.svg',
                colorFilter: const ColorFilter.mode(AppColors.darkBlack, BlendMode.srcIn),
                width: 15.0,
                height: 15.0),
          ),
        )
    );
  }
}