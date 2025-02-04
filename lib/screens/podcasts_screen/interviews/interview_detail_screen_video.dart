import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:radio_skonto/core/extensions.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/helpers/constant.dart';
import 'package:radio_skonto/models/interview_model.dart';
import 'package:radio_skonto/providers/download_provider.dart';
import 'package:radio_skonto/providers/player_provider.dart';
import 'package:radio_skonto/widgets/download_routed_button.dart';
import 'package:radio_skonto/widgets/like_widget.dart';
import 'package:radio_skonto/widgets/round_button_with_icon.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

class InterviewDetailScreenVideo extends StatefulWidget {
  const InterviewDetailScreenVideo({super.key, required this.interview});

  final InterviewData interview;

  @override
  State<InterviewDetailScreenVideo> createState() => _InterviewDetailScreenVideoState();
}

class _InterviewDetailScreenVideoState extends State<InterviewDetailScreenVideo> {

  late VideoPlayerController _controller;
  late ChewieController chewieController;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        apiBaseUrl + widget.interview.contentData.cards.first.video))
      ..initialize().then((_) {
        chewieController = ChewieController(
          videoPlayerController: _controller,
          autoPlay: false,
          looping: false,
        );
        setState(() {});
      });

  }

  @override
  void dispose() {
    _controller.dispose();
    chewieController.dispose();
    super.dispose();
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                10.hs,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Text(widget.interview.title, style: AppTextStyles.main18bold, maxLines: 2)),
                    LikeWidget(onTap: () {}, color: AppColors.red.withAlpha(64))
                  ],
                ),
                25.hs,
                _controller.value.isInitialized ?
                AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: Chewie(
                      controller: chewieController,
                    )

                  //VideoPlayer(_controller),
                ) : Container(
                  height: 200,
                  width: double.infinity,
                  color: AppColors.gray,
                  child: const Center(
                    child: Icon(Icons.video_camera_back_outlined, size: 50, color: AppColors.black,),
                  ),
                ),
                20.hs,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    widget.interview.contentData.cards.isEmpty || widget.interview.contentData.cards.first.allowDownloading == false ?
                    const SizedBox() :
                    DownloadRoutedButtonWidget(task: TaskInfo(name: widget.interview.contentData.cards.first.video, link: apiBaseUrl + widget.interview.contentData.cards.first.video),),
                    10.ws,
                    RoutedButtonWithIconWidget(iconName: 'assets/icons/shared_video.svg',
                      iconColor: AppColors.darkBlack,
                      size: 50,
                      onTap: () {
                        Share.share(apiBaseUrl + widget.interview.contentData.cards.first.video);
                      },
                      color: AppColors.gray, iconSize: 20,
                    ),
                  ],
                ),
                20.hs,
                HtmlWidget(widget.interview.description),
                //Text(widget.interview.description, style: AppTextStyles.main14regular),
                80.hs
              ],
            ),
          ),
        )
    );
  }
}



