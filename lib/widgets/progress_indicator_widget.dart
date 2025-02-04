import 'package:flutter/material.dart';
import 'package:radio_skonto/helpers/api_helper.dart';
import 'package:radio_skonto/helpers/app_colors.dart';

class AppProgressIndicatorWidget extends StatelessWidget {
  const AppProgressIndicatorWidget({super.key, this.responseState, this.onRefresh});

  final ResponseState? responseState;
  final Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: responseState == ResponseState.stateLoading ?
      const CircularProgressIndicator(
        color: AppColors.red,
      ) :
      IconButton(
          onPressed: () {onRefresh!();},
          icon: const Icon(Icons.refresh, size: 45, color: AppColors.red,)
      )
    );
  }
}

