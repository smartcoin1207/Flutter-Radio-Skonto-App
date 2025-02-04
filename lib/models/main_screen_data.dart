import 'dart:convert';
import 'package:radio_skonto/models/interview_model.dart';
import 'package:radio_skonto/models/podcasts_model.dart';

MainScreenData mainScreenDataFromJson(String str) => MainScreenData.fromJson(json.decode(str));
MainData singleMainScreenDataFromJson(Map<String, dynamic> json) => MainData.fromJson(json);

class MainScreenData {
  String apiVersion;
  List<AdBanner> banners;
  List<MainData> data;

  MainScreenData({
    required this.apiVersion,
    required this.banners,
    required this.data,
  });

  factory MainScreenData.fromJson(Map<String, dynamic> json) => MainScreenData(
    apiVersion: json["apiVersion"],
    banners: List<AdBanner>.from(json["banners"].map((x) => AdBanner.fromJson(x))),
    data: List<MainData>.from(json["data"].map((x) => MainData.fromJson(x))),
  );
}

class AdBanner {
  int id;
  String type;
  Created created;
  String status;
  Created publishedFrom;
  Created publishedTo;
  String title;
  String advertiser;
  BannerTypeData bannerTypeData;
  String image;
  String? link;
  bool button;
  String? buttonText;
  String buttonColor;

  AdBanner({
    required this.id,
    required this.type,
    required this.created,
    required this.status,
    required this.publishedFrom,
    required this.publishedTo,
    required this.title,
    required this.advertiser,
    required this.bannerTypeData,
    required this.image,
    required this.link,
    required this.button,
    required this.buttonText,
    required this.buttonColor,
  });

  factory AdBanner.fromJson(Map<String, dynamic> json) => AdBanner(
    id: json["id"]?? 0,
    type: json["type"]?? '',
    created: Created.fromJson(json["created"]?? ''),
    status: json["status"]?? '',
    publishedFrom: Created.fromJson(json["published_from"]?? {}),
    publishedTo: json["published_to"] == null ? Created(date: DateTime.now(), timezoneType: 0, timezone: '') : Created.fromJson(json["published_to"]),
    title: json["title"]?? '',
    advertiser: json["advertiser"]?? '',
    bannerTypeData: json["banner_type_data"] == null ? BannerTypeData(cards: []) : BannerTypeData.fromJson(json["banner_type_data"]?? ''),
    image: json["image"]?? '',
    link: json["link"]?? '',
    button: json["button"]?? false,
    buttonText: json["button_text"]?? '',
    buttonColor: json["button_color"]?? '',
  );
}

class BannerTypeData {
  List<BannerTypeDataCard> cards;

  BannerTypeData({
    required this.cards,
  });

  factory BannerTypeData.fromJson(Map<String, dynamic> json) => BannerTypeData(
    cards: json["cards"] == null ? [] : List<BannerTypeDataCard>.from(json["cards"].map((x) => BannerTypeDataCard.fromJson(x))),
  );
}

class BannerTypeDataCard {
  String type;
  int? sequenceNumber;

  BannerTypeDataCard({
    required this.type,
    this.sequenceNumber,
  });

  factory BannerTypeDataCard.fromJson(Map<String, dynamic> json) => BannerTypeDataCard(
    type: json["type"],
    sequenceNumber: json["sequence_number"],
  );
}

class MainData {
  int id;
  String type;
  List<CategoryElement> category;
  Created? created;
  String name;
  String subtitle;
  String facebookLink;
  String instagramLink;
  String twitterXLink;
  String tiktokLink;
  String linkedinLink;
  String phoneNumber;
  String whatsappSmsNo;
  String emailAddress;
  String streamLink;
  String cardImage;
  String upperImage;
  bool noPushNotification;
  DisplaySettings? displaySettings;
  bool pinToTop;
  String playNowEndpoint;
  List<News>? news;
  List<MainData>? playlists;
  List<Podcast>? audioPodcasts;
  List<Podcast>? videoPodcasts;
  List<InterviewData>? interviews;
  List<Contest>? contests;

  MainData({
    required this.id,
    required this.type,
    required this.category,
    required this.created,
    required this.name,
    required this.subtitle,
    required this.facebookLink,
    required this.instagramLink,
    required this.twitterXLink,
    required this.tiktokLink,
    required this.linkedinLink,
    required this.phoneNumber,
    required this.whatsappSmsNo,
    required this.emailAddress,
    required this.streamLink,
    required this.cardImage,
    required this.upperImage,
    required this.noPushNotification,
    required this.displaySettings,
    required this.pinToTop,
    required this.playNowEndpoint,
    this.news,
    this.playlists,
    this.audioPodcasts,
    this.videoPodcasts,
    this.interviews,
    this.contests,
  });

