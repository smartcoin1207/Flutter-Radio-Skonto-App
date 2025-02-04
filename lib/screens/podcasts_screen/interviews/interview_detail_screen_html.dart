import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/models/interview_model.dart';
import 'package:radio_skonto/providers/player_provider.dart';

class InterviewDetailScreenHTML extends StatefulWidget {
  const InterviewDetailScreenHTML({super.key, required this.interview});

  final InterviewData interview;

  @override
  State<InterviewDetailScreenHTML> createState() => _InterviewDetailScreenHTMLState();
}

class _InterviewDetailScreenHTMLState extends State<InterviewDetailScreenHTML> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
              ),
              onPressed: () {
                context.read<PlayerProvider>().showNavigationBar();
                Navigator.of(context).pop();
              },
            )
        ),
        backgroundColor: AppColors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: HtmlWidget(widget.interview.contentData.cards.first.html!.en),

            // Column(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     10.hs,
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(widget.interview.title, style: AppTextStyles.main18bold, maxLines: 2),
            //         LikeWidget(onTap: () {}, color: AppColors.red.withAlpha(64))
            //       ],
            //     ),
            //     25.hs,
            //     20.hs,
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.end,
            //       children: [
            //         widget.interview.contentData.cards.isEmpty || widget.interview.contentData.cards.first.allowDownloading == false ?
            //         const SizedBox() :
            //         DownloadRoutedButtonWidget(iconName: 'assets/icons/download_icon.svg',
            //           iconColor: AppColors.darkBlack,
            //           size: 50,
            //           onTap: () {
            //
            //           },
            //           color: AppColors.gray, iconSize: 20,
            //         ),
            //         10.ws,
            //         RoutedButtonWithIconWidget(iconName: 'assets/icons/shared_video.svg',
            //           iconColor: AppColors.darkBlack,
            //           size: 50,
            //           onTap: () {
            //             Share.share(apiBaseUrl + widget.interview.contentData.cards.first.video);
            //           },
            //           color: AppColors.gray, iconSize: 20,
            //         ),
            //       ],
            //     ),
            //     20.hs,
            //     HtmlWidget(widget.interview.description),
            //     //Text(widget.interview.description, style: AppTextStyles.main14regular),
            //     80.hs
            //   ],
            // ),
          ),
        )
    );
  }
}



