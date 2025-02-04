import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:radio_skonto/helpers/api_helper.dart';
import 'package:radio_skonto/helpers/constant.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/main.dart';
import 'package:radio_skonto/models/interview_model.dart';
import 'package:radio_skonto/models/main_screen_data.dart';
import 'package:radio_skonto/models/play_now_model.dart';
import 'package:radio_skonto/models/podcasts_model.dart';
import 'package:radio_skonto/providers/car_play_module.dart';
import 'package:radio_skonto/screens/player_helpers/audio_player_handler_impl.dart';
import 'package:radio_skonto/screens/player_helpers/common.dart';
import 'package:radio_skonto/screens/player_helpers/media_library.dart';
import 'package:rxdart/rxdart.dart';

bool isMovePlayer = false;

enum ContentType { mainRadio, podcast, interview }

class PlayerProvider with ChangeNotifier {
  final PersistentTabController tabBarController =
      PersistentTabController(initialIndex: 0);
  late CarPlayModule carPlayModule;
  bool _isInternetAvailable = true;
  bool itemIsChanged = true;
  int indexInQueue = 0;

  late Stream<Duration> _bufferedPositionStream;
  late Stream<Duration?> _durationStream;
  late Stream<PositionData> _positionDataStream;
  Stream<PositionData> get positionDataStream => _positionDataStream;
  // Stream<Duration> get _bufferedPositionStream => audioHandler.playbackState
  //     .map((state) => state.bufferedPosition)
  //     .distinct();
  // Stream<Duration?> get _durationStream =>
  //     audioHandler.mediaItem.map((item) => item?.duration).distinct();
  // Stream<PositionData> get positionDataStream =>
  //     Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
  //         AudioService.position,
  //         _bufferedPositionStream,
  //         _durationStream,
  //             (position, bufferedPosition, duration) => PositionData(
  //             position, bufferedPosition, duration ?? Duration.zero));

  var mediaLibrary = MediaLibrary();
  List<MediaItem> radioItemsToNoInternet = [];
  List<MediaItem> podcastsItemsToNoInternet = [];
  List<MediaItem> interviewItemsToNoInternet = [];
  List<MediaItem> favoritesItemsToNoInternet = [];
  List<dynamic> _itemsBeforeInternetOff = [];
  int indexOfPlayingItemBeforeInternetOff = 0;
  bool _internetOffPlayingState = false;
  final carouselSliderControllerAppBar = CarouselSliderController();
  final carouselSliderControllerMainCell = CarouselSliderController();

  List<MediaItem> mainPlaylist = [];

  ResponseState getPlayNowDataResponseState = ResponseState.stateFirsLoad;
  final AudioPlayer _audioPlayer = Singleton.instance.audioPlayer;
  bool _showMiniPlayer = false;
  bool _loadStatus = false;
  bool _isOpening = false;
  bool timerIsInit = false;

  AudioPlayer get getPlayer => _audioPlayer;
  bool get getShowMiniPlayer => _showMiniPlayer;
  bool get getLoadStatus => _loadStatus;
  bool get getIsOpening => _isOpening;

  int currentTabBarIndex = 0;
  bool navigationBarMustBeShown = true;
  double appBarHeight = 56;
  String _currentPlayNowUrl = '';
  String currentStreamUrl = '';
  bool itIsStream = false;
  bool isPlayerHandleInit = false;
  Timer? _playNowUpdateTimer;
  MediaItem playNowMediaItem = const MediaItem(id: '', title: '');

  Future<void> initSetupCarPlay() async {
    carPlayModule = CarPlayModule();
    carPlayModule.initSetupCarPlay();
  }

  Future<bool> initPlayerHandle() async {
    if (isPlayerHandleInit == false) {
      Singleton.instance.audioHandler = await AudioService.init(
        builder: () => AudioPlayerHandlerImpl(this),
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'com.ryanheise.skonto.channel.audio',
          androidNotificationChannelName: 'Sconto radio',
          androidNotificationOngoing: true,
        ),
      );
      _bufferedPositionStream = Singleton.instance.audioHandler.playbackState
          .map((state) => state.bufferedPosition)
          .distinct();
      _durationStream = Singleton.instance.audioHandler.mediaItem
          .map((item) => item?.duration)
          .distinct();
      _positionDataStream =
          Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
              AudioService.position,
              _bufferedPositionStream,
              _durationStream,
              (position, bufferedPosition, duration) => PositionData(
                  position, bufferedPosition, duration ?? Duration.zero));

