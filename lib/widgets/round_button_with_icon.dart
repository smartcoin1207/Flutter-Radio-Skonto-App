import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class RoutedButtonWithIconWidget extends StatelessWidget {
  const RoutedButtonWithIconWidget({required this.iconName, required this.iconColor, required this.iconSize, required this.size, required this.onTap, required this.color, super.key});

  final String iconName;
  final Color iconColor;
  final double iconSize;
  final Function() onTap;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: size,
        width: size,
        child: ElevatedButton(
          style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.all(5)),
              shadowColor: MaterialStateProperty.all(Colors.transparent),
              backgroundColor: MaterialStateProperty.all(color),
              foregroundColor: MaterialStateProperty.all(Colors.transparent),
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              surfaceTintColor: MaterialStateProperty.all(Colors.transparent),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(size/2),
                  )
              )
          ),
          onPressed: () {
            onTap();
          },
          child: SvgPicture.asset(iconName,
              colorFilter:
              ColorFilter.mode(iconColor, BlendMode.srcIn),
              width: iconSize,
              height: iconSize),
        )
    );
  }
}