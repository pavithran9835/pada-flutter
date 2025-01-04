// To parse this JSON data, do
//
//     final cancelConnectResponse = cancelConnectResponseFromJson(jsonString);

import 'dart:convert';

CancelConnectResponse cancelConnectResponseFromJson(String str) => CancelConnectResponse.fromJson(json.decode(str));

String cancelConnectResponseToJson(CancelConnectResponse data) => json.encode(data.toJson());

class CancelConnectResponse {
  bool? success;
  String? message;

  CancelConnectResponse({
    this.success,
    this.message,
  });

  factory CancelConnectResponse.fromJson(Map<String, dynamic> json) => CancelConnectResponse(
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
  };
}
