import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  //String apiVersion;
  Data data;

  ProfileModel({
    //required this.apiVersion,
    required this.data,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    //apiVersion: json["apiVersion"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    //"apiVersion": apiVersion,
    "data": data.toJson(),
  };
}

class Data {
  String firstName;
  String lastName;
  String email;
  String phone;
  int birthYear;
  String personSex;
  String education;
  String locale;
  String phoneCode;
  int city;
  bool isMan;
  bool isWoman;
  bool educationBasic;
  bool educationIntermediate;
  bool educationAdvanced;

  Data({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.birthYear,
    required this.personSex,
    required this.education,
    required this.locale,
    required this.phoneCode,
    required this.city,
    required this.isMan,
    required this.isWoman,
    required this.educationBasic,
    required this.educationIntermediate,
    required this.educationAdvanced,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    firstName: json["firstName"]?? '',
    lastName: json["lastName"]?? '',
    email: json["email"]?? '',
    phone: json["phone"]?? '',
    birthYear: json["birthYear"]?? 2000,
    personSex: json["personSex"]?? '',
    education: json["education"]?? '',
    locale: json["locale"]?? '',
    city: json["city"]?? 1,
    isMan: false,
    isWoman: false,
    educationBasic: false,
    educationIntermediate: false,
    educationAdvanced: false,
    phoneCode: ''
  );

  Map<String, dynamic> toJson() => {
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "phone": phone,
    "birthYear": birthYear,
    "personSex": personSex,
    "education": education,
    "locale": locale,
    "city": city,
  };
}