  factory MainData.fromJson(Map<String, dynamic> json) => MainData(
    id: json["id"]?? 0,
    type: json["type"]?? '',
    category: json["category"] == null ? [] :  List<CategoryElement>.from(json["category"].map((x) => CategoryElement.fromJson(x))),
    created: json["created"] == null ? null : Created.fromJson(json["created"]),
    name: json["name"]?? '',
    subtitle: json["subtitle"]?? '',
    facebookLink: json["facebookLink"]?? '',
    instagramLink: json["instagramLink"]?? '',
    twitterXLink: json["twitterXLink"]?? '',
    tiktokLink: json["tiktokLink"]?? '',
    linkedinLink: json["linkedinLink"]?? '',
    phoneNumber: json["phoneNumber"]?? '',
    whatsappSmsNo: json["whatsappSmsNo"]?? '',
    emailAddress: json["emailAddress"]?? '',
    streamLink: json["streamLink"]?? '',
    cardImage: json["cardImage"]?? '',
    upperImage: json["upperImage"]?? '',
    noPushNotification: json["noPushNotification"]?? false,
    displaySettings: json["displaySettings"] == null ? null : DisplaySettings.fromJson(json["displaySettings"]),
    pinToTop: json["pinToTop"]?? false,
    playNowEndpoint: json["playNowEndpoint"]?? '',
    news: json["news"] == null ? [] : List<News>.from(json["news"]!.map((x) => News.fromJson(x))),
    playlists: json["playlists"] == null ? [] : List<MainData>.from(json["playlists"]!.map((x) => MainData.fromJson(x))),
    audioPodcasts: json["audio_podcasts"] == null ? [] : List<Podcast>.from(json["audio_podcasts"]!.map((x) => Podcast.fromJson(x))),
    videoPodcasts: json["video_podcasts"] == null ? [] : List<Podcast>.from(json["video_podcasts"]!.map((x) => Podcast.fromJson(x))),
    interviews: json["interviews"] == null ? [] : List<InterviewData>.from(json["interviews"]!.map((x) => InterviewData.fromJson(x))),
    contests: json["contests"] == null ? [] : List<Contest>.from(json["contests"]!.map((x) => Contest.fromJson(x))),
  );
}

class Contest {
  int id;
  MobileConfig mobileConfig;
  String name;

  Contest({
    required this.id,
    required this.mobileConfig,
    required this.name,
  });

  factory Contest.fromJson(Map<String, dynamic> json) => Contest(
    id: json["id"]?? 0,
    mobileConfig: json["mobile_config"] == null ? MobileConfig.fromJson({}) : MobileConfig.fromJson(json["mobile_config"]),
    name: json["name"]?? '',
  );
}

class MobileConfig {
  int position;
  String background;
  String thumbnail;
  String verticalAlign;
  String align;
  String smallHeader;
  String bigHeader;
  String fullDesc;
  String btnText;
  String btnColor;
  String btnLink;

  MobileConfig({
    required this.position,
    required this.background,
    required this.thumbnail,
    required this.verticalAlign,
    required this.align,
    required this.smallHeader,
    required this.bigHeader,
    required this.fullDesc,
    required this.btnText,
    required this.btnColor,
    required this.btnLink,
  });

  factory MobileConfig.fromJson(Map<String, dynamic> json) => MobileConfig(
    position: json["position"]?? 0,
    background: json["background"]?? '',
    thumbnail: json["thumbnail"]?? '',
    verticalAlign: json["vertical_align"]?? '',
    align: json["align"]?? '',
    smallHeader: json["small_header"]?? '',
    bigHeader: json["big_header"]?? '',
    fullDesc: json["full_desc"]?? '',
    btnText: json["btn_text"]?? '',
    btnColor: json["btn_color"]?? '',
    btnLink: json["btn_link"]?? '',
  );
}

class CategoryElement {
  int id;
  String status;
  String title;

  CategoryElement({
    required this.id,
    required this.status,
    required this.title,
  });

  factory CategoryElement.fromJson(Map<String, dynamic> json) => CategoryElement(
    id: json["id"]?? 0,
    status: json["status"]?? '',
    title: json["title"]?? '',
  );
}

class Created {
  DateTime date;
  int timezoneType;
  String timezone;

  Created({
    required this.date,
    required this.timezoneType,
    required this.timezone,
  });