      isPlayerHandleInit = true;
      // if (Platform.isIOS) {
      //   carPlayModule = CarPlayModule();
      //   setupCarPlay();
      // }
      return true;
    } else {
      return true;
    }
  }

  void setNoInternetItems() async {
    _isInternetAvailable = false;
    indexOfPlayingItemBeforeInternetOff = _audioPlayer.currentIndex ?? 0;
    _internetOffPlayingState = _audioPlayer.playing;

    var noInternetItem = MediaItem(
      id: 'no_internet_1',
      playable: false,
      title: Singleton.instance.translate('no_internet_connection'),
    );
    radioItemsToNoInternet =
        mediaLibrary.baseItems[MediaLibrary.titleIdRadio] ?? [];
    podcastsItemsToNoInternet =
        mediaLibrary.baseItems[MediaLibrary.titleIdPodcasts] ?? [];
    interviewItemsToNoInternet =
        mediaLibrary.baseItems[MediaLibrary.titleIdInterview] ?? [];
    favoritesItemsToNoInternet =
        mediaLibrary.baseItems[MediaLibrary.titleIdFavorites] ?? [];
    mediaLibrary.baseItems[MediaLibrary.titleIdPodcasts] = [noInternetItem];
    mediaLibrary.baseItems[MediaLibrary.titleIdRadio] = [noInternetItem];
    mediaLibrary.baseItems[MediaLibrary.titleIdInterview] = [noInternetItem];
    mediaLibrary.baseItems[MediaLibrary.titleIdFavorites] = [noInternetItem];
    await Singleton.instance.audioHandler
        .updateQueue(mediaLibrary.baseItems[MediaLibrary.titleIdRadio]!);
    await Singleton.instance.audioHandler
        .updateQueue(mediaLibrary.baseItems[MediaLibrary.titleIdPodcasts]!);
    await Singleton.instance.audioHandler
        .updateQueue(mediaLibrary.baseItems[MediaLibrary.titleIdInterview]!);
    await Singleton.instance.audioHandler
        .updateQueue(mediaLibrary.baseItems[MediaLibrary.titleIdFavorites]!);
    //await Singleton.instance.audioHandler.updateMediaItem(noInternetItem);
    carPlayModule.setNoInternetItemsCarPlay();
  }

  void setInternetIsAvailableItems(BuildContext context) async {
    _isInternetAvailable = true;
    if (radioItemsToNoInternet.isNotEmpty) {
      mediaLibrary.baseItems[MediaLibrary.titleIdRadio] =
          radioItemsToNoInternet;
      mediaLibrary.baseItems[MediaLibrary.titleIdPodcasts] =
          podcastsItemsToNoInternet;
      mediaLibrary.baseItems[MediaLibrary.titleIdInterview] =
          interviewItemsToNoInternet;
      mediaLibrary.baseItems[MediaLibrary.titleIdFavorites] =
          favoritesItemsToNoInternet;
      await Singleton.instance.audioHandler
          .updateQueue(mediaLibrary.baseItems[MediaLibrary.titleIdRadio]!);
      await Singleton.instance.audioHandler
          .updateQueue(mediaLibrary.baseItems[MediaLibrary.titleIdPodcasts]!);
      await Singleton.instance.audioHandler
          .updateQueue(mediaLibrary.baseItems[MediaLibrary.titleIdInterview]!);
      await Singleton.instance.audioHandler
          .updateQueue(mediaLibrary.baseItems[MediaLibrary.titleIdFavorites]!);
    }
    carPlayModule.setInternetConnectionRestoredItemsCarPlay();
    if (_itemsBeforeInternetOff.isNotEmpty) {
      updateAndroidAutoAndCarPlayItems(_itemsBeforeInternetOff);
      if (_internetOffPlayingState == true) {
        playAllTypeMedia(_itemsBeforeInternetOff,
            indexOfPlayingItemBeforeInternetOff, '', '');
      }
    }
  }

  openPlayerStatus() {
    _isOpening = true;
    notifyListeners();
  }

  void hideNavigationBar() {
    navigationBarMustBeShown = false;
    notifyListeners();
  }

  void showNavigationBar() {
    navigationBarMustBeShown = true;
    notifyListeners();
  }

  void tabBarIndexIsChanged(int index) {
    itemIsChanged = true;
    currentTabBarIndex = index;
    notifyListeners();
  }

  void switchToTabBarItem(int index) {
    tabBarIndexIsChanged(index);
    tabBarController.jumpToTab(index);
  }

  void initTimer() {
    if (timerIsInit == false) {
      timerIsInit = true;
      _playNowUpdateTimer = Timer.periodic(
          const Duration(seconds: 5), (Timer t) => _playNowTimer());
    }
  }

  closePlayerStatus() {
    _isOpening = false;
    notifyListeners();
  }

  loadSearchToPlayer(String id) async {
    _loadStatus = false;
    _isOpening = true;
    notifyListeners();
  }

  void checkMiniPlayerStatus() {
    if (_audioPlayer.currentIndex != null) {
      _showMiniPlayer = true;
    } else {
      _showMiniPlayer = false;
    }
    _isOpening = false;
    notifyListeners();
  }

  void hideMiniPlayer() {
    _showMiniPlayer = false;
    notifyListeners();
    //playerStop();
  }

  // void showMiniPlayer() {
  //   _showMiniPlayer = true;
  //   notifyListeners();
  // }

  playerStop() async {
    _audioPlayer.pause();
  }

  playPause(BuildContext context) async {
    if (_audioPlayer.playing) {
      _audioPlayer.pause();
    } else {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.first == ConnectivityResult.none) {
        return;
      }
      _audioPlayer.play();
    }
    notifyListeners();
    checkMiniPlayerStatus();
  }

  void _playNowTimer() {
    if (_audioPlayer.playing &&
        _currentPlayNowUrl != '' &&
        itIsStream == true) {
      getPlayNowData(_currentPlayNowUrl);
    }
  }

  Future<void> updateAndroidAutoAndCarPlayItems(List<dynamic> items) async {
    // await initPlayerHandle(context).then((value) async {
    if (items.isNotEmpty) {
      if (items.first is AudioPodcast) {
        List<MediaItem> firstLayerList = [];
        List<MediaItem> secondLayerPodcastList = [];
        List<MediaItem> thirdLayerMediaList = [];
        for (AudioPodcast aP in items) {
          MediaItem apItem =
              MediaItem(playable: false, id: aP.id.toString(), title: aP.name);
          // firstLayerList.add(apItem);
          bool needToAddPodcastSection = false;

          if (aP.podcasts != null && aP.podcasts!.isNotEmpty) {
            secondLayerPodcastList = [];
            for (Podcast p in aP.podcasts!) {
              MediaItem pItem = MediaItem(
                  playable: false,
                  id: p.id.toString(),
                  artUri: Uri.parse(Singleton.instance.checkIsFoolUrl(p.image)),
                  title: p.title);

              if (p.episodes.isNotEmpty) {
                for (Episode e in p.episodes) {
                  needToAddPodcastSection = true;
                  MediaItem item = MediaItem(
                      id: apiBaseUrl + e.contentData.cards.first.audioFile,
                      genre: 'Episode',
                      artUri: Uri.parse(Singleton.instance
                          .checkIsFoolUrl(e.contentData.cards.first.image)),
                      duration: Duration(
                          seconds: e.contentData.cards.first.audioDuration),
                      artist: p.title,
                      title: e.title);
                  thirdLayerMediaList.add(item);
                }
                mediaLibrary.baseItems[p.id.toString()] = thirdLayerMediaList;
                thirdLayerMediaList = [];
                secondLayerPodcastList.add(pItem);
              }
            }
            mediaLibrary.baseItems[aP.id.toString()] = secondLayerPodcastList;
            secondLayerPodcastList = [];
          }
          if (needToAddPodcastSection == true) {
            firstLayerList.add(apItem);
          }
        }
        mediaLibrary.baseItems[MediaLibrary.titleIdPodcasts] = firstLayerList;
        firstLayerList = [];
        _updateCarPlayAudioPodcastsList(items as List<AudioPodcast>);
      }

      if (items.first is InterviewData &&
          items.first.contentData != null &&
          items.first.contentData.cards != null &&
          items.first.contentData.cards.isNotEmpty) {
        List<MediaItem> firstLayerEpisodeList = [];
        // List<MediaItem> secondLayerEpisodeList = [];
        // List<MediaItem> carPlayEpisodeList = [];

        for (InterviewData e in items) {
          if (e.contentData.cards.isNotEmpty &&
              e.contentData.cards.first.audioFile != '') {
            MediaItem item = MediaItem(
                playable: true,
                duration:
                    Duration(seconds: e.contentData.cards.first.audioDuration!),
                id: apiBaseUrl + e.contentData.cards.first.audioFile!,
                artUri: Uri.parse(Singleton.instance.checkIsFoolUrl(e.image)),
                displaySubtitle: e.subtitle,
                artist: e.subtitle,
                title: e.title);
            firstLayerEpisodeList.add(item);

            // if (e.contentData.cards.isNotEmpty) {
            //   secondLayerEpisodeList = [];
            //   for (InterviewCard c in e.contentData.cards) {
            //     if (c.audioFile != '') {
            //       MediaItem cItem = MediaItem(
            //           playable: true,
            //           duration: Duration(seconds: c.audioDuration!),
            //           artUri: Uri.parse(apiBaseUrl + e.image),
            //           id: apiBaseUrl +  c.audioFile!,
            //           displaySubtitle: e.subtitle,
            //           title: e.title);
            //       secondLayerEpisodeList.add(cItem);
            //       carPlayEpisodeList.add(cItem);
            //     }
            //   }
            // }
            //mediaLibrary.baseItems[e.id.toString()] = secondLayerEpisodeList;
          }
        }
        mediaLibrary.baseItems[MediaLibrary.titleIdInterview] =
            firstLayerEpisodeList;
        _updateCarPlayInterviewList(firstLayerEpisodeList, '');
      }

      if (items.first is MainData) {
        List<MediaItem> mainRadioList = [];
        for (MainData mD in items) {
          MediaItem item = MediaItem(
              id: mD.streamLink,
              genre: 'MainData',
              //artist: 'Vasia',
              artUri:
                  Uri.parse(Singleton.instance.checkIsFoolUrl(mD.upperImage)),
              title: mD.name);
          mainRadioList.add(item);
        }
        mediaLibrary.baseItems[MediaLibrary.titleIdRadio] = mainRadioList;
        _updateCarPlayRadioList(mainRadioList, 0);
      }
    }
    // });
  }

  void playAllTypeMedia(
      List<dynamic> items, int indexToPlay, String title, String description,
      {bool manual = false}) {
    try {
      if (items.isNotEmpty) {
        if (items.first is MediaItem) {
          _playOrSeekForTypeMediaItem(
              items as List<MediaItem>, indexToPlay, title);
        } else {
          _playOrSeek(items, indexToPlay, title, description, manual: manual);
        }
      } else {
        CarPlayService.showMessage("items is Empty");
      }
    } catch (e) {
      print('Error playing media: $e');
      CarPlayService.showMessage('Error playing media: $e');
    }
    //checkMiniPlayerStatus();
  }

  void _playOrSeekForTypeMediaItem(
      List<MediaItem> items, int indexToPlay, String title) async {
    print('---------_audioPlayer $_audioPlayer');

    try {
      // await Singleton.instance.audioHandler.updateQueue(items);
      // await Singleton.instance.audioHandler.skipToQueueItem(indexToPlay);
      // await _audioPlayer.play();

      if (Singleton.instance.audioHandler.queue.value.isNotEmpty) {
        if (Singleton.instance.audioHandler.queue.value.first.id ==
            items.first.id) {
          await Singleton.instance.audioHandler.skipToQueueItem(indexToPlay);
          await _audioPlayer.play();
        } else {
          await Singleton.instance.audioHandler.updateQueue(items);
          await Singleton.instance.audioHandler.skipToQueueItem(indexToPlay);
        }
      } else {
        await Singleton.instance.audioHandler.updateQueue(items);
        await Singleton.instance.audioHandler.skipToQueueItem(indexToPlay);
        await _audioPlayer.play();
      }

      carPlayModule.updatePlayingStatusOnListItems(items[indexToPlay].title);
    } catch (e) {
      print('Error playing media: $e');
      CarPlayService.showMessage('Error playing media: $e');
    }
  }

  void _playOrSeek(
      List<dynamic> items, int indexToPlay, String title, String description,
      {bool manual = false}) async {
    indexInQueue = await _isMediaCurrentlyInQueue(items, indexToPlay);
    if (indexInQueue != -1) {
      await _audioPlayer.seek(Duration.zero, index: indexToPlay);
      _audioPlayer.play();
      carPlayModule.updatePlayingStatusOnListItems(items[indexToPlay].name,
          manual: manual);
      checkMiniPlayerStatus();
    } else {
      _audioPlayer.pause();
      _itemsBeforeInternetOff = items;
      itIsStream = false;
      bool typeOfElementIsDetected = false;
////////Episode////////
      if (items.first is Episode &&
          items.first.contentData != null &&
          items.first.contentData.cards != null &&
          items.first.contentData.cards.isNotEmpty) {
        //needToSeek = isEpisodeCurrentlyInQueue(items.first);
        typeOfElementIsDetected = true;
        List<MediaItem> episodeList = [];
        for (Episode e in items) {
          MediaItem item = MediaItem(
              id: apiBaseUrl + e.contentData.cards.first.audioFile,
              artUri: Uri.parse(Singleton.instance
                  .checkIsFoolUrl(e.contentData.cards.first.image)),
              displaySubtitle: title,
              genre: 'Episode',
              displayDescription:
                  description == '' ? e.description : description,
              title: e.title);
          episodeList.add(item);
        }
        await Singleton.instance.audioHandler.updateQueue(episodeList);
      }
////////MainData/////////
      if (items.first is MainData) {
        itIsStream = true;
        typeOfElementIsDetected = true;
        List<MediaItem> mainRadioList = [];
        _currentPlayNowUrl = items.first.playNowEndpoint;
        for (MainData mD in items) {
          MediaItem item = MediaItem(
              id: mD.streamLink,
              genre: 'MainData',
              artUri:
                  Uri.parse(Singleton.instance.checkIsFoolUrl(mD.upperImage)),
              title: mD.name);
          mainRadioList.add(item);
          currentStreamUrl = mD.streamLink;
        }
        mainPlaylist = mainRadioList;
        await Singleton.instance.audioHandler.updateQueue(mainRadioList);
      }
///////InterviewData///////
      if (items.first is InterviewData && items.first.contentData != null) {
        typeOfElementIsDetected = true;
        List<MediaItem> interviewDataList = [];
        for (InterviewData e in items) {
          if (e.contentData.cards.isNotEmpty) {
            for (var interviewCard in e.contentData.cards) {
              MediaItem item = MediaItem(
                  id: apiBaseUrl + interviewCard.audioFile!,
                  artUri: Uri.parse(Singleton.instance.checkIsFoolUrl(e.image)),
                  displaySubtitle: title,
                  displayDescription:
                      description == '' ? e.description : description,
                  title: e.title);
              interviewDataList.add(item);
            }
          }
        }
        await Singleton.instance.audioHandler.updateQueue(interviewDataList);
      }

      if (typeOfElementIsDetected) {
        try {
          carPlayModule.updatePlayingStatusOnListItems(items[indexToPlay].name);
        } catch (e) {}
        await _audioPlayer.seek(Duration.zero, index: indexToPlay);
        _audioPlayer.play();
        checkMiniPlayerStatus();
      }
    }
  }

  Future<int> _isMediaCurrentlyInQueue(
      List<dynamic> listOfMedia, int indexToPlay) async {
    var isMediaInList = false;
    int index = -1;
    if (listOfMedia.first is MainData) {
      MainData mData = listOfMedia.first;
      final queueList = Singleton.instance.audioHandler.queue.value;
      if (queueList.isNotEmpty && queueList.first.id != mData.streamLink) {
        return -1;
      }
    }
    for (var media in listOfMedia) {
      if (media is MainData) {
        index = Singleton.instance.audioHandler.queue.value
            .indexWhere((item) => item.id == media.streamLink);
        if (index != -1) {
          MainData data = listOfMedia[indexToPlay] as MainData;
          _currentPlayNowUrl = data.playNowEndpoint;
          break;
        }
      }
    }
    //int index = Singleton.instance.audioHandler.queue.value.indexWhere((item) => item.id == apiBaseUrl + episode.contentData.cards.first.audioFile);
    if (index != -1) {
      isMediaInList = true;
    }
    return index;
  }

  void _carPlayPlay({required ContentType type, required String name}) async {
    if (type == ContentType.mainRadio) {
      // List<MediaItem> radioList = mediaLibrary.baseItems['title_radio']!;

      List<MediaItem> radioList = mediaLibrary.baseItems['title_radio']!;

      if (radioList.isNotEmpty) {
        int indexToPlay = 0;
        for (var i = 0; i < radioList.length; i++) {
          final item = radioList[i];
          if (item.title == name) {
            indexToPlay = i;

            break;
          }
        }
        try {
          carouselSliderControllerAppBar.animateToPage(indexToPlay,
              duration: const Duration(milliseconds: 500));
        } catch (e) {
          print(e);
        }

        playAllTypeMedia(
            radioList, indexToPlay, radioList[indexToPlay].title, '');
      } else {
        CarPlayService.showMessage('Error playing media: radioList Not Found!');
      }

      // carouselSliderController.jumpToPage(indexToPlay);
      // var mainScreenProvider = Provider.of<MainScreenProvider>(context, listen: false);
      // mainScreenProvider.setCurrentDataIndex(indexToPlay);
      // if (radioList.length > 0) {
      //   playAllTypeMedia(
      //       radioList, indexToPlay, radioList[indexToPlay].title, '');
      // }
    }
    if (type == ContentType.podcast) {
      int indexToPlay = 0;
      List<MediaItem> podcastsToPlay = [];
      for (final mItems in mediaLibrary.baseItems.values) {
        for (var i = 0; i < mItems.length; i++) {
          final item = mItems[i];
          if (item.title == name) {
            indexToPlay = i;
            podcastsToPlay = mItems;
            break;
          }
        }
      }
      playAllTypeMedia(
          podcastsToPlay, indexToPlay, podcastsToPlay[indexToPlay].title, '');
    }
    if (type == ContentType.interview) {
      List<MediaItem> interviewList =
          mediaLibrary.baseItems[MediaLibrary.titleIdInterview]!;
      int indexToPlay = 0;
      for (var i = 0; i < interviewList.length; i++) {
        final item = interviewList[i];
        if (item.title == name) {
          indexToPlay = i;
          break;
        }
      }
      playAllTypeMedia(interviewList, indexToPlay, '', '');
    }
  }

  //var test = 0;
  Future<void> getPlayNowData(String url) async {
    if (_isInternetAvailable == true) {
      ApiHelper helper = ApiHelper();
      String languageCode =
          Singleton.instance.getLanguageCodeFromSharedPreferences();
      final response = await helper.getWithoutBaseUrl(url, {});
      if (response != null && response.statusCode == 200) {
        var errorTest = jsonDecode(response.body);
        if (errorTest['error'] != null) {
          getPlayNowDataResponseState = ResponseState.stateError;
          notifyListeners();
        } else {
          final playNow = playNowDataFromJson(response.body);
          //test = test + 1;
          itemIsChanged = false;
          playNowMediaItem = MediaItem(
            id: currentStreamUrl,
            album: playNow.songArtist,
            title: playNow.songTitle,
            displaySubtitle: playNow.songArtist,
            artist: playNow.songArtist,
            artUri: Uri.parse(playNow.artworkPath),
          );
          Singleton.instance.audioHandler.updateMediaItem(playNowMediaItem!);
          notifyListeners();
        }
      }
    }
  }

/////////Car Play///////////
  Future<void> setupCarPlay(BuildContext context) async {
    carPlayModule = CarPlayModule();
    carPlayModule.setupCarPlay(context);
  }

  void _updateCarPlayRadioList(List<MediaItem> listToUpdate, int indexToPlay) {
    if (Platform.isIOS) {
      carPlayModule.updateRadioList(listToUpdate, indexToPlay,
          onRadioItemTap: (songName) {
        _carPlayPlay(type: ContentType.mainRadio, name: songName);
      });
    }
  }

  void _updateCarPlayAudioPodcastsList(List<AudioPodcast> listToUpdate) {
    if (Platform.isIOS) {
      carPlayModule.updateAudioPodcastsList(listToUpdate,
          onPodcastsTap: (String name) {
        _carPlayPlay(type: ContentType.podcast, name: name);
      });
    }
  }

  void _updateCarPlayInterviewList(
      List<MediaItem> listToUpdate, String nameToPlay) {
    if (Platform.isIOS) {
      carPlayModule.updateInterviewList(listToUpdate,
          onInterviewItemTap: (String name) {
        _carPlayPlay(type: ContentType.interview, name: name);
      });
    }
  }
}
