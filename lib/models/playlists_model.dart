// To parse this JSON data, do
//
//     final playlistModel = playlistModelFromJson(jsonString);

import 'dart:convert';

import 'package:radio_skonto/models/main_screen_data.dart';

PlaylistModel playlistModelFromJson(String str) => PlaylistModel.fromJson(json.decode(str));

class PlaylistModel {
  String apiVersion;
  Data data;

  PlaylistModel({
    required this.apiVersion,
    required this.data,
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) => PlaylistModel(
    apiVersion: json["apiVersion"],
    data: Data.fromJson(json["data"]),
  );
}

class Data {
  List<MainData> suggestedByRadio;
  List<MainData> mostListened;
  List<MainData> playlists;

  Data({
    required this.suggestedByRadio,
    required this.mostListened,
    required this.playlists,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    suggestedByRadio: List<MainData>.from(json["suggested_by_radio"].map((x) => MainData.fromJson(x))),
    mostListened: List<MainData>.from(json["most_listened"].map((x) => MainData.fromJson(x))),
    playlists: List<MainData>.from(json["playlists"].map((x) => MainData.fromJson(x))),
  );
}

// class MostListened {
//   int id;
//   String type;
//   List<Category> category;
//   Created created;
//   String name;
//   dynamic subtitle;
//   String? facebookLink;
//   String? instagramLink;
//   dynamic twitterXLink;
//   String? tiktokLink;
//   dynamic linkedinLink;
//   String phoneNumber;
//   String whatsappSmsNo;
//   String emailAddress;
//   String streamLink;
//   String cardImage;
//   String upperImage;
//   bool noPushNotification;
//   DisplaySettings displaySettings;
//   bool pinToTop;
//   String playNowEndpoint;
//
//   MostListened({
//     required this.id,
//     required this.type,
//     required this.category,
//     required this.created,
//     required this.name,
//     required this.subtitle,
//     required this.facebookLink,
//     required this.instagramLink,
//     required this.twitterXLink,
//     required this.tiktokLink,
//     required this.linkedinLink,
//     required this.phoneNumber,
//     required this.whatsappSmsNo,
//     required this.emailAddress,
//     required this.streamLink,
//     required this.cardImage,
//     required this.upperImage,
//     required this.noPushNotification,
//     required this.displaySettings,
//     required this.pinToTop,
//     required this.playNowEndpoint,
//   });
//
//   factory MostListened.fromJson(Map<String, dynamic> json) => MostListened(
//     id: json["id"],
//     type: json["type"],
//     category: List<Category>.from(json["category"].map((x) => Category.fromJson(x))),
//     created: Created.fromJson(json["created"]),
//     name: json["name"],
//     subtitle: json["subtitle"],
//     facebookLink: json["facebookLink"],
//     instagramLink: json["instagramLink"],
//     twitterXLink: json["twitterXLink"],
//     tiktokLink: json["tiktokLink"],
//     linkedinLink: json["linkedinLink"],
//     phoneNumber: json["phoneNumber"],
//     whatsappSmsNo: json["whatsappSmsNo"],
//     emailAddress: json["emailAddress"],
//     streamLink: json["streamLink"],
//     cardImage: json["cardImage"],
//     upperImage: json["upperImage"],
//     noPushNotification: json["noPushNotification"],
//     displaySettings: DisplaySettings.fromJson(json["displaySettings"]),
//     pinToTop: json["pinToTop"],
//     playNowEndpoint: json["playNowEndpoint"],
//   );
// }

// class Category {
//   int id;
//   String status;
//   String title;
//
//   Category({
//     required this.id,
//     required this.status,
//     required this.title,
//   });
//
//   factory Category.fromJson(Map<String, dynamic> json) => Category(
//     id: json["id"],
//     status: json["status"],
//     title: json["title"],
//   );
// }

// class Created {
//   DateTime date;
//   int timezoneType;
//   String timezone;
//
//   Created({
//     required this.date,
//     required this.timezoneType,
//     required this.timezone,
//   });
//
//   factory Created.fromJson(Map<String, dynamic> json) => Created(
//     date: DateTime.parse(json["date"]),
//     timezoneType: json["timezone_type"],
//     timezone: json["timezone"],
//   );
// }

// class DisplaySettings {
//   List<Card> cards;
//
//   DisplaySettings({
//     required this.cards,
//   });
//
//   factory DisplaySettings.fromJson(Map<String, dynamic> json) => DisplaySettings(
//     cards: List<Card>.from(json["cards"].map((x) => Card.fromJson(x))),
//   );
// }

// class Card {
//   String type;
//   int webSequenceNo;
//   int mobileSequenceNo;
//   String backgroundColor;
//   String upperPartColor;
//   int newsCategory;
//   int playlistCategory;
//   int podcastAudioCategory;
//   int podcastVideoCategory;
//   int interviewCategory;
//   int contestCategory;
//
//   Card({
//     required this.type,
//     required this.webSequenceNo,
//     required this.mobileSequenceNo,
//     required this.backgroundColor,
//     required this.upperPartColor,
//     required this.newsCategory,
//     required this.playlistCategory,
//     required this.podcastAudioCategory,
//     required this.podcastVideoCategory,
//     required this.interviewCategory,
//     required this.contestCategory,
//   });
//
//   factory Card.fromJson(Map<String, dynamic> json) => Card(
//     type: json["type"],
//     webSequenceNo: json["web_sequence_no"],
//     mobileSequenceNo: json["mobile_sequence_no"],
//     backgroundColor: json["background_color"],
//     upperPartColor: json["upper_part_color"],
//     newsCategory: json["news_category"],
//     playlistCategory: json["playlist_category"],
//     podcastAudioCategory: json["podcast_audio_category"],
//     podcastVideoCategory: json["podcast_video_category"],
//     interviewCategory: json["interview_category"],
//     contestCategory: json["contest_category"],
//   );
// }
