import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/providers/player_provider.dart';
import 'package:radio_skonto/screens/player_helpers/audio_player_handler_impl.dart';
import 'package:radio_skonto/widgets/setting_view_by_three_dot.dart';

class AppPlayerBar extends StatefulWidget {
  const AppPlayerBar({super.key,  required this.audioHandler, required this.author, required this.title});

  final AudioPlayerHandler audioHandler;
  final String author;
  final String title;

  @override
  State<StatefulWidget> createState() => _AppPlayerBarState();
}

class _AppPlayerBarState extends State<AppPlayerBar> {
  late AudioPlayer audioPlayer;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool isPlaying = false;
  final AudioPlayerHandler audioHandler = Singleton.instance.audioHandler;
  double currentVolume = 1;

  @override
  void initState() {
    super.initState();
    audioPlayer = context.read<PlayerProvider>().getPlayer;

    audioPlayer.playingStream.listen((bool status) {
      if (status != isPlaying && mounted) {
        setState(() {
          isPlaying = status;
        });
      }
    });

    audioPlayer.durationStream.listen((event) {
      if (event != null && mounted) {
        setState(() {
          duration = event;
        });
      }
    });
    audioPlayer.positionStream.listen((event) {
      if (mounted) {
        setState(() {
          position = event;
        });
      }
    });
  }

  @override
  void dispose() {
    audioPlayer.playingStream.drain();
    audioPlayer.durationStream.drain();
    audioPlayer.positionStream.drain();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlaybackState>(
        stream: audioHandler.playbackState,
        builder: (context, snapshot) {
          final playbackState = snapshot.data;
          final playing = playbackState?.playing ?? false;

          return Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      currentVolume == 1.0 ? currentVolume = 0 : currentVolume = 1.0;
                      audioHandler.setVolume(currentVolume);
                      setState(() {
                      });
                    },
                    icon: currentVolume == 1.0 ?
                    SvgPicture.asset('assets/icons/volume_icon.svg',
                        colorFilter:
                        const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                        width: 21,
                        height: 21) :
                    const Icon(Icons.volume_off_outlined, color: AppColors.gray, size: 28,),
                  ),
                  IconButton(
                    onPressed: () {

                    },
                    icon: SvgPicture.asset('assets/icons/dislike_icon.svg',
                        colorFilter:
                        const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                        width: 21,
                        height: 21),
                  ),
                  IconButton(
                    onPressed: () {
                      context.read<PlayerProvider>().playPause(context);
                    },
                    icon: SvgPicture.asset(playing ? 'assets/icons/pause_button_big.svg' : 'assets/icons/play_button_big.svg',
                        colorFilter:
                        const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                        width: 90,
                        height: 90),
                  ),
                  IconButton(
                    onPressed: () {

                    },
                    icon: SvgPicture.asset('assets/icons/like_icon.svg',
                        colorFilter:
                        const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                        width: 21,
                        height: 21),
                  ),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (builder) {
                          return SettingViewByThreeDot(itIsStream: true, author: widget.author, title: widget.title,);
                        },
                      );
                    },
                    icon: SvgPicture.asset('assets/icons/three_dot_button.svg',
                        colorFilter:
                        const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                        width: 18,
                        height: 4),
                  ),
                ],
              ),
            ],
          );
        }
      );
  }
}
