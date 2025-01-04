// To parse this JSON data, do
//
//     final getOtpResponse = getOtpResponseFromJson(jsonString);

import 'dart:convert';

GetOtpResponse getOtpResponseFromJson(String str) => GetOtpResponse.fromJson(json.decode(str));

String getOtpResponseToJson(GetOtpResponse data) => json.encode(data.toJson());

class GetOtpResponse {
  bool? success;
  String? message;
  Data? data;

  GetOtpResponse({
    this.success,
    this.message,
    this.data,
  });

  factory GetOtpResponse.fromJson(Map<String, dynamic> json) => GetOtpResponse(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  String? phoneNumber;
  String? verificationCode;
  DateTime? expiredAt;
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Data({
    this.phoneNumber,
    this.verificationCode,
    this.expiredAt,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    phoneNumber: json["phoneNumber"],
    verificationCode: json["verificationCode"].toString(),
    expiredAt: json["expiredAt"] == null ? null : DateTime.parse(json["expiredAt"]),
    id: json["_id"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "phoneNumber": phoneNumber,
    "verificationCode": verificationCode,
    "expiredAt": expiredAt?.toIso8601String(),
    "_id": id,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
