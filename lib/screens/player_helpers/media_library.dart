import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:radio_skonto/helpers/singleton.dart';

class MediaLibrary {

  static const titleIdRadio = 'title_radio';
  static const titleIdPodcasts = 'title_podcasts_audio';
  static const titleIdInterview = 'title_podcasts_interview';
  static const titleIdFavorites = 'title_favorites';

  //https://dev.w3.org/SVG/tools/svgweb/samples/svg-files/android.svg

  // final items = <String, List<MediaItem>>{
  //   AudioService.browsableRootId: [
  //     MediaItem(
  //       id: albumsRootId,
  //       title: "Title 1",
  //       artUri: Uri.parse(
  //           'content://assets/icons/heart_icon.svg'),
  //       playable: false,
  //       extras: {
  //         //AndroidContentStyle.categoryGridItemHintValue : 1,
  //         AndroidContentStyle.supportedKey: true,
  //         AndroidContentStyle.browsableHintKey: AndroidContentStyle
  //             .categoryGridItemHintValue,
  //         AndroidContentStyle.playableHintKey: AndroidContentStyle
  //             .categoryListItemHintValue,
  //       }
  //     ),
  //     MediaItem(
  //       id: albumsRootId2,
  //       title: "Title 2",
  //       playable: false,
  //         artUri: Uri.parse(
  //             'content://assets/icons/heart_icon.svg'),
  //         extras: {
  //           //AndroidContentStyle.categoryGridItemHintValue : 1,
  //           AndroidContentStyle.supportedKey: true,
  //           AndroidContentStyle.browsableHintKey: AndroidContentStyle
  //               .categoryGridItemHintValue,
  //           AndroidContentStyle.playableHintKey: AndroidContentStyle
  //               .categoryListItemHintValue,
  //         }
  //     ),
  //   ],
  //   albumsRootId: [
  //     MediaItem(
  //       id: 'https://stream.radiotev.lv:8443/radiov',
  //       album: "Radio",
  //       title: "CEĻĀ UZ MĀJĀM",
  //       artist: "Rūdolfs Golubovs un Mārtiņš Ķibilds",
  //       //duration: const Duration(milliseconds: 5739820),
  //       artUri: Uri.parse(
  //           'https://farm4.staticflickr.com/3224/3081748027_0ee3d59fea_z_d.jpg'),
  //     ),
  //     MediaItem(
  //       id: 'https://s3.amazonaws.com/scifri-segments/scifri201711241.mp3',
  //       album: "Album 1",
  //       title: "Title 2",
  //       artist: "Artist 2",
  //       //duration: const Duration(milliseconds: 2856950),
  //       artUri: Uri.parse(
  //           'https://farm4.staticflickr.com/3224/3081748027_0ee3d59fea_z_d.jpg'),
  //     ),
  //     MediaItem(
  //       id: 'https://s3.amazonaws.com/scifri-segments/scifri202011274.mp3',
  //       album: "Album 1",
  //       title: "Title 3",
  //       artist: "Artist 3",
  //       //duration: const Duration(milliseconds: 1791883),
  //       artUri: Uri.parse(
  //           'https://farm4.staticflickr.com/3224/3081748027_0ee3d59fea_z_d.jpg'),
  //     ),
  //   ],
  // };

  var baseItems =<String, List<MediaItem>> {
    AudioService.browsableRootId: [
      MediaItem(
          id: titleIdRadio,
          title: Singleton.instance.translate('radio'),
          artUri: Uri.parse(
              'file:///data/user/0/com.radio.skonto.radio_skonto/app_flutter/file_01.svg'),
          playable: false,
          extras: {
            //AndroidContentStyle.categoryGridItemHintValue : 1,
            AndroidContentStyle.supportedKey: true,
            AndroidContentStyle.browsableHintKey: AndroidContentStyle
                .categoryListItemHintValue,
            AndroidContentStyle.playableHintKey: AndroidContentStyle
                .categoryListItemHintValue,
            'url':'file:///data/user/0/com.radio.skonto.radio_skonto/app_flutter/file_01.svg'
          }
      ),
      MediaItem(
          id: titleIdPodcasts,
          title: Singleton.instance.translate('audio_podcasts'),
          playable: false,
          artUri: Uri.parse(
              'content://assets/icons/heart_icon.svg'),
          extras: {
            //AndroidContentStyle.categoryGridItemHintValue : 1,
            AndroidContentStyle.supportedKey: true,
            AndroidContentStyle.browsableHintKey: AndroidContentStyle
                .categoryListItemHintValue,
            AndroidContentStyle.playableHintKey: AndroidContentStyle
                .categoryListItemHintValue,
          }
      ),
      MediaItem(
          id: titleIdInterview,
          title: Singleton.instance.translate('interviews'),
          artUri: Uri.parse(
              'content://assets/icons/heart_icon.svg'),
          playable: false,
          extras: {
            //AndroidContentStyle.categoryGridItemHintValue : 1,
            AndroidContentStyle.supportedKey: true,
            AndroidContentStyle.browsableHintKey: AndroidContentStyle
                .categoryListItemHintValue,
            AndroidContentStyle.playableHintKey: AndroidContentStyle
                .categoryListItemHintValue,
          }
      ),
      MediaItem(
          id: titleIdFavorites,
          title: Singleton.instance.translate('favorites_title'),
          artUri: Uri.parse(
              'content://assets/icons/heart_icon.svg'),
          playable: false,
          extras: {
            //AndroidContentStyle.categoryGridItemHintValue : 1,
            AndroidContentStyle.supportedKey: true,
            AndroidContentStyle.browsableHintKey: AndroidContentStyle
                .categoryListItemHintValue,
            AndroidContentStyle.playableHintKey: AndroidContentStyle
                .categoryListItemHintValue,
          }
      ),
    ],
    titleIdRadio: [
    ],
  };

