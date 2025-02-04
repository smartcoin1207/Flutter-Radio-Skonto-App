import 'package:flutter/material.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/helpers/singleton.dart';

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.tabController,
    required this.currentPageIndex,
    required this.onUpdateCurrentPageIndex,
  });

  final int currentPageIndex;
  final TabController tabController;
  final void Function(int) onUpdateCurrentPageIndex;

  static const bottomPadding = 30.0;
  static const lrPadding = 25.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        Positioned(bottom: bottomPadding,
          left: lrPadding,child: TextButton(onPressed: () {
            if (currentPageIndex == 0) {
              Navigator.of(context).pop();
              return;
            }
            onUpdateCurrentPageIndex(currentPageIndex - 1);
          },
              child: Text(currentPageIndex == 0 ? Singleton.instance.translate('skip_title') : Singleton.instance.translate('back_title'), style: AppTextStyles.main16regular.copyWith(decoration: TextDecoration.underline, color: AppColors.white, decorationColor: AppColors.white))
          ),
        ),
        Positioned(bottom: bottomPadding + 10,child: TabPageSelector(
          controller: tabController,
          color: AppColors.white.withAlpha(50),
          selectedColor: AppColors.white,
        ),
        ),
        Positioned(bottom: bottomPadding,
          right: lrPadding,child: TextButton(onPressed: () {
            if (currentPageIndex == 2) {
              Navigator.of(context).pop();
              return;
            }
            onUpdateCurrentPageIndex(currentPageIndex + 1);
          },
              child: Text(currentPageIndex == 2 ? Singleton.instance.translate('complete_title') : Singleton.instance.translate('next_title'), style: AppTextStyles.main16regular.copyWith(decoration: TextDecoration.underline, color: AppColors.white, decorationColor: AppColors.white))
          ),
        )
      ],
    );
  }
}