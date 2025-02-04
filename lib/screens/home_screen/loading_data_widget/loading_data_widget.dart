import 'package:flutter/material.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/widgets/custom_app_bar.dart';

class LoadingDataWidget extends StatelessWidget {
  const LoadingDataWidget({super.key,});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(),
      body: Center(
        child: CircularProgressIndicator(
          color: AppColors.red,
        ),
      ),
    );
  }
}