import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_skonto/core/extensions.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/models/podcasts_model.dart';
import 'package:radio_skonto/providers/player_provider.dart';
import 'package:radio_skonto/screens/podcasts_screen/audio_video/audio_list_cell.dart';
import 'package:radio_skonto/screens/podcasts_screen/video_podcast_detail.dart';
import 'package:radio_skonto/widgets/like_widget.dart';
import '../../helpers/app_text_style.dart';

class PodcastDetailScreen extends StatefulWidget {
  const PodcastDetailScreen({super.key, required this.podcast});

  final Podcast podcast;

  @override
  State<PodcastDetailScreen> createState() => _PodcastDetailScreenState();
}

class _PodcastDetailScreenState extends State<PodcastDetailScreen> {

  int? descriptionLineNum = 4;

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.hs,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${widget.podcast.episodes.length} ${Singleton.instance.translate('items_title')}' , style: AppTextStyles.main14bold, maxLines: 1,),
                      Text(widget.podcast.paidContent , style: AppTextStyles.main12regular, maxLines: 1,),
                    ],
                  ),
                  LikeWidget(onTap: () {}, color: AppColors.red.withAlpha(64),)
                ],
              ),
              15.hs,
              Text(widget.podcast.title, style: AppTextStyles.main18bold, maxLines: 1,),
              15.hs,
              Text(widget.podcast.description , style: AppTextStyles.main14regular, maxLines: descriptionLineNum,),
              widget.podcast.description.length > 223 && descriptionLineNum != null ?
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
              widget.podcast.episodes != null && widget.podcast.episodes.isEmpty ?
              const SizedBox() :
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.podcast.episodes.length,
                  itemBuilder: (context, index) {
                    return AudioListCell(episode: widget.podcast.episodes[index], onTap: (episode){
                      if (episode.contentData.cards.isNotEmpty && episode.contentData.cards.first.audioFile != '') {
                        List<Episode> list = widget.podcast.episodes;
                        context.read<PlayerProvider>().playAllTypeMedia(list, index, widget.podcast.title, '');
                      } else if (episode.contentData.cards.isNotEmpty && episode.contentData.cards.first.videoUrl != '') {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) => VideoPodcastDetailScreen(episode: episode)),
                          fullscreenDialog: true
                        ));
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



