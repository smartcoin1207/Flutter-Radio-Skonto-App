import 'dart:convert';

PlaceOfResidenceModel placeOfResidenceModelFromJson(String str) => PlaceOfResidenceModel.fromJson(json.decode(str));

String placeOfResidenceModelToJson(PlaceOfResidenceModel data) => json.encode(data.toJson());

class PlaceOfResidenceModel {
  String apiVersion;
  Map<String, DatumResidence> data;

  PlaceOfResidenceModel({
    required this.apiVersion,
    required this.data,
  });

  factory PlaceOfResidenceModel.fromJson(Map<String, dynamic> json) => PlaceOfResidenceModel(
    apiVersion: json["apiVersion"],
    data: Map.from(json["data"]).map((k, v) => MapEntry<String, DatumResidence>(k, DatumResidence.fromJson(v))),
  );

  Map<String, dynamic> toJson() => {
    "apiVersion": apiVersion,
    "data": Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
  };
}

class DatumResidence {
  int id;
  String name;
  int postalCode;

  DatumResidence({
    required this.id,
    required this.name,
    required this.postalCode,
  });

  factory DatumResidence.fromJson(Map<String, dynamic> json) => DatumResidence(
    id: json["id"]?? 0,
    name: json["name"]?? '',
    postalCode: json["postalCode"]?? 0,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "postalCode": postalCode,
  };
}
