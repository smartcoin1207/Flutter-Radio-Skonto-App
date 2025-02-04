import 'package:flutter/material.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';

class ButtonReadMoreInWhiteFrameWidget extends StatelessWidget {
  const ButtonReadMoreInWhiteFrameWidget({required this.title, required this.onTap, super.key, this.buttonColor, this.textColor});

  final String title;
  final Function() onTap;
  final Color? buttonColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 42,
        child: ElevatedButton(
          style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.only(left: 15, right: 15)),
              backgroundColor: MaterialStateProperty.all(buttonColor == null ? Colors.transparent : buttonColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22.0),
                      side: const BorderSide(color: AppColors.white)
                  )
              )
          ),
          onPressed: () {
            onTap();
          },
          child: Text(title, style: textColor == null ? AppTextStyles.main16regular.copyWith(color: AppColors.white) : AppTextStyles.main16regular.copyWith(color: textColor)),
        )
    );
  }
}