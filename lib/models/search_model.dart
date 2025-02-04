// To parse this JSON data, do
//
//     final search = searchFromJson(jsonString);

import 'dart:convert';

Search searchFromJson(String str) => Search.fromJson(json.decode(str));

class Search {
  String apiVersion;
  SearchFilters filters;
  SearchData data;

  Search({
    required this.apiVersion,
    required this.filters,
    required this.data,
  });

  factory Search.fromJson(Map<String, dynamic> json) {
    final filters = json["filters"];
    final data = json['data'];
    return Search(
      apiVersion: json["apiVersion"] ?? 0,
      filters: filters == null
          ? SearchFilters.empty()
          : SearchFilters.fromJson(filters),
      data: data == null ? SearchData.empty() : SearchData.fromJson(data),
    );
  }

  factory Search.empty() {
    return Search(
      apiVersion: '',
      filters: SearchFilters.empty(),
      data: SearchData.empty(),
    );
  }
}

class SearchFilters {
  SearchTypes types;

  SearchFilters({
    required this.types,
  });

  factory SearchFilters.fromJson(Map<String, dynamic> json) {
    final types = json["types"];
    return SearchFilters(
      types: types == null ? SearchTypes() : SearchTypes.fromJson(types),
    );
  }

  factory SearchFilters.empty() {
    return SearchFilters(types: SearchTypes());
  }
}

class SearchTypes {
  final String? news;
  final String? podcast;
  final String? interview;
  final String? playlist;
  final String? vacancy;

  SearchTypes({
    this.news,
    this.podcast,
    this.interview,
    this.playlist,
    this.vacancy,
  });

  factory SearchTypes.fromJson(Map<String, dynamic> json) {
    return SearchTypes(
      news: json["news"],
      podcast: json["podcast"],
      interview: json["interview"],
      playlist: json["playlist"],
      vacancy: json["vacancy"],
    );
  }

  Map<String, String?> get toMap => <String, String?>{
        'news': news,
        "podcast": podcast,
        "interview": interview,
        "playlist": playlist,
        "vacancy": vacancy
      };
}

class SearchData {
  int total;
  List<SearchItem> items;

  SearchData({
    required this.total,
    required this.items,
  });

  factory SearchData.fromJson(Map<String, dynamic> json) {
    final items = json["items"];
    return SearchData(
      total: json["total"] ?? 0,
      items: items == null
          ? []
          : List<SearchItem>.from(items.map((x) => SearchItem.fromJson(x))),
    );
  }

  factory SearchData.empty() {
    return SearchData(total: 0, items: []);
  }
}

class SearchItem {
  int id;
  int translationId;
  String entityType;
  String displaySettings;
  String locale;
  String title;
  String categories;
  String description;
  String image;
  String url;

  SearchItem({
    required this.id,
    required this.translationId,
    required this.entityType,
    required this.displaySettings,
    required this.locale,
    required this.title,
    required this.categories,
    required this.description,
    required this.image,
    required this.url
  });

  factory SearchItem.fromJson(Map<String, dynamic> json) {
    return SearchItem(
      id: json["id"] ?? 0,
      translationId: json["translationId"] ?? 0,
      entityType: json["entityType"] ?? '',
      displaySettings: json["displaySettings"] ?? '',
      locale: json["locale"] ?? '',
      title: json["title"] ?? '',
      categories: json["categories"] ?? '',
      description: json["description"] ?? '',
      image: json["image"] ?? '',
      url: json["link"] ?? '',
    );
  }
}
