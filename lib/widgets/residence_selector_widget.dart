import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/models/place_of_residence_model.dart';
import 'package:radio_skonto/providers/auth_provider.dart';
import 'package:radio_skonto/widgets/residence_item.dart';

class ResidenceSelectorWidget extends StatelessWidget {
  ResidenceSelectorWidget({required this.onSelect, required this.initText, super.key,});

  final Function(int text) onSelect;
  final String initText;
  final txtController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    txtController.text = initText;
    return TextField(
      readOnly: true,
      showCursor: false,
      controller: txtController,
      enableSuggestions: false,
      autocorrect: false,
      onTap: () {
        showResidenceDialog(context);
      },
      style: AppTextStyles.main18regular,
      decoration: InputDecoration(
        hintStyle: AppTextStyles.main18regular.copyWith(color: AppColors.gray),
        suffixIcon: IconButton(
            onPressed: () {
              showResidenceDialog(context);
            },
            icon: const Icon(Icons.arrow_drop_down)),
        alignLabelWithHint: true,
      ),
    );
  }

  void showResidenceDialog(BuildContext context) {
    PlaceOfResidenceModel placesOfResidence = Provider.of<AuthProvider>(context, listen: false).placesOfResidence;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Singleton.instance.translate('residence_title'), style: AppTextStyles.main18bold),
          content: Container(
            width: 300,
            height: 300,
            child: ListView.builder(
              itemCount: placesOfResidence.data.values.length,
              itemBuilder: (context, index) {
                DatumResidence res = placesOfResidence.data.values.elementAt(index);
                return ResidenceItemWidget(
                    res: res,
                    selectedValue: (value){
                      onSelect(value);
                    });
              },
            ),
          ),
        );
      },
    );
  }
}