  final noInternetItems = <String, List<MediaItem>>{
    AudioService.browsableRootId: [
      MediaItem(
          id: titleIdRadio,
          title: Singleton.instance.translate('radio'),
          artUri: Uri.parse(
              'file:///data/user/0/com.radio.skonto.radio_skonto/app_flutter/file_01.svg'),
          playable: false,
          extras: {
            //AndroidContentStyle.categoryGridItemHintValue : 1,
            AndroidContentStyle.supportedKey: true,
            AndroidContentStyle.browsableHintKey: AndroidContentStyle
                .categoryListItemHintValue,
            AndroidContentStyle.playableHintKey: AndroidContentStyle
                .categoryListItemHintValue,
          }
      ),
      MediaItem(
          id: titleIdPodcasts,
          title: Singleton.instance.translate('audio_podcasts'),
          playable: false,
          artUri: Uri.parse(
              'content://assets/icons/heart_icon.svg'),
          extras: {
            //AndroidContentStyle.categoryGridItemHintValue : 1,
            AndroidContentStyle.supportedKey: true,
            AndroidContentStyle.browsableHintKey: AndroidContentStyle
                .categoryListItemHintValue,
            AndroidContentStyle.playableHintKey: AndroidContentStyle
                .categoryListItemHintValue,
          }
      ),
      MediaItem(
          id: titleIdInterview,
          title: Singleton.instance.translate('interviews'),
          artUri: Uri.parse(
              'content://assets/icons/heart_icon.svg'),
          playable: false,
          extras: {
            //AndroidContentStyle.categoryGridItemHintValue : 1,
            AndroidContentStyle.supportedKey: true,
            AndroidContentStyle.browsableHintKey: AndroidContentStyle
                .categoryListItemHintValue,
            AndroidContentStyle.playableHintKey: AndroidContentStyle
                .categoryListItemHintValue,
          }
      ),
      MediaItem(
          id: titleIdFavorites,
          title: Singleton.instance.translate('favorites_title'),
          artUri: Uri.parse(
              'content://assets/icons/heart_icon.svg'),
          playable: false,
          extras: {
            //AndroidContentStyle.categoryGridItemHintValue : 1,
            AndroidContentStyle.supportedKey: true,
            AndroidContentStyle.browsableHintKey: AndroidContentStyle
                .categoryListItemHintValue,
            AndroidContentStyle.playableHintKey: AndroidContentStyle
                .categoryListItemHintValue,
          }
      ),
    ],
    titleIdRadio: [
      MediaItem(
        id: 'no_internet_1',
        title: Singleton.instance.translate('no_internet_connection'),
      )
    ],
    titleIdPodcasts: [
      MediaItem(
        id: 'no_internet_2',
        title: Singleton.instance.translate('no_internet_connection'),
      )
    ],
    titleIdInterview: [
      MediaItem(
        id: 'no_internet_3',
        title: Singleton.instance.translate('no_internet_connection'),
      )
    ],
    titleIdFavorites: [
      MediaItem(
        id: 'no_internet_4',
        title: Singleton.instance.translate('no_internet_connection'),
      )
    ],
  };

