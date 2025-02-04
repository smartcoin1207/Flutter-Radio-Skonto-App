import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:radio_skonto/core/extensions.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/providers/player_provider.dart';
import 'package:radio_skonto/screens/player/animation_controller.dart';
import 'package:radio_skonto/screens/player/player.dart';
import 'package:radio_skonto/screens/player_helpers/audio_player_handler_impl.dart';
import 'package:radio_skonto/widgets/app_cached_network_image.dart';

class MiniAppPlayer extends StatefulWidget {
  static const height = 81.0;

  const MiniAppPlayer({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MiniAppPlayerState();
}

class _MiniAppPlayerState extends State<MiniAppPlayer> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  StreamSubscription? connectivitySubscription;
  final AudioPlayerHandler audioHandler = Singleton.instance.audioHandler;
  MediaItem? _lastPlayingItem;
  final animationController = AppAnimationController().controller;
  late AppPlayer playerView;

  @override
  void initState() {
    super.initState();

    playerView = AppPlayer(
      animationController: animationController,
      index: null,
      playlist: null,
    );

    context.read<PlayerProvider>().initTimer();

    _audioPlayer = context.read<PlayerProvider>().getPlayer;

    _audioPlayer.playerStateStream.listen((PlayerState state) {
      if (state.processingState == ProcessingState.completed) {
        _audioPlayer.stop();
        _audioPlayer.seek(Duration.zero);
      }
    });

    _audioPlayer.playingStream.listen((bool status) {
      if (status != isPlaying && mounted) {
        setState(() {
          isPlaying = status;
        });
      }
    });

    connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((result) {
          if (result.first == ConnectivityResult.none) {
            context.read<PlayerProvider>().playerStop();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MediaItem?>(
      stream: audioHandler.mediaItem,
      builder: (context, snapshot) {
        MediaItem? mediaItem = snapshot.data;
        if (mediaItem != null) {
          if (mediaItem.title.contains('internet')) {
            mediaItem = _lastPlayingItem ;
          } else {
            _lastPlayingItem = mediaItem;
          }
        }
        if (mediaItem == null) return const SizedBox();
        return StreamBuilder<PlaybackState>(
            stream: audioHandler.playbackState,
            builder: (context2, snapshot2) {
              final playbackState = snapshot2.data;
              final playing = playbackState?.playing?? false;
              return ChangeNotifierProvider.value(
                  value: Provider.of<PlayerProvider>(context),
                  child: Consumer<PlayerProvider>(builder: (context, playerProvider, _) {
                    return AnimatedPadding(
                      padding: EdgeInsets.only(bottom: playerProvider.navigationBarMustBeShown ? 56 : 0,left: 3, right: 3),
                      duration: const Duration(milliseconds: 200),
                      child: GestureDetector(
                        onTap: () {
                          context.read<PlayerProvider>().openPlayerStatus();
                          context.openPlayer(null, null, playerView, animationController);
                        },
                        onPanUpdate: (details) {
                          if (details.delta.dx > 0) {
                            context.read<PlayerProvider>().openPlayerStatus();
                            context.openPlayer(null, null, playerView, animationController);
                          }
                        },
                        child: Container(
                          height: MiniAppPlayer.height,
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.playerBlack,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              8.ws,
                              AppCachedNetworkImage(
                                  mediaItem!.artUri.toString() == '' ?
                                  'https://farm4.staticflickr.com/3224/3081748027_0ee3d59fea_z_d.jpg'
                                      : mediaItem.artUri.toString(),
                                  boxFit: BoxFit.fitWidth,
                                  width: 49,
                                  height: 49),
                              16.ws,
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      mediaItem.displaySubtitle?? mediaItem.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.main16bold.copyWith(color: AppColors.white),
                                    ),
                                    Text(
                                      mediaItem.displaySubtitle == null ? '' : mediaItem.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.main16regular.copyWith(color: AppColors.white),
                                    ),
                                  ],
                                ),
                              ),
                              8.ws,
                              IconButton(
                                onPressed: () {
                                  //context.read<PlayerProvider>().getPlayNowData();
                                  context.read<PlayerProvider>().playPause(context);
                                },
                                icon: SvgPicture.asset(playing ? 'assets/icons/pause_button.svg' : 'assets/icons/button_play.svg',
                                    colorFilter:
                                    const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                                    width: 48,
                                    height: 48),
                              ),
                              // AppCircleButton(
                              //   iconData:
                              //   isPlaying == false ? Icons.play_arrow_rounded : Icons.pause,
                              //   backgroundColor: AppColors.red,
                              //   onTap: () {
                              //     context.read<PlayerProvider>().playPause(context);
                              //   },
                              // ),
                            ],
                          ),
                        ),
                      ),
                    );
                  })
              );
            });
      },
    );
  }

  @override
  void dispose() {
    connectivitySubscription?.cancel();
    _audioPlayer.playingStream.drain();
    _audioPlayer.playerStateStream.drain();
    _audioPlayer.sequenceStateStream.drain();
    super.dispose();
  }
}
