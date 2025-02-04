import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_carplay/flutter_carplay.dart';
import 'package:provider/provider.dart';
import 'package:radio_skonto/helpers/constant.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/models/podcasts_model.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:radio_skonto/providers/main_screen_provider.dart';
import 'package:radio_skonto/providers/player_provider.dart';
import 'package:radio_skonto/providers/podcasts_provider.dart';

class CarPlayModule {
  List<CPListSection> _radioListItems = [];
  List<CPListSection> _audioPodcastsListISections = [];
  List<CPListSection> _interviewListItems = [];
  List<CPListSection> _favItems = [];
  Map<String, List<CPListItem>> _audioFiles = {};
  final FlutterCarplay _flutterCarplay = FlutterCarplay();
  CPConnectionStatusTypes _carPlayConnectionStatus =
      CPConnectionStatusTypes.unknown;
  //late final BuildContext testContext;
  String _lastOpenPodcastId = '';
  BuildContext? testContext;

  void initSetupCarPlay() {
    print('isIOS-------------------${Platform.isIOS}');
    if (Platform.isIOS) {
      _favItems.add(CPListSection(
        items: [
          CPListItem(
            text: "Coming Soon",
            detailText: "This Feature under development!",
            // onPress: (complete, self) {
            //   self.setDetailText("Please wait for the moment.. 🚀");
            //   self.setAccessoryType(CPListItemAccessoryTypes.cloud);
            //   Future.delayed(const Duration(seconds: 1), () {
            //     self.setDetailText("Please wait for the moment");
            //     complete();
            //   });
            // },
            image: 'assets/logo_flutter_1080px_clr.png',
          )
        ],
        header: "Favorites",
      ));

      FlutterCarplay.setRootTemplate(
        rootTemplate: CPTabBarTemplate(
          templates: [
            CPListTemplate(
              sections: _radioListItems,
              emptyViewTitleVariants: [
                Singleton.instance.translate('loading_car_play')
              ],
              title: Singleton.instance.translate('radio'),
              showsTabBadge: false,
              systemIcon: "house.fill",
            ),
            CPListTemplate(
              sections: _audioPodcastsListISections,
              emptyViewTitleVariants: [
                Singleton.instance.translate('loading_car_play')
              ],
              title: Singleton.instance.translate('audio_podcasts'),
              showsTabBadge: false,
              systemIcon: "music.note.list",
            ),
            CPListTemplate(
              sections: _interviewListItems,
              title: Singleton.instance.translate('interviews'),
              emptyViewTitleVariants: [
                Singleton.instance.translate('loading_car_play')
              ],
              showsTabBadge: false,
              systemIcon: "music.mic",
            ),
            CPListTemplate(
              sections: _favItems,
              title: Singleton.instance.translate('favorites_title'),
              emptyViewTitleVariants: [
                Singleton.instance.translate('loading_car_play')
              ],
              showsTabBadge: false,
              systemIcon: "star.fill",
            ),
          ],
        ),
        animated: true,
      );
      _flutterCarplay.forceUpdateRootTemplate();

      _flutterCarplay.addListenerOnConnectionChange(onCarplayConnectionChange);
    }
  }

