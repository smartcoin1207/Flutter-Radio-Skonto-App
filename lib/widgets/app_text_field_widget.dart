import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';

class AppTextFieldWidget extends StatefulWidget {
  const AppTextFieldWidget(
      {this.initialText, this.errorText, this.isPassword, this.hideLine, this.keyboardType, required this.onChanged, required this.hintText, super.key, this.capitalization, this.minLine,});

  final Function(String text) onChanged;
  final String hintText;
  final String? errorText;
  final String? initialText;
  final bool? isPassword;
  final bool? hideLine;
  final TextInputType? keyboardType;
  final TextCapitalization? capitalization;
  final int? minLine;

  @override
  State<AppTextFieldWidget> createState() => _AppTextFieldWidgetState();
}
class _AppTextFieldWidgetState extends State<AppTextFieldWidget> {
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      minLines: widget.minLine == null ? null : widget.minLine,
      maxLines: widget.minLine == null ? 1 : 10,
      textCapitalization: widget.capitalization == null ? TextCapitalization.none : widget.capitalization!,
      initialValue: widget.initialText,
      keyboardType: widget.keyboardType,
      obscureText: widget.isPassword == null || false ? false : passwordVisible || false ? false : true,
      enableSuggestions: widget.isPassword == null || false ? true : false,
      autocorrect: false,
      onChanged: (text) {
        widget.onChanged(text);
      },
      style: AppTextStyles.main18regular,
      decoration: InputDecoration(
        errorText: widget.errorText,
        hintStyle: AppTextStyles.main18regular.copyWith(color: AppColors.gray),
        hintText: widget.hintText,
        alignLabelWithHint: true,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: widget.hideLine == null || false ? AppColors.gray : Colors.transparent),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: widget.hideLine == null || false ?  AppColors.gray : Colors.transparent),
        ),
        suffixIcon: widget.isPassword == null || false ?
        null :
        IconButton(
          icon: SvgPicture.asset(passwordVisible ? 'assets/icons/hide_password.svg' : 'assets/icons/show_password.svg',
              colorFilter:
              const ColorFilter.mode(AppColors.black, BlendMode.srcIn),
              width: 20,
              height: 15),
          onPressed: () {
            setState(() {
              passwordVisible = !passwordVisible;
            });
          },
        ),
      )
    );
  }
}