  // final baseItems = <String, List<MediaItem>>{
  //   AudioService.browsableRootId: [
  //     MediaItem(
  //         id: titleIdRadio,
  //         title: Singleton.instance.translate('radio'),
  //         artUri: Uri.parse(
  //             'content://assets/icons/heart_icon.svg'),
  //         playable: false,
  //         // extras: {
  //         //   //AndroidContentStyle.categoryGridItemHintValue : 1,
  //         //   AndroidContentStyle.supportedKey: true,
  //         //   AndroidContentStyle.browsableHintKey: AndroidContentStyle
  //         //       .categoryGridItemHintValue,
  //         //   AndroidContentStyle.playableHintKey: AndroidContentStyle
  //         //       .categoryListItemHintValue,
  //         // }
  //     ),
  //     MediaItem(
  //         id: titleIdAudio,
  //         title: Singleton.instance.translate('audio_podcasts'),
  //         playable: false,
  //         artUri: Uri.parse(
  //             'content://assets/icons/heart_icon.svg'),
  //         extras: {
  //           //AndroidContentStyle.categoryGridItemHintValue : 1,
  //           AndroidContentStyle.supportedKey: true,
  //           AndroidContentStyle.browsableHintKey: AndroidContentStyle
  //               .categoryGridItemHintValue,
  //           AndroidContentStyle.playableHintKey: AndroidContentStyle
  //               .categoryListItemHintValue,
  //         }
  //     ),
  //     MediaItem(
  //         id: titleIdInterview,
  //         title: Singleton.instance.translate('interviews'),
  //         artUri: Uri.parse(
  //             'content://assets/icons/heart_icon.svg'),
  //         playable: false,
  //         extras: {
  //           //AndroidContentStyle.categoryGridItemHintValue : 1,
  //           AndroidContentStyle.supportedKey: true,
  //           AndroidContentStyle.browsableHintKey: AndroidContentStyle
  //               .categoryGridItemHintValue,
  //           AndroidContentStyle.playableHintKey: AndroidContentStyle
  //               .categoryListItemHintValue,
  //         }
  //     ),
  //     MediaItem(
  //         id: titleIdFavorites,
  //         title: Singleton.instance.translate('favorites_title'),
  //         artUri: Uri.parse(
  //             'content://assets/icons/heart_icon.svg'),
  //         playable: false,
  //         extras: {
  //           //AndroidContentStyle.categoryGridItemHintValue : 1,
  //           AndroidContentStyle.supportedKey: true,
  //           AndroidContentStyle.browsableHintKey: AndroidContentStyle
  //               .categoryGridItemHintValue,
  //           AndroidContentStyle.playableHintKey: AndroidContentStyle
  //               .categoryListItemHintValue,
  //         }
  //     ),
  //   ],
  //   titleIdRadio: [
  //     MediaItem(
  //       playable: false,
  //       id: 'leavel2',
  //       //album: "VVVVV",
  //       title: "Recomendation",
  //       //artist: "AAAAAAA",
  //       //duration: const Duration(milliseconds: 5739820),
  //       // artUri: Uri.parse(
  //       //     'https://farm4.staticflickr.com/3224/3081748027_0ee3d59fea_z_d.jpg'),
  //     )
  //   ],
  //   'leavel2': [
  //     MediaItem(
  //       id: 'test',
  //       playable: false,
  //       //album: "kjkjhk",
  //       title: "R1",
  //       //artist: "ART Art Art",
  //       //duration: const Duration(milliseconds: 5739820),
  //       artUri: Uri.parse(
  //           'https://farm4.staticflickr.com/3224/3081748027_0ee3d59fea_z_d.jpg'),
  //     ),
  //     MediaItem(
  //       id: 'test',
  //       playable: false,
  //       // album: "Album 1",
  //       title: "R2",
  //       // artist: "Artist 2",
  //       //duration: const Duration(milliseconds: 2856950),
  //       artUri: Uri.parse(
  //           'https://farm4.staticflickr.com/3224/3081748027_0ee3d59fea_z_d.jpg'),
  //     ),
  //     MediaItem(
  //       id: 'test',
  //       playable: false,
  //       //album: "Album 1",
  //       title: "R3",
  //      // artist: "Artist 3",
  //       //duration: const Duration(milliseconds: 1791883),
  //       artUri: Uri.parse(
  //           'https://farm4.staticflickr.com/3224/3081748027_0ee3d59fea_z_d.jpg'),
  //     ),
  //   ],
  //   'test': [
  //     MediaItem(
  //       id: 'https://stream.radiotev.lv:8443/radiov',
  //       playable: true,
  //       //album: "kjkjhk",
  //       title: "TTTTTTTTT",
  //       artist: "ART Art Art",
  //       //duration: const Duration(milliseconds: 5739820),
  //       artUri: Uri.parse(
  //           'https://farm4.staticflickr.com/3224/3081748027_0ee3d59fea_z_d.jpg'),
  //     ),
  //     MediaItem(
  //       id: 'https://s3.amazonaws.com/scifri-segments/scifri201711241.mp3',
  //       album: "Album 1",
  //       title: "Title 2",
  //       artist: "Artist 2",
  //       //duration: const Duration(milliseconds: 2856950),
  //       artUri: Uri.parse(
  //           'https://farm4.staticflickr.com/3224/3081748027_0ee3d59fea_z_d.jpg'),
  //     ),
  //     MediaItem(
  //       id: 'https://s3.amazonaws.com/scifri-segments/scifri202011274.mp3',
  //       album: "Album 1",
  //       title: "Title 3",
  //       artist: "Artist 3",
  //       //duration: const Duration(milliseconds: 1791883),
  //       artUri: Uri.parse(
  //           'https://farm4.staticflickr.com/3224/3081748027_0ee3d59fea_z_d.jpg'),
  //     ),
  //   ],
  // };
}