import 'package:flutter/material.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/models/place_of_residence_model.dart';

class ResidenceItemWidget extends StatelessWidget {
  const ResidenceItemWidget({required this.res, required this.selectedValue, super.key,});

  final DatumResidence res;
  final Function(int selectedValue) selectedValue;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        selectedValue(res.id);
        Navigator.pop(context);
      },
      child: Container(
        height: 40,
        child: Text(res.name, style: AppTextStyles.main18regular),
      ),
    );
  }
}