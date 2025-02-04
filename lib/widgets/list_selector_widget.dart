import 'package:flutter/material.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/widgets/text_list_item_widget.dart';

class ListSelectorWidget extends StatelessWidget {
  ListSelectorWidget({required this.list, required this.title, required this.onSelect, required this.initText, super.key,});

  final String title;
  final Function(String text) onSelect;
  final String initText;
  final txtController = TextEditingController();
  final List<String> list;

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
        showListDialog(context);
      },
      style: AppTextStyles.main18regular,
      decoration: InputDecoration(
        hintStyle: AppTextStyles.main18regular.copyWith(color: AppColors.gray),
        suffixIcon: IconButton(
            onPressed: () {
              showListDialog(context);
            },
            icon: const Icon(Icons.arrow_drop_down)),
        alignLabelWithHint: true,
      ),
    );
  }

  void showListDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: AppTextStyles.main18bold),
          content: Container(
            width: 300,
            height: 300,
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                String text = list[index];
                return TextListItemWidget(
                    text: text,
                    selectedValue: (value){
                      onSelect(text);
                    }, index: index,);
              },
            ),
          ),
        );
      },
    );
  }
}