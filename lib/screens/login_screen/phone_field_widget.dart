import 'package:flutter/material.dart';
import 'package:radio_skonto/custom_library/phone_field/intl_phone_field.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';

class PhoneFieldWidget extends StatelessWidget {
  const PhoneFieldWidget({required this.selectedValue, super.key,});

  final Function(String selectedValue) selectedValue;

  @override
  Widget build(BuildContext context) {
    final TextEditingController phoneController = TextEditingController();
    return IntlPhoneFieldCustom(
      //focusNode: focusNodePhone,
      controller: phoneController,
      showCountryFlag: false,
      autofocus: false,
      showDropdownIcon: true,
      dropdownIconPosition: IconPosition.trailing,
      initialCountryCode: 'LV',
      decoration: const InputDecoration(
        border: InputBorder.none,
      ),
      disableLengthCheck: true,
      style: AppTextStyles.main18regular,
      dropdownTextStyle: AppTextStyles.main18regular,
      cursorColor: Colors.white,
      onCountryChanged: (value) {
        selectedValue(value.dialCode);
      },
      onChanged: (value) {
      },
    );
  }
}