  factory Created.fromJson(Map<String, dynamic> json) => Created(
    date: json["date"] == null ? DateTime.now() : DateTime.parse(json["date"]),
    timezoneType: json["timezone_type"]?? 0,
    timezone: json["timezone"]?? '',
  );
}

class DisplaySettings {
  List<DisplaySettingsCard> cards;

  DisplaySettings({
    required this.cards,
  });

  factory DisplaySettings.fromJson(Map<String, dynamic> json) => DisplaySettings(
    cards: List<DisplaySettingsCard>.from(json["cards"].map((x) => DisplaySettingsCard.fromJson(x))),
  );
}

class DisplaySettingsCard {
  String type;
  int mobileSequenceNo;
  String backgroundColor;
  String upperPartColor;
  List<dynamic> newsCategory;
  List<dynamic> playlistCategory;
  List<dynamic> podcastAudioCategory;
  List<dynamic> podcastVideoCategory;
  List<dynamic> interviewCategory;

  DisplaySettingsCard({
    required this.type,
    required this.mobileSequenceNo,
    required this.backgroundColor,
    required this.upperPartColor,
    required this.newsCategory,
    required this.playlistCategory,
    required this.podcastAudioCategory,
    required this.podcastVideoCategory,
    required this.interviewCategory,
  });

  factory DisplaySettingsCard.fromJson(Map<String, dynamic> json) => DisplaySettingsCard(
    type: json["type"]?? 0,
    mobileSequenceNo: json["mobile_sequence_no"]?? 0,
    backgroundColor: json["background_color"]?? 0,
    upperPartColor: json["upper_part_color"]?? 0,
    newsCategory: json["news_category"]?? [],
    playlistCategory: json["playlist_category"]?? [],
    podcastAudioCategory: json["podcast_audio_category"]?? [],
    podcastVideoCategory: json["podcast_video_category"]?? [],
    interviewCategory: json["interview_category"]?? [],
  );
}

class ContentData {
  List<ContentDataCard> cards;

  ContentData({
    required this.cards,
  });

  factory ContentData.fromJson(Map<String, dynamic> json) => ContentData(
    cards: List<ContentDataCard>.from(json["cards"].map((x) => ContentDataCard.fromJson(x))),
  );
}

class ContentDataCard {
  String type;
  String video;
  bool allowDownloading;
  bool allowCopying;

  ContentDataCard({
    required this.type,
    required this.video,
    required this.allowDownloading,
    required this.allowCopying,
  });

  factory ContentDataCard.fromJson(Map<String, dynamic> json) => ContentDataCard(
    type: json["type"]?? '',
    video: json["video"]?? '',
    allowDownloading: json["allow_downloading"]?? false,
    allowCopying: json["allow_copying"]?? false,
  );
}

class News {
  int id;
  String title;
  NewsCategory? category;
  dynamic dateFrom;
  dynamic dateTo;
  String status;
  bool noPushNotification;
  String displaySettings;
  String url;
  Card2? card2;

  News({
    required this.id,
    required this.title,
    required this.category,
    required this.dateFrom,
    required this.dateTo,
    required this.status,
    required this.noPushNotification,
    required this.displaySettings,
    required this.url,
    required this.card2,
  });

  factory News.fromJson(Map<String, dynamic> json) => News(
    id: json["id"]?? 0,
    title: json["title"]?? '',
    category: json["category"] == null ? null : NewsCategory.fromJson(json["category"]),
    dateFrom: json["dateFrom"],
    dateTo: json["dateTo"],
    status: json["status"]?? '',
    noPushNotification: json["noPushNotification"]?? false,
    displaySettings: json["displaySettings"]?? '',
    url: json["url"]?? '',
    card2: json["card_2"] == null ? null : Card2.fromJson(json["card_2"]),
  );
}

class Card2 {
  List<Card> cards;

  Card2({
    required this.cards,
  });

  factory Card2.fromJson(Map<String, dynamic> json) => Card2(
    cards: List<Card>.from(json["cards"].map((x) => Card.fromJson(x))),
  );
}

class Card {
  String background;
  dynamic link;

  Card({
    required this.background,
    required this.link
  });

  factory Card.fromJson(Map<String, dynamic> json) => Card(
    background: json["background"]?? '',
    link: json["link"]?? '',
  );
}

class NewsCategory {
  int id;
  String name;

  NewsCategory({
    required this.id,
    required this.name,
  });

  factory NewsCategory.fromJson(Map<String, dynamic> json) => NewsCategory(
    id: json["id"]?? 0,
    name: json["name"]?? '',
  );
}
