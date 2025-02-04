import 'package:flutter/material.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';

class CustomCheckBoxWidget extends StatelessWidget {
  const CustomCheckBoxWidget({required this.text, required this.value, required this.selectedValue, super.key,});

  final Function(bool selectedValue) selectedValue;
  final bool value;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        selectedValue(value);
      },
      child: Row(
        children: [
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: value ? AppColors.red : AppColors.gray,
              ), // active or not
              CircleAvatar(
                radius: value ? 5 : 12,
                backgroundColor: Colors.white,
              ), // active circle space
            ],
          ),
          const SizedBox(width: 15),
          Text(text, style: AppTextStyles.main16regular)
        ],
      )
    );
  }
}