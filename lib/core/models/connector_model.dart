// class ConnectorModel{
//   String? imageUrl, name, gender, place;
//   double? distance;
//   ConnectorModel({this.distance, this.gender, this.imageUrl, this
//   .name, this.place});
// }

import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NewConnectorModel {
  String? id, userId, name, image;
  Location? pickup, drop;
  String? distance, pickupString, dropString;
  NewConnectorModel(
      {this.id,
      this.userId,
      this.name,
      this.image,
      this.pickupString,
      this.dropString,
      this.pickup,
      this.drop,
      this.distance});
}

class NewRequestModel {
  String? id,
      connectId,
      userId,
      name,
      image,
      pickupString,
      dropString,
      phoneNum,
      pickupAddress,
      dropAddress,
      rating;
  int? gender;
  LatLng? pickup, drop;
  NewRequestModel(
      {this.id,
      this.connectId,
      this.userId,
      this.name,
      this.image,
      this.phoneNum,
      this.gender,
      this.pickup,
      this.drop,
      this.pickupAddress,
      this.dropAddress,
      this.rating});
}

class NewAcceptModel {
  String? id,
      connectId,
      userId,
      name,
      image,
      phoneNum,
      rating,
      pickupString,
      dropString;
  /*   otherId,
      otherUserName,
      otherUserId,
      otherUserPhone,
      otherUserImage,
      otherUserRating,
      otherUserGender*/
  int? gender;
  LatLng? pickup, drop, source, destination;

  NewAcceptModel(
      {this.id,
      this.connectId,
      this.userId,
      this.name,
      this.image,
      this.gender,
      this.phoneNum,
      /*  this.otherId,
      this.otherUserId,
      this.otherUserName,
      this.otherUserPhone,
      this.otherUserImage,
      this.otherUserGender,
      this.otherUserRating,*/
      this.source,
      this.destination,
      this.drop,
      this.pickup,
      this.dropString,
      this.pickupString,
      this.rating});
}

class CallDataModel {
  String? userId, name;

  CallDataModel({this.userId, this.name});
}

class AddressModel {
  String? addressString;
  LatLng? latlng;
  String? placeId;
  String? name;
  String? phone;

  AddressModel({this.addressString, this.latlng, this.placeId, this.name, this.phone});
}
/*

// class ConnectorModel{
//   String? imageUrl, name, gender, place;
//   double? distance;
//   ConnectorModel({this.distance, this.gender, this.imageUrl, this
//   .name, this.place});
// }

import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NewConnectorModel{
  String? id, userId, name, phone, image;
  Location? pickup, drop;
  String? distance;
  NewConnectorModel({this.id, this.userId, this.name, this.phone, this.image, this.pickup, this
      .drop, this.distance});
}

class NewRequestModel{
  String? id,connectId, userId, name, image, phoneNum, pickupAddress, dropAddress, rating;
  int? gender;
  LatLng? pickup, drop;
  NewRequestModel({this.id, this.connectId, this.userId, this.name, this.image, this.phoneNum, this.gender, this.pickup, this
      .drop,this.pickupAddress,this.dropAddress, this.rating});
}*/
