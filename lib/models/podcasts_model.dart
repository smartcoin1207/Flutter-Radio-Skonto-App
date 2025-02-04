// To parse this JSON data, do
//
//     final podcasts = podcastsFromJson(jsonString);

import 'dart:convert';

import 'package:radio_skonto/models/main_screen_data.dart';

Podcasts podcastsFromJson(String str) => Podcasts.fromJson(json.decode(str));
Podcast singlePodcastFromJson(Map<String, dynamic> json) => Podcast.fromJson(json);
Episode singleEpisodeFromJson(Map<String, dynamic> json) => Episode.fromJson(json);

class Podcasts {
  String apiVersion;
  Filters filters;
  List<AdBanner> banners;
  List<AudioPodcast> data;

  Podcasts({
    required this.apiVersion,
    required this.filters,
    required this.banners,
    required this.data,
  });

  factory Podcasts.fromJson(Map<String, dynamic> json) => Podcasts(
    apiVersion: json["apiVersion"],
    filters: Filters.fromJson(json["filters"]),
    banners: List<AdBanner>.from(json["banners"].map((x) => AdBanner.fromJson(x))),
    data: List<AudioPodcast>.from(json["data"].map((x) => AudioPodcast.fromJson(x))),
  );
}

class AudioPodcast {
  int id;
  String name;
  Created created;
  bool published;
  int? parent;
  List<Podcast>? podcasts;
  bool isSelected = false;

  AudioPodcast({
    required this.id,
    required this.name,
    required this.created,
    required this.published,
    required this.parent,
    this.podcasts,
  });

  factory AudioPodcast.fromJson(Map<String, dynamic> json) => AudioPodcast(
    id: json["id"]?? 0,
    name: json["name"]?? '',
    created: json["created"] == null ? Created(date: DateTime.now(), timezoneType: 0, timezone: '') :  Created.fromJson(json["created"]),
    published: json["published"]?? false,
    parent: json["parent"]?? 0,
    podcasts: json["podcasts"] == null ? [] : List<Podcast>.from(json["podcasts"]!.map((x) => Podcast.fromJson(x))),
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
    date: DateTime.parse(json["date"]),
    timezoneType: json["timezone_type"],
    timezone: json["timezone"],
  );
}

class Podcast {
  int id;
  String type;
  String title;
  String description;
  String tagText;
  String image;
  Created? dateFrom;
  String status;
  String paidContent;
  bool noPushNotification;
  String displaySettings;
  bool pinToTop;
  bool showNearByRecommendationInMobile;
  List<Episode> episodes;

  Podcast({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.tagText,
    required this.image,
    required this.dateFrom,
    required this.status,
    required this.paidContent,
    required this.noPushNotification,
    required this.displaySettings,
    required this.pinToTop,
    required this.showNearByRecommendationInMobile,
    required this.episodes,
  });

  factory Podcast.fromJson(Map<String, dynamic> json) => Podcast(
    id: json["id"]?? 0,
    type: json["type"]?? '',
    title: json["title"]?? '',
    description: json["description"]?? '',
    tagText: json["tag_text"]?? '',
    image: json["image"]?? '',
    dateFrom: json["dateFrom"] == null ? null : Created.fromJson(json["dateFrom"]),
    status: json["status"]?? '',
    paidContent: json["paid_content"]?? '',
    noPushNotification: json["noPushNotification"]?? false,
    displaySettings: json["displaySettings"]?? '',
    pinToTop: json["pinToTop"]?? false,
    showNearByRecommendationInMobile: json["showNearByRecommendationInMobile"]?? false,
    episodes: json["episodes"] == null ? [] : List<Episode>.from(json["episodes"].map((x) => Episode.fromJson(x))),
  );
}

class Episode {
  int id;
  Created? created;
  Created? publishedFrom;
  Created? publishedBy;
  String title;
  String description;
  String status;
  bool noPushNotification;
  String displaySettings;
  ContentData contentData;

  Episode({
    required this.id,
    required this.created,
    required this.publishedFrom,
    required this.publishedBy,
    required this.title,
    required this.description,
    required this.status,
    required this.noPushNotification,
    required this.displaySettings,
    required this.contentData,
  });

  factory Episode.fromJson(Map<String, dynamic> json) => Episode(
    id: json["id"],
    created: json["created"] == null ? null : Created.fromJson(json["created"]),
    publishedFrom: json["publishedFrom"] == null ? null : Created.fromJson(json["publishedFrom"]),
    publishedBy: json["publishedBy"] == null ? null : Created.fromJson(json["publishedBy"]),
    title: json["title"],
    description: json["description"],
    status: json["status"],
    noPushNotification: json["noPushNotification"],
    displaySettings: json["displaySettings"],
    contentData: ContentData.fromJson(json["contentData"]),
  );
}

class ContentData {
  List<EpisodeCard> cards;

  ContentData({
    required this.cards,
  });

  factory ContentData.fromJson(Map<String, dynamic> json) => ContentData(
    cards: List<EpisodeCard>.from(json["cards"].map((x) => EpisodeCard.fromJson(x))),
  );
}

class EpisodeCard {
  String type;
  String audioFile;
  String image;
  String video;
  String videoUrl;
  bool allowDownloading;
  int audioDuration;

  EpisodeCard({
    required this.type,
    required this.audioFile,
    required this.image,
    required this.video,
    required this.videoUrl,
    required this.allowDownloading,
    required this.audioDuration
  });

  factory EpisodeCard.fromJson(Map<String, dynamic> json) => EpisodeCard(
    type: json["type"]?? '',
    audioFile: json["audio_file"]?? '',
    image: json["image"]?? '',
    video: json["video"]?? '',
    videoUrl: json["video_url"]?? '',
    allowDownloading: json["allow_downloading"]?? false,
    audioDuration: json["audio_duration"]?? 0,
  );
}

class Filters {
  List<Sort> sort;
  List<AudioPodcast> categories;
  List<AudioPodcast> subCategories;

  Filters({
    required this.sort,
    required this.categories,
    required this.subCategories,
  });

  factory Filters.fromJson(Map<String, dynamic> json) => Filters(
    sort: List<Sort>.from(json["sort"].map((x) => Sort.fromJson(x))),
    categories: List<AudioPodcast>.from(json["categories"].map((x) => AudioPodcast.fromJson(x))),
    subCategories: List<AudioPodcast>.from(json["sub_categories"].map((x) => AudioPodcast.fromJson(x))),
  );
}

class Sort {
  String name;
  String sortBy;
  String sortOrder;
  bool isSelected = false;

  Sort({
    required this.name,
    required this.sortBy,
    required this.sortOrder,
  });

  factory Sort.fromJson(Map<String, dynamic> json) => Sort(
    name: json["name"],
    sortBy: json["sortBy"],
    sortOrder: json["sortOrder"],
  );
}
