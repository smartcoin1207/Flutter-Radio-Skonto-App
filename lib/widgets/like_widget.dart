import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:radio_skonto/helpers/app_colors.dart';

class LikeWidget extends StatelessWidget {
  const LikeWidget({required this.onTap, super.key, required this.color});

  final Function() onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    const size = 50.0;
    // временно откдючаем
    return const SizedBox();
    //   SizedBox(
    //     height: size,
    //     width: size,
    //     child: ElevatedButton(
    //       style: ButtonStyle(
    //           padding: MaterialStateProperty.all<EdgeInsets>(
    //               const EdgeInsets.all(5)),
    //           backgroundColor: MaterialStateProperty.all(color),
    //           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    //               RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.circular(size/2)
    //               )
    //           )
    //       ),
    //       onPressed: () {
    //         onTap();
    //       },
    //       child: Padding(padding: const EdgeInsets.only(top: 3),
    //         child: SvgPicture.asset('assets/icons/heart_for_button_icon.svg',
    //             colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
    //             width: 20.0,
    //             height: 20.0),
    //       ),
    //       )
    // );
  }
}