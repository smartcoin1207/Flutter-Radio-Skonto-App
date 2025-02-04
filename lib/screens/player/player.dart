import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:radio_skonto/core/extensions.dart';
import 'package:radio_skonto/custom_library/custom_app_slider.dart';
import 'package:radio_skonto/custom_library/custom_scroll_snap_list.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/helpers/constant.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/providers/main_screen_provider.dart';
import 'package:radio_skonto/providers/player_provider.dart';
import 'package:radio_skonto/screens/player/page_view.dart';
import 'package:radio_skonto/screens/player/player_bar.dart';
import 'package:radio_skonto/screens/player/scroll_physics.dart';
import 'package:radio_skonto/screens/player_helpers/audio_player_handler_impl.dart';
import 'package:radio_skonto/screens/player_helpers/common.dart';
import 'package:radio_skonto/screens/player_helpers/queue_state.dart';
import 'package:radio_skonto/widgets/app_cached_network_image.dart';
import 'package:rxdart/rxdart.dart';
import 'package:styled_text/styled_text.dart';

bool isScroll = true;

class AppPlayer extends StatefulWidget {
  final heightTop = 36.0;
  final AnimationController animationController;
  final int? index;
  final List<dynamic>? playlist;

  const AppPlayer({
    super.key,
    required this.animationController,
    required this.index,
    required this.playlist,
  });

  @override
  State<StatefulWidget> createState() => _AppPlayerState();
}

class _AppPlayerState extends State<AppPlayer> {
  final PageController _pageController = PageController();
  StreamSubscription? connectivitySubscription;
  final AudioPlayerHandler audioHandler = Singleton.instance.audioHandler;
  //int _focusedIndex = 0;
  final carouselSliderController = CarouselSliderController();
  MediaItem? _lastPlayingItem;
  static const cellSize = 64.0;
  bool _isMainData = false;

