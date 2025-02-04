import 'package:flutter/material.dart';
import 'package:radio_skonto/helpers/app_colors.dart';

class AppErrorBar extends StatelessWidget {
  static const height = 40.0;
  static const margin = 4.0;

  const AppErrorBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: margin),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: AppColors.white),
      child: const Row(
        children: [
          Icon(Icons.error_outline, color: Colors.black, size: 16),
          SizedBox(width: 16),
          Text(
            'Nav interneta savienojuma!',
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'Lato',
                fontSize: 12,
                fontWeight: FontWeight.w700),
          )
        ],
      ),
    );
  }
}
