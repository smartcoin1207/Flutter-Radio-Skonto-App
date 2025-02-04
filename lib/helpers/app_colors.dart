import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const darkBlack = Color(0xFF000000);
  static const black = Color(0xFF3D3D3D);
  static const playerBlack = Color(0xFF1D1D1D);
  static const gray = Color(0xFFDBD9D6);
  static const lightGray = Color(0xFFF3F3F3);
  static const white = Color(0xFFFFFFFF);
  static const red = Color(0xFFD11F33);
  static const green = Color(0xFF71BD44);
  static const purple = Color(0xFF7A2682);

  static const redInstruction = Color(0xFFC8102E);
  static const greenInstruction = Color(0xFF78BE20);
  static const grayInstruction = Color(0xFF333333);

  static const Color pink = Color(0x90EC5257);

  static const List<Color> blackGradient = [
    Color.fromRGBO(18, 18, 18, 0.7),
    darkBlack
  ];
  static const List<Color> transparentGradient = [
    darkBlack,
    Colors.transparent
  ];
  static const List<Color> pinkGradient = [pink, Color(0x00EC5257)];
}