  void setupCarPlay(BuildContext context) {
    if (Platform.isIOS) {
      testContext = context;
      _flutterCarplay.addListenerOnConnectionChange(onCarplayConnectionChange);

      _radioListItems.add(CPListSection(
        items: [
          // CPListItem(
          //   text: "Item 1",
          //   detailText: "Detail Text",
          //   onPress: (complete, self) {
          //     self.setDetailText("You can change the detail text.. 🚀");
          //     self.setAccessoryType(CPListItemAccessoryTypes.cloud);
          //     Future.delayed(const Duration(seconds: 1), () {
          //       self.setDetailText("Customizable Detail Text");
          //       complete();
          //     });
          //   },
          //   image: 'assets/logo_flutter_1080px_clr.png',
          // )
        ],
        header: "First Section",
      ));

      FlutterCarplay.setRootTemplate(
        rootTemplate: CPTabBarTemplate(
          templates: [
            CPListTemplate(
              sections: _radioListItems,
              emptyViewTitleVariants: [
                Singleton.instance.translate('loading_car_play')
              ],
              title: Singleton.instance.translate('radio'),
              showsTabBadge: false,
              systemIcon: "house.fill",
            ),
            CPListTemplate(
              sections: _audioPodcastsListISections,
              emptyViewTitleVariants: [
                Singleton.instance.translate('loading_car_play')
              ],
              title: Singleton.instance.translate('audio_podcasts'),
              showsTabBadge: false,
              systemIcon: "music.note.list",
            ),
            CPListTemplate(
              sections: _interviewListItems,
              title: Singleton.instance.translate('interviews'),
              emptyViewTitleVariants: [
                Singleton.instance.translate('loading_car_play')
              ],
              showsTabBadge: false,
              systemIcon: "music.mic",
            ),
            CPListTemplate(
              sections: [],
              title: Singleton.instance.translate('favorites_title'),
              emptyViewTitleVariants: [
                Singleton.instance.translate('loading_car_play')
              ],
              showsTabBadge: false,
              systemIcon: "star.fill",
            ),
          ],
        ),
        animated: true,
      );
      _flutterCarplay.forceUpdateRootTemplate();
    }
    //FlutterCarplay.showSharedNowPlaying(animated: false);
    // _flutterCarplay.forceUpdateRootTemplate();
    //FlutterCarplay().forceUpdateRootTemplate();
  }

  void updatePlayingStatusOnListItems(String name,
      {bool manual = false}) async {
    // закнчил на том, что нужно изменить метод в Нативном приложении чтобы Плей Ноу открывалось только один раз
    // А дальше нужно найти способ запуска КарПлей без раздрвоения
    if (Platform.isIOS) {
      if (!manual) {
        Future.delayed(Duration.zero, () {
          FlutterCarplay.showSharedNowPlaying(animated: false);
        });
      }
      try {
        var currentRootTemplate = FlutterCarplay.rootTemplate!;
        for (final template in currentRootTemplate.templates) {
          if (template.sections != null && template.sections.isNotEmpty
              // &&
              // template.sections.first.items != null &&
              // template.sections.first.items.isNotEmpty
              ) {
            final sections = template.sections;
            for (final section in sections) {
              if (section.items.isNotEmpty) {
                final cpListItems = section.items;
                if (cpListItems.first is CPListItem) {
                  for (CPListItem it in cpListItems) {
                    if (name == it.text || name == it.detailText) {
                      it.setIsPlaying(true);
                    } else {
                      it.setIsPlaying(false);
                    }
                    //it.setIsPlaying(name == it.text || name == it.detailText ? true : false);
                  }
                }
              }
            }
          }
        }
        for (final audioFiles in _audioFiles.values) {
          for (CPListItem cpItem in audioFiles) {
            if (name == cpItem.text || name == cpItem.detailText) {
              cpItem.setIsPlaying(true);
            } else {
              cpItem.setIsPlaying(false);
            }
          }
        }
      } catch (e) {
        print(e);
      }
    }
  }

  void updateRadioList(List<MediaItem> mainDataList, int indexToPlay,
      {required final Function(String) onRadioItemTap}) async {
    if (Platform.isIOS) {
      var currentRootTemplate = FlutterCarplay.rootTemplate!;

      _radioListItems = [];
      List<CPListItem> itemsList = [];
      int index = 0;
      for (MediaItem mD in mainDataList) {
        String imageUrl =
            'http:/skonto2.mediaresearch.lv/uploads/LOGO/lounge.png';
        if (mD.artUri != null && _isImageLink(mD.artUri.toString())) {
          imageUrl = mD.artUri.toString().contains('http')
              ? mD.artUri.toString()
              : apiBaseUrl + mD.artUri.toString();
        }
        var item = CPListItem(
            text: mD.title,
            isPlaying: index == indexToPlay ? true : null,
            accessoryType: CPListItemAccessoryTypes.none,
            //playbackProgress: index == indexToPlay ? 0.5 : null,
            playingIndicatorLocation:
                CPListItemPlayingIndicatorLocations.trailing,
            detailText: mD.artist,
            onPress: (complete, self) {
              complete();
              onRadioItemTap(self.text);
            },
            image: imageUrl);
        index++;
        itemsList.add(item);
      }
      _radioListItems = [CPListSection(items: itemsList)];
      var radioTemplates = CPListTemplate(
        sections: _radioListItems,
        title: Singleton.instance.translate('radio'),
        emptyViewTitleVariants: [
          Singleton.instance.translate('loading_car_play')
        ],
        systemIcon: "house.fill",
      );
      currentRootTemplate.templates.first = radioTemplates;

      _interviewListItems.first.items.first.setIsPlaying(true);

      FlutterCarplay.setRootTemplate(
        rootTemplate: currentRootTemplate,
        animated: true,
      );
      _flutterCarplay.forceUpdateRootTemplate();
    }
  }

