// To parse this JSON data, do
//
//     final translations = translationsFromJson(jsonString);

import 'dart:convert';

Translations translationsFromJson(String str) => Translations.fromJson(json.decode(str));

class Translations {
  String apiVersion;
  Map<String, dynamic> data;

  Translations({
    required this.apiVersion,
    required this.data,
  });

  factory Translations.fromJson(Map<String, dynamic> json) => Translations(
    apiVersion: json["apiVersion"],
    data: json["data"],
  );
}

// class CurrentTranslation {
//   Map<String, String> translation;
//
//   CurrentTranslation({
//     required this.translation
//   });
//
//   // factory CurrentTranslation.fromJson(Map<String, dynamic> json) => CurrentTranslation(
//   //   translation: json["apiVersion"],
//   //   data: json["data"],
//   // );
// }

// class Data {
//   Map<String, String> lv;
//   Map<String, String> en;
//   Map<String, String> ru;
//
//   Data({
//     required this.lv,
//     required this.en,
//     required this.ru,
//   });
//
//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//     lv: Map.from(json["lv"]).map((k, v) => MapEntry<String, String>(k, v)),
//     en: Map.from(json["en"]).map((k, v) => MapEntry<String, String>(k, v)),
//     ru: Map.from(json["ru"]).map((k, v) => MapEntry<String, String>(k, v)),
//   );
// }
