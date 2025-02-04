import 'package:flutter/material.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';

class FiltersCell extends StatelessWidget {
  const FiltersCell({super.key, required this.text, required this.isChecked, required this.onTap,});

  final String text;
  final bool isChecked;
  final Function(bool) onTap;

  @override
  Widget build(BuildContext context) {
    bool tempIsChecked = isChecked;
    return SizedBox(
      height: 30,
      child: Row(
        children: [
          Transform.scale(
            scale: 1.2,
            child: Checkbox(
                value: tempIsChecked,
                onChanged: (value) {
                  if (value != null) {
                    tempIsChecked = value;
                    onTap(value);
                  }
                }),
          ),
          GestureDetector(
            onTap: () {
              tempIsChecked = !tempIsChecked;
              onTap(tempIsChecked);
            },
            child: Text(text, style: isChecked ? AppTextStyles.main14bold : AppTextStyles.main14regular),
          )
        ],
      ),
    );
  }
}