  void updateAudioPodcastsList(List<AudioPodcast> audioPodcastsList,
      {required final Function(String name) onPodcastsTap}) {
    if (Platform.isIOS) {
      var currentRootTemplate = FlutterCarplay.rootTemplate!;
      _audioPodcastsListISections = [];
      for (AudioPodcast aP in audioPodcastsList) {
        List<CPListItem> podcastsList = [];
        if (aP.podcasts != null && aP.podcasts!.isNotEmpty) {
          for (var podcast in aP.podcasts!) {
            String podcastImageUrl =
                'https://farm4.staticflickr.com/3224/3081748027_0ee3d59fea_z_d.jpg';
            if (podcast.image != '' && _isImageLink(podcast.image)) {
              podcastImageUrl = podcast.image.contains('http')
                  ? podcast.image
                  : apiBaseUrl + podcast.image;
            }
            var item = CPListItem(
              text: podcast.title,
              image: podcastImageUrl,
              isPlaying: false,
              accessoryType: CPListItemAccessoryTypes.none,
              playingIndicatorLocation:
                  CPListItemPlayingIndicatorLocations.trailing,
              detailText: podcast.description,
              onPress: (complete, self) {
                if (_audioFiles[self.uniqueId] != null) {
                  _lastOpenPodcastId = self.uniqueId;
                  openListOfEpisodes(_audioFiles[self.uniqueId]!,
                      onPodcastsItemTap: (String name) {
                    // onPodcastsTap(name);
                  });
                }
              },
            );
            //podcastsList.add(item);
            if (podcast.episodes.isNotEmpty) {
              List<CPListItem> mediaFilesList = [];
              for (var episode in podcast.episodes) {
                String imageUrl =
                    'https://farm4.staticflickr.com/3224/3081748027_0ee3d59fea_z_d.jpg';
                if (episode.contentData.cards.first.image != null &&
                    _isImageLink(episode.contentData.cards.first.image)) {
                  imageUrl =
                      episode.contentData.cards.first.image.contains('http')
                          ? episode.contentData.cards.first.image
                          : apiBaseUrl + episode.contentData.cards.first.image;
                }
                mediaFilesList.add(CPListItem(
                  text: episode.title,
                  image: imageUrl,
                  accessoryType: CPListItemAccessoryTypes.none,
                  playingIndicatorLocation:
                      CPListItemPlayingIndicatorLocations.trailing,
                  detailText: episode.description,
                  onPress: (complete, self) {
                    FlutterCarplay.pop(animated: false);
                    onPodcastsTap(self.text);
                    //FlutterCarplay.showSharedNowPlaying(animated: false);
                    if (_audioFiles[_lastOpenPodcastId] != null) {
                      openListOfEpisodes(_audioFiles[_lastOpenPodcastId]!,
                          onPodcastsItemTap: (String name) {
                        // onPodcastsTap(name);
                      });
                    }
                  },
                ));
              }
              _audioFiles[item.uniqueId] = mediaFilesList;
              if (mediaFilesList.isNotEmpty) {
                podcastsList.add(item);
              }
            }
          }
        }
        _audioPodcastsListISections
            .add(CPListSection(header: aP.name, items: podcastsList));
      }

      var audioPodcastsTemplates = CPListTemplate(
        sections: _audioPodcastsListISections,
        title: Singleton.instance.translate('audio_podcasts'),
        systemIcon: "music.note.list",
      );
      currentRootTemplate.templates[1] = audioPodcastsTemplates;

      FlutterCarplay.setRootTemplate(
        rootTemplate: currentRootTemplate,
        animated: false,
      );
      _flutterCarplay.forceUpdateRootTemplate();
    }
  }

