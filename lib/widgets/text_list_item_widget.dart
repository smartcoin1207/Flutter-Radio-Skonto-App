import 'package:flutter/material.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';

class TextListItemWidget extends StatelessWidget {
  const TextListItemWidget({required this.index, required this.text, required this.selectedValue, super.key,});

  final int index;
  final String text;
  final Function(int selectedValue) selectedValue;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        selectedValue(index);
        Navigator.pop(context);
      },
      child: Container(
        height: 40,
        child: Text(text, style: AppTextStyles.main18regular),
      ),
    );
  }
}