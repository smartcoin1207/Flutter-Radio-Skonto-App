import 'package:flutter/material.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/widgets/progress_indicator_widget.dart';

class RoutedButtonWidget extends StatelessWidget {
  const RoutedButtonWidget({this.isLoading, required this.title, required this.onTap, super.key, this.buttonColor, this.textColor, this.timerCount, this.borderColor,});

  final String title;
  final Function() onTap;
  final bool? isLoading;
  final Color? buttonColor;
  final Color? borderColor;
  final Color? textColor;
  final int? timerCount;

  @override
  Widget build(BuildContext context) {
    String timerCountString = timerCount == null || timerCount == 0 ? '' : ' ${timerCount.toString()}';
    return Center(
      child: SizedBox(
          height: 42,
          width: double.infinity,
          child: ElevatedButton(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(5)),
                  surfaceTintColor: MaterialStateProperty.all(buttonColor ?? AppColors.white),
                  backgroundColor: MaterialStateProperty.all(buttonColor ?? AppColors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.0),
                          side: BorderSide(color: borderColor == null ? AppColors.darkBlack : borderColor!)
                      )
                  )
              ),
              onPressed: () {
                if (timerCount == null || timerCount == 0) {
                  onTap();
                }
              },
              child: isLoading == null || isLoading == false ?
              Text('$title$timerCountString', style: textColor == null ? AppTextStyles.main16regular : AppTextStyles.main16regular.copyWith(color: textColor)) :
              const SizedBox(width: 22, height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: AppColors.red,
                ),
              )
          )
      )
    );
  }
}