  void openListOfEpisodes(List<CPListItem> list,
      {required final Function(String name) onPodcastsItemTap}) {
    if (Platform.isIOS) {
      FlutterCarplay.push(
        template: CPListTemplate(
          sections: [
            CPListSection(
              header: "",
              items: list,
            ),
          ],
          systemIcon: "systemIcon",
          title: "",
          backButton: CPBarButton(
            title: "Back",
            style: CPBarButtonStyles.none,
            onPress: () {
              FlutterCarplay.pop(animated: true);
            },
          ),
        ),
        animated: false,
      );
    }
  }

  void updateInterviewList(List<MediaItem> interviewList,
      {required final Function(String name) onInterviewItemTap}) {
    if (Platform.isIOS) {
      var currentRootTemplate = FlutterCarplay.rootTemplate!;

      _interviewListItems = [];
      List<CPListItem> itemsList = [];
      for (MediaItem interview in interviewList) {
        String interviewImageUrl =
            'https://farm4.staticflickr.com/3224/3081748027_0ee3d59fea_z_d.jpg';
        if (interview.artUri != null &&
            interview.artUri.toString() != '' &&
            _isImageLink(interview.artUri.toString())) {
          interviewImageUrl = interview.artUri.toString().contains('http')
              ? interview.artUri.toString()
              : apiBaseUrl + interview.artUri.toString();
        }
        itemsList.add(CPListItem(
          image: interviewImageUrl,
          text: interview.title,
          detailText: interview.displaySubtitle,
          accessoryType: CPListItemAccessoryTypes.none,
          playingIndicatorLocation:
              CPListItemPlayingIndicatorLocations.trailing,
          onPress: (complete, self) {
            //self.isPlaying = true;
            complete();
            onInterviewItemTap(self.text);
          },
        ));
      }
      _interviewListItems.add(CPListSection(items: itemsList));

      var interviewTemplates = CPListTemplate(
        sections: _interviewListItems,
        title: Singleton.instance.translate('interviews'),
        systemIcon: "music.mic",
      );
      currentRootTemplate.templates[2] = interviewTemplates;

      FlutterCarplay.setRootTemplate(
        rootTemplate: currentRootTemplate,
        animated: true,
      );
      _flutterCarplay.forceUpdateRootTemplate();
    }
  }

  void setNoInternetItemsCarPlay() {
    if (Platform.isIOS) {
      FlutterCarplay.setRootTemplate(
        rootTemplate: CPTabBarTemplate(
          templates: [
            CPListTemplate(
              sections: [
                CPListSection(
                  items: [],
                )
              ],
              emptyViewTitleVariants: [
                Singleton.instance.translate('no_internet_connection')
              ],
              title: Singleton.instance.translate('radio'),
              showsTabBadge: false,
              systemIcon: "house.fill",
            ),
            CPListTemplate(
              sections: [],
              emptyViewTitleVariants: [
                Singleton.instance.translate('no_internet_connection')
              ],
              title: Singleton.instance.translate('audio_podcasts'),
              showsTabBadge: false,
              systemIcon: "music.note.list",
            ),
            CPListTemplate(
              sections: [],
              title: Singleton.instance.translate('interviews'),
              emptyViewTitleVariants: [
                Singleton.instance.translate('no_internet_connection')
              ],
              showsTabBadge: false,
              systemIcon: "music.mic",
            ),
            CPListTemplate(
              sections: [],
              title: Singleton.instance.translate('favorites_title'),
              emptyViewTitleVariants: [
                Singleton.instance.translate('no_internet_connection')
              ],
              showsTabBadge: false,
              systemIcon: "star.fill",
            ),
          ],
        ),
        animated: true,
      );
      _flutterCarplay.forceUpdateRootTemplate();
    }
  }

