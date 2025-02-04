import 'package:flutter/material.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';

class TextWithFirstRedDotWidget extends StatelessWidget {
  const TextWithFirstRedDotWidget({required this.text, super.key,});

  final String text;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: AppTextStyles.main18regular,
        children: <TextSpan>[
          TextSpan(text: '* ', style: AppTextStyles.main16bold.copyWith(color: AppColors.red)),
          TextSpan(text: text),
        ],
      ),
    );
  }
}