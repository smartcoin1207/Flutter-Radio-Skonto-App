import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/helpers/constant.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/models/interview_model.dart';
import 'package:radio_skonto/widgets/app_cached_network_image.dart';

class InterviewCellWidget extends StatelessWidget {
  const InterviewCellWidget({super.key, required this.interview, required this.onItemTap, required this.index});

  final InterviewData interview;
  final Function(int index) onItemTap;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onItemTap(index);
      },
      child: Padding(padding: EdgeInsets.only(left: index == 0 ? 24 : 5, top: 5, bottom: 5, right: 5),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                width: 300,
                height: 178,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    App.appBoxShadow
                  ],
                ),
                child: AppCachedNetworkImage(
                  Singleton.instance.checkIsFoolUrl(interview.image),
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              Expanded(
                  child: SizedBox(
                    width: 280,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(interview.title, style: AppTextStyles.main12bold, maxLines: 2, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  )
              ),
            ],
          )
      ),
    );
  }
}