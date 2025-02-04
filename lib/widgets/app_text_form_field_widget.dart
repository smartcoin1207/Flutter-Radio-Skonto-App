import 'package:flutter/material.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';

class AppTextFormFieldWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Widget? prefixIcon;
  final ValueChanged<String>? onFieldSubmitted;
  final ValueChanged<String>? onChanged;

  const AppTextFormFieldWidget({
    super.key,
    this.controller,
    this.hintText,
    this.prefixIcon,
    this.onFieldSubmitted,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.black.withOpacity(0.5);
    final border = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      borderSide: BorderSide(color: AppColors.black.withOpacity(0.15)),
    );

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText ?? 'Rakstīt šeit...',
        contentPadding: const EdgeInsets.all(16),
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        hintStyle: AppTextStyles.main16regular.copyWith(color: color),
        prefixIcon: prefixIcon,
        prefixIconColor: color,
      ),
      maxLines: 1,
      cursorColor: color,
      style: AppTextStyles.main16regular,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
    );
  }
}
