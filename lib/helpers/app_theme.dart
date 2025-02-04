import 'package:flutter/material.dart';
import 'package:radio_skonto/helpers/app_colors.dart';

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  unselectedWidgetColor: AppColors.gray,
  colorScheme: ColorScheme.fromSeed(
    primary: AppColors.red,
    seedColor: AppColors.black,
    brightness: Brightness.light,
  ),
  textTheme: const TextTheme(
  ),
  checkboxTheme: CheckboxThemeData(
    side: BorderSide(width: 1, color: AppColors.black.withAlpha(85)),
  ),
  appBarTheme: const AppBarTheme(
      color: AppColors.darkBlack,
      iconTheme: IconThemeData(
          color: AppColors.white
      )
  ),
  primaryColor: AppColors.red, // outdated and has no effect to Tabbar
);