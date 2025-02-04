import 'package:flutter/material.dart';
import 'package:radio_skonto/helpers/app_colors.dart';

class AppCircleButton extends StatelessWidget {
  final IconData? iconData;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;
  final GestureTapCallback? onTap;

  const AppCircleButton({
    super.key,
    this.iconData,
    this.size = 42.0,
    this.backgroundColor = AppColors.green,
    this.iconColor = AppColors.white,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration:
        BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
        child: Icon(iconData, size: 24, color: iconColor),
      ),
    );
  }
}