  @override
  void initState() {
    connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((result) {
          if (result.last == ConnectivityResult.none) {
            context.read<PlayerProvider>().playerStop();
          }
        });

    widget.animationController.addListener(() {
      setPhysics(widget.animationController.value);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const radius = Radius.circular(20);
    return PopScope(
      onPopInvoked: (status) {
        context.read<PlayerProvider>().checkMiniPlayerStatus();
      },
      child: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = MediaQuery.of(context).size.width;
            return SingleChildScrollView(
              physics: const ClampScrollPhysics(),
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.darkBlack,
                  borderRadius:
                  BorderRadius.only(topRight: radius, topLeft: radius),
                ),
                child: StreamBuilder<MediaItem?>(
                  stream: audioHandler.mediaItem,
                  builder: (context, snapshot) {
                    MediaItem? mediaItem = snapshot.data;
                    if (mediaItem != null) {
                      //checkIsMainData(mediaItem);
                      if (mediaItem.title.contains('internet')) {
                        mediaItem = _lastPlayingItem ;
                      } else {
                        _lastPlayingItem = mediaItem;
                      }
                    }
                    if (mediaItem == null) return const SizedBox();
                    return StreamBuilder<QueueState>(
                      stream: audioHandler.queueState,
                      builder: (context2, snapshot2) {
                        final queueState = snapshot2.data ?? QueueState.empty;
                        final queue = queueState.queue;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: children(width, 200, mediaItem!, queue, audioHandler, _isMainData),
                        );
                      }
                      );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  children(double width, double height, MediaItem mediaItem, List<MediaItem> mediaList, AudioPlayerHandler audioHandler, bool isMainData) {
    final title = mediaItem.displaySubtitle?? '';
    var subtitle = mediaItem.title?? '';
    final body = mediaItem.displayDescription?? '';

    if (title == subtitle) {
      subtitle = '';
    }

    int currentPlayIndex = context.read<MainScreenProvider>().currentSelectedPlaylistIndex;

    List<MediaItem> finalMediaList = mediaList;
    if (mediaList.isNotEmpty) {
      if (mediaList.first.genre == null || (mediaList.first.genre != null && mediaList.first.genre!.contains('Episode') == false)) {
        finalMediaList = context.read<PlayerProvider>().mainPlaylist;
      }
      if (mediaList.first.genre != null && mediaList.first.genre!.contains('Episode')) {
        currentPlayIndex = context.read<PlayerProvider>().currentTabBarIndex;
      }
    }
    if (finalMediaList.isNotEmpty) {
      checkIsMainData(finalMediaList.first);
    }

    return [
      PlayerMainImage(imageUrl: mediaItem.artUri.toString() == '' ?
      'https://farm4.staticflickr.com/3224/3081748027_0ee3d59fea_z_d.jpg' :
      mediaItem.artUri.toString()),
      Container(
        color: AppColors.darkBlack,
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: AppTextStyles.main18bold.copyWith(
                  color: AppColors.white, overflow: TextOverflow.ellipsis),
            ),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: AppTextStyles.main16regular.copyWith(
                  color: AppColors.white, overflow: TextOverflow.ellipsis),
            ),
            10.hs,
            AppPlayerBar(audioHandler: audioHandler, author: subtitle, title: title),
            finalMediaList.isEmpty ? const SizedBox() :
            30.hs,
            // StreamBuilder<PositionData>(
            //   stream: context.read<PlayerProvider>().positionDataStream,
            //   builder: (context, snapshot) {
            //     final positionData = snapshot.data ??
            //         PositionData(Duration.zero, Duration.zero, Duration.zero);
            //     return SeekBar(
            //       duration: positionData.duration,
            //       position: positionData.position,
            //       onChangeEnd: (newPosition) {
            //         audioHandler.seek(newPosition);
            //       },
            //     );
            //   },
            // ),
            Container(
              height: cellSize,
              //width: double.infinity,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        carouselSliderController.previousPage(duration: const Duration(milliseconds: 500));
                       //listController.animateTo(listController.position.pixels - cellSize, duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
                      },
                      icon: const Icon(Icons.arrow_back_ios_rounded, color: AppColors.white,),
                  ),
                  Expanded(child:
                  CustomCarouselSlider(
                    key: const ValueKey<int>(7465537),
                    disableGesture: false,
                    carouselController: carouselSliderController,
                    options: CarouselOptions(
                        height: cellSize,
                        viewportFraction: 0.2,
                        disableCenter: true,
                        initialPage: currentPlayIndex,
                        enlargeStrategy: CenterPageEnlargeStrategy.height,
                        onScrolled: (scrollDouble) {

                        },
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) {
                          if (_isMainData) {
                            context.read<MainScreenProvider>().setPlaylistOnHomePage(index, context);
                            //context.read<PlayerProvider>().carouselSliderControllerAppBar.animateToPage(index, duration: const Duration(milliseconds: 500));
                           // setState(() {});
                          } else {
                            context.read<PlayerProvider>().playAllTypeMedia(finalMediaList, index, title, '');
                          }
                        }
                    ),
                    items: List.generate(finalMediaList.length, ((index) {
                      return _buildListItem(context, index, finalMediaList[index], cellSize, currentPlayIndex);
                    })),
                  )
                  ),
                  IconButton(
                    onPressed: () {
                      carouselSliderController.nextPage(duration: const Duration(milliseconds: 500));
                    },
                    icon: const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.white,),
                  ),
                ],
              ),
            ),
            50.hs
          ],
        ),
      ),
      Padding(
        padding: App.edgeInsets,
        child: StyledText(text: body, style: AppTextStyles.main16regular.copyWith(color: AppColors.white)),
        // MarkdownBody(
        //   data: body,
        //   styleSheet: MarkdownStyleSheet(
        //     a: const TextStyle(
        //         decoration: TextDecoration.underline, color: Colors.white),
        //     p: style,
        //     code: style,
        //   ),
        //   onTapLink: (text, url, title) async {
        //     if (url != null) {
        //       Singleton.instance.openUrl(url, context);
        //     }
        //   },
        // ),
      ),
      32.hs,
    ];
  }

  void checkIsMainData(MediaItem item) {
    if (item.genre != null && item.genre!.contains('MainData')) {
      _isMainData = true;
    } else {
      _isMainData = false;
    }
  }

  Widget _buildListItem(BuildContext context, int index, MediaItem mediaItem, double cellSize, int currentPlayIndex) {
     double cSize = currentPlayIndex == index ? cellSize - 10 : cellSize - 20;
     bool isMainDataFinal = false;
     if (mediaItem.genre != null && mediaItem.genre!.contains('MainData')) {
       isMainDataFinal = true;
     } else {
       isMainDataFinal = false;
     }
     if (isMainDataFinal == false) {
       cSize = cellSize - 10;
     }

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5),
            height: cSize,
            width: cSize,
            //color: Colors.transparent,
            child: Center(
              child: AppCachedNetworkImage(
                key: UniqueKey(),
                mediaItem.artUri.toString(),
                width: cSize,
                height: cSize,
                colorFilter: currentPlayIndex == index ? null : isMainDataFinal ? Colors.white : null,
                boxFit: BoxFit.fitWidth,
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(15),
                // ),
              )
            ),
          )
        ],
      ),
    );
  }

  setPhysics(double value) {
    if (value == 1.0) {
      if (isScroll == true) {
        isScroll = false;
      }
    } else if (value != 1.0) {
      if (isScroll == false) {
        isScroll = true;
      }
    }
  }

  @override
  void dispose() {
    connectivitySubscription?.cancel();
    //_audioPlayer.playerStateStream.drain();
    //_audioPlayer.sequenceStateStream.drain();
    widget.animationController.dispose();
    _pageController.dispose();

    super.dispose();
  }

}
