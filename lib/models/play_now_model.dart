import 'dart:convert';

PlayNowData playNowDataFromJson(String str) => PlayNowData.fromJson(json.decode(str));

class PlayNowData {
  String context;
  String id;
  String type;
  String station;
  String songArtist;
  String songTitle;
  DateTime updatedAt;
  String artworkPath;
  String spotifyUrl;
  String appleUrl;
  String youtubeUrl;
  String copyText;

  PlayNowData({
    required this.context,
    required this.id,
    required this.type,
    required this.station,
    required this.songArtist,
    required this.songTitle,
    required this.updatedAt,
    required this.artworkPath,
    required this.spotifyUrl,
    required this.appleUrl,
    required this.youtubeUrl,
    required this.copyText,
  });

  factory PlayNowData.fromJson(Map<String, dynamic> json) => PlayNowData(
    context: json["@context"]?? '',
    id: json["@id"]?? '',
    type: json["@type"]?? '',
    station: json["station"]?? '',
    songArtist: json["songArtist"]?? '',
    songTitle: json["songTitle"]?? '',
    updatedAt: DateTime.parse(json["updatedAt"]?? '0'),
    artworkPath: json["artworkPath"]?? '',
    spotifyUrl: json["spotifyUrl"]?? '',
    appleUrl: json["appleUrl"]?? '',
    youtubeUrl: json["youtubeUrl"]?? '',
    copyText: json["copyText"]?? '',
  );
}
