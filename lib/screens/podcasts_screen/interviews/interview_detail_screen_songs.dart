import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_skonto/core/extensions.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/models/interview_model.dart';
import 'package:radio_skonto/providers/player_provider.dart';
import 'package:radio_skonto/screens/podcasts_screen/interviews/interview_list_cell.dart';
import 'package:radio_skonto/widgets/back_only_navigation_bar.dart';
import 'package:radio_skonto/widgets/like_widget.dart';
import 'package:styled_text/widgets/styled_text.dart';

class InterviewDetailScreenSongs extends StatefulWidget {
  const InterviewDetailScreenSongs({super.key, required this.interview});

  final InterviewData interview;

  @override
  State<InterviewDetailScreenSongs> createState() => _InterviewDetailScreenSongsState();
}

class _InterviewDetailScreenSongsState extends State<InterviewDetailScreenSongs> {

  int? descriptionLineNum = 4;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const BackOnlyAppBar(),
        backgroundColor: AppColors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //10.hs,
                Text(widget.interview.paidContent , style: AppTextStyles.main12regular, maxLines: 1,),
                15.hs,
                Text(widget.interview.title, style: AppTextStyles.main18bold, maxLines: 1,),
                15.hs,
                StyledText(text: widget.interview.description, maxLines: descriptionLineNum,),
                widget.interview.description.length > 223 && descriptionLineNum != null ?
                Column(
                  children: [
                    10.hs,
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          descriptionLineNum = null;
                        });
                      },
                      child: Text(Singleton.instance.translate('read_more_title'), textAlign: TextAlign.start, style: AppTextStyles.main14regular.copyWith(decoration: TextDecoration.underline)),
                    ),
                  ],
                ) : const SizedBox(),
                30.hs,
                widget.interview.contentData.cards.isEmpty ?
                const SizedBox() :
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.interview.contentData.cards.length,
                    itemBuilder: (context, index) {
                      return InterviewListCell(interviewData: widget.interview,
                          onTap: (interview) {
                            if (interview.contentData.cards.isNotEmpty && interview.contentData.cards.first.audioFile != '') {
                              List<InterviewData> list = [interview];
                              context.read<PlayerProvider>().playAllTypeMedia(list, index, widget.interview.title, widget.interview.description);
                            }
                      });
                    }
                ),
                100.hs
              ],
            ),
          ),
        )
    );
  }
}



