import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:radio_skonto/core/extensions.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';

class OptionsSwitch extends StatelessWidget {
  const OptionsSwitch({
    super.key,
    required this.title,
    required this.value,
    required this.onToggle,
  });

  final bool value;
  final Function(bool val) onToggle;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(title, style: AppTextStyles.main16regular)),
        5.ws,
        FlutterSwitch(
          height: 24,
          width: 45,
          padding: 1.5,
          toggleSize: 18,
          value: value,
          onToggle: onToggle,
          activeColor: AppColors.red,
          inactiveColor: Colors.transparent,
          activeSwitchBorder: Border.all(
            color: AppColors.red,
          ),
          activeToggleColor: AppColors.white,
          inactiveSwitchBorder: Border.all(
            color: AppColors.black,
          ),
          inactiveToggleColor: AppColors.black,
        ),
      ],
    );
  }
}