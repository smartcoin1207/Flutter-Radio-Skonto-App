import 'package:flutter/material.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/screens/alarm_clock/day_of_week_model.dart';

class DayOfWeekWidget extends StatelessWidget {
  const DayOfWeekWidget({required this.dayOfWeek, super.key,});

  final DayOfWeek dayOfWeek;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 45,
        height: 45,
        //padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: dayOfWeek.isActive ? AppColors.black.withAlpha(64) : AppColors.white
        ),
        child: Center(
          child: Text(dayOfWeek.dayText, style: AppTextStyles.main18regular),
        ),
      ),
    );
  }
}