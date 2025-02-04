import 'dart:convert';

import 'package:radio_skonto/models/main_screen_data.dart';

Interview interviewFromJson(String str) => Interview.fromJson(json.decode(str));
InterviewData singleInterviewDataFromJson(Map<String, dynamic> json) => InterviewData.fromJson(json);


class Interview {
  String apiVersion;
  Filters filters;
  List<AdBanner> banners;
  List<InterviewData> data;

  Interview({
    required this.apiVersion,
    required this.filters,
    required this.banners,
    required this.data,
  });

  factory Interview.fromJson(Map<String, dynamic> json) => Interview(
    apiVersion: json["apiVersion"]?? '',
    filters: Filters.fromJson(json["filters"]),
    banners: List<AdBanner>.from(json["banners"].map((x) => AdBanner.fromJson(x))),
    data: List<InterviewData>.from(json["data"].map((x) => InterviewData.fromJson(x))),
  );
}

class InterviewData {
  int id;
  String title;
  String subtitle;
  String description;
  String status;
  String paidContent;
  Created? dateFrom;
  dynamic dateTo;
  int sorting;
  String image;
  bool pinToTop;
  bool noShow;
  bool noPushNotification;
  String displaySettings;
  ContentData contentData;
  dynamic listens;
  List<Category> categories;

  InterviewData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.status,
    required this.paidContent,
    required this.dateFrom,
    required this.dateTo,
    required this.sorting,
    required this.image,
    required this.pinToTop,
    required this.noShow,
    required this.noPushNotification,
    required this.displaySettings,
    required this.contentData,
    required this.listens,
    required this.categories,
  });

  factory InterviewData.fromJson(Map<String, dynamic> json) => InterviewData(
    id: json["id"]?? 0,
    title: json["title"]?? '',
    subtitle: json["subtitle"]?? '',
    description: json["description"]?? '',
    status: json["status"]?? '',
    paidContent: json["paid_content"]?? '',
    dateFrom: json["dateFrom"] == null ? Created(date: DateTime.now(), timezoneType: 0, timezone: '') :  Created.fromJson(json["dateFrom"]),
    dateTo: json["dateTo"],
    sorting: json["sorting"]?? 0,
    image: json["image"]?? '',
    pinToTop: json["pinToTop"]?? false,
    noShow: json["noShow"]?? false,
    noPushNotification: json["noPushNotification"]?? false,
    displaySettings: json["displaySettings"]?? '',
    contentData: json["contentData"] == null ? ContentData(cards: []) : ContentData.fromJson(json["contentData"]),
    listens: json["listens"]?? [],
    categories: json["categories"] == null ? [] : List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
  );
}

class Category {
  int id;
  String title;
  Created? created;
  bool published;
  bool isSelected = false;

  Category({
    required this.id,
    required this.title,
    required this.created,
    required this.published,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"]?? 0,
    title: json["title"]?? '',
    created: json["created"] == null ? null : Created.fromJson(json["created"]),
    published: json["published"]?? true,
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

  Map<String, dynamic> toJson() => {
    "date": date.toIso8601String(),
    "timezone_type": timezoneType,
    "timezone": timezone,
  };
}

class ContentData {
  List<InterviewCard> cards;

  ContentData({
    required this.cards,
  });

  factory ContentData.fromJson(Map<String, dynamic> json) => ContentData(
    cards: List<InterviewCard>.from(json["cards"].map((x) => InterviewCard.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "cards": List<dynamic>.from(cards.map((x) => x.toJson())),
  };
}

class InterviewCard {
  String type;
  Html? html;
  String video;
  bool? allowDownloading;
  bool? allowCopying;
  String? audioFile;
  int? audioDuration;
  int? audioLincDuration;

  InterviewCard({
    required this.type,
    this.html,
    required this.video,
    this.allowDownloading,
    this.allowCopying,
    this.audioFile,
    this.audioDuration,
    this.audioLincDuration
  });

  factory InterviewCard.fromJson(Map<String, dynamic> json) => InterviewCard(
    type: json["type"],
    html: json["html"] == null ? null : Html.fromJson(json["html"]),
    video: json["video"]?? '',
    allowDownloading: json["allow_downloading"],
    allowCopying: json["allow_copying"],
    audioFile: json["audio_file"]?? '',
    audioDuration: json["audio_duration"]?? 0,
    audioLincDuration: json["audio_link_duration"]?? 0,
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "html": html?.toJson(),
    "video": video,
    "allow_downloading": allowDownloading,
    "allow_copying": allowCopying,
    "audio_file": audioFile,
  };
}

class Html {
  String lv;
  String en;
  String ru;

  Html({
    required this.lv,
    required this.en,
    required this.ru,
  });

  factory Html.fromJson(Map<String, dynamic> json) => Html(
    lv: json["lv"],
    en: json["en"],
    ru: json["ru"],
  );

  Map<String, dynamic> toJson() => {
    "lv": lv,
    "en": en,
    "ru": ru,
  };
}

class Filters {
  List<Sort> sort;
  List<Category> categories;

  Filters({
    required this.sort,
    required this.categories,
  });

  factory Filters.fromJson(Map<String, dynamic> json) => Filters(
    sort: List<Sort>.from(json["sort"].map((x) => Sort.fromJson(x))),
    categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
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

  Map<String, dynamic> toJson() => {
    "name": name,
    "sortBy": sortBy,
    "sortOrder": sortOrder,
  };
}
