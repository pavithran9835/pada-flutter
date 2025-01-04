class SearchConnectResponse {
  bool? success;
  String? message;
  Data? data;

  SearchConnectResponse({this.success, this.message, this.data});

  SearchConnectResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<SearchData>? searchData;

  Data({this.searchData});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['searchData'] != null) {
      searchData = <SearchData>[];
      json['searchData'].forEach((v) {
        searchData!.add(SearchData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (searchData != null) {
      data['searchData'] = searchData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SearchData {
  String? sId;
  String? userId;
  List<double>? pickup;
  List<double>? drop;
  String? status;
  int? riderCount;
  List<dynamic>? coRiders;
  Null startedAt;
  String? createdAt;
  Address? address;
  String? updatedAt;
  int? iV;
  double? distance;
  SearchUserData? userData;

  SearchData(
      {this.sId,
      this.userId,
      this.pickup,
      this.drop,
      this.status,
      this.riderCount,
      this.coRiders,
      this.startedAt,
      this.address,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.distance,
      this.userData});

  SearchData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    pickup = json['pickup'].cast<double>();
    drop = json['drop'].cast<double>();
    status = json['status'];
    riderCount = json['riderCount'];
    coRiders = json["coRiders"] == null
        ? []
        : List<dynamic>.from(json["coRiders"]!.map((x) => x));
    startedAt = json['startedAt'];
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    distance = double.parse(json['distance'].toString());
    userData = json['userData'] != null
        ? SearchUserData.fromJson(json['userData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['userId'] = userId;
    data['pickup'] = pickup;
    data['drop'] = drop;
    data['status'] = status;
    data['riderCount'] = riderCount;
    data['coRiders'] =
        coRiders == null ? [] : List<dynamic>.from(coRiders!.map((x) => x));
    data['startedAt'] = startedAt;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['distance'] = distance;
    if (userData != null) {
      data['userData'] = userData!.toJson();
    }
    return data;
  }
}

class Address {
  String? pickup;
  String? drop;

  Address({this.pickup, this.drop});

  Address.fromJson(Map<String, dynamic> json) {
    pickup = json['pickup'];
    drop = json['drop'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['pickup'] = pickup;
    data['drop'] = drop;
    return data;
  }
}

class SearchUserData {
  String? sId;
  String? username;
  String? image;

  SearchUserData({this.sId, this.username, this.image});

  SearchUserData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    username = json['username'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['username'] = username;
    data['image'] = image;
    return data;
  }
}