  void setInternetConnectionRestoredItemsCarPlay() {
    if (Platform.isIOS) {
      FlutterCarplay.setRootTemplate(
        rootTemplate: CPTabBarTemplate(
          templates: [
            CPListTemplate(
              sections: _radioListItems,
              emptyViewTitleVariants: [
                Singleton.instance.translate('loading_car_play')
              ],
              title: Singleton.instance.translate('radio'),
              showsTabBadge: false,
              systemIcon: "house.fill",
            ),
            CPListTemplate(
              sections: _audioPodcastsListISections,
              emptyViewTitleVariants: [
                Singleton.instance.translate('loading_car_play')
              ],
              title: Singleton.instance.translate('audio_podcasts'),
              showsTabBadge: false,
              systemIcon: "music.note.list",
            ),
            CPListTemplate(
              sections: _interviewListItems,
              title: Singleton.instance.translate('interviews'),
              emptyViewTitleVariants: [
                Singleton.instance.translate('loading_car_play')
              ],
              showsTabBadge: false,
              systemIcon: "music.mic",
            ),
            CPListTemplate(
              sections: [],
              title: Singleton.instance.translate('favorites_title'),
              emptyViewTitleVariants: [
                Singleton.instance.translate('loading_car_play')
              ],
              showsTabBadge: false,
              systemIcon: "star.fill",
            ),
          ],
        ),
        animated: true,
      );
      _flutterCarplay.forceUpdateRootTemplate();
    }
  }

  // Future<String> saveImageToLocalDirectory(String imageUrl) async {
  //
  //   var f = await DefaultCacheManager().getSingleFile(imageUrl);
  //
  //   return f.path;
  //
  //   // var test = CachedNetworkImageProvider(imageUrl);
  //   // return test.url;
  //
  //   // var response = await http.get(Uri.parse(imageUrl));
  //   // Directory documentDirectory = await getApplicationDocumentsDirectory();
  //   // File file = new File(join(documentDirectory.path, 'imagetest.png'));
  //   // file.writeAsBytesSync(response.bodyBytes);
  //
  //
  //   // try {
  //   //   var imageId = await ImageDownloader.downloadImage(imageUrl);
  //   //   if (imageId == null) {
  //   //     return '';
  //   //   }
  //   //   var fileName = await ImageDownloader.findName(imageId);
  //   //   var path = await ImageDownloader.findPath(imageId);
  //   //   return path?? '';
  //   //   var size = await ImageDownloader.findByteSize(imageId);
  //   //   var mimeType = await ImageDownloader.findMimeType(imageId);
  //   // } on PlatformException catch (error) {
  //   //   print(error);
  //   //   return '';
  //   // }
  // }

  void onCarplayConnectionChange(CPConnectionStatusTypes status) {
    if (status == CPConnectionStatusTypes.connected
        // && Singleton.instance.needInitCarPlayWithoutRunApp == true
        ) {
      // Singleton.instance.needInitCarPlayWithoutRunApp = false;
      if (testContext != null) {
        Singleton.instance.firstInitPlayerAndLoadData(testContext!);
        //setupCarPlay(testContext!);
      }
    }
    _flutterCarplay.forceUpdateRootTemplate();
  }

  bool _isImageLink(String link) {
    bool isImage = false;
    if (link.contains('jpg') || link.contains('png')) {
      isImage = true;
    }
    return isImage;
  }
}

//Для правильной работы CarPlal нужно подменить этот метод в файле FlutterCarPlaySceneDelegate.swift
//Если этого не сделать, то при открытии PlayNow второй раз, приложение крашится.
// static public func push(template: CPTemplate, animated: Bool) {
// if (self.interfaceController?.templates.count ?? 1 < 2) {
// self.interfaceController?.pushTemplate(template, animated: animated)
// }
// //self.interfaceController?.pushTemplate(template, animated: animated)
// }
