class OrderHistoryModel {
  bool? success;
  String? message;
  List<Data>? data;

  OrderHistoryModel({this.success, this.message, this.data});

  OrderHistoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? sId;
  PickUp? pickUp;
  PickUp? drop;
  num? distance;
  String? vehicleId;
  String? userId;
  String? coupon;
  num? totalAmount;
  num? discountAmount;
  num? userPaid;
  num? status;
  String? cancelReason;
  String? paymentType;
  String? paymentID;
  String? vehicleName;
  String? vehicleImage;
  String? paymentReferenceId;
  bool? paymentStatus;
  List<RequestedDelivery>? requestedDelivery;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.sId,
      this.pickUp,
      this.drop,
      this.distance,
      this.vehicleId,
      this.userId,
      this.coupon,
      this.totalAmount,
      this.discountAmount,
      this.userPaid,
      this.status,
      this.cancelReason,
      this.paymentType,
      this.paymentID,
      this.vehicleName,
      this.vehicleImage,
      this.paymentReferenceId,
      this.paymentStatus,
      this.requestedDelivery,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    pickUp = json['pickUp'] != null ? PickUp.fromJson(json['pickUp']) : null;
    drop = json['drop'] != null ? PickUp.fromJson(json['drop']) : null;
    distance = json['distance'];
    vehicleId = json['vehicleId'];
    userId = json['userId'];
    coupon = json['coupon'];
    totalAmount = json['totalAmount'];
    discountAmount = json['discountAmount'];
    userPaid = json['userPaid'];
    status = json['status'];
    cancelReason = json['cancelReason'];
    paymentType = json['paymentType'];
    paymentID = json['paymentID'];
    vehicleName = json['vehicleName'];
    vehicleImage = json['vehicleImage'];
    paymentReferenceId = json['payment_reference_id'];
    paymentStatus = json['paymentStatus'];
    if (json['requestedDelivery'] != null) {
      requestedDelivery = <RequestedDelivery>[];
      json['requestedDelivery'].forEach((v) {
        requestedDelivery!.add(RequestedDelivery.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (pickUp != null) {
      data['pickUp'] = pickUp!.toJson();
    }
    if (drop != null) {
      data['drop'] = drop!.toJson();
    }
    data['distance'] = distance;
    data['vehicleId'] = vehicleId;
    data['userId'] = userId;
    data['coupon'] = coupon;
    data['totalAmount'] = totalAmount;
    data['discountAmount'] = discountAmount;
    data['userPaid'] = userPaid;
    data['status'] = status;
    data['cancelReason'] = cancelReason;
    data['paymentType'] = paymentType;
    data['paymentID'] = paymentID;
    data['vehicleName'] = vehicleName;
    data['vehicleImage'] = vehicleImage;
    data['payment_reference_id'] = paymentReferenceId;
    data['paymentStatus'] = paymentStatus;
    if (requestedDelivery != null) {
      data['requestedDelivery'] =
          requestedDelivery!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class PickUp {
  String? address;
  List<double>? location;
  String? userName;
  String? phoneNumber;

  PickUp({this.address, this.location, this.userName, this.phoneNumber});

  PickUp.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    location = json['location'].cast<double>();
    userName = json['userName'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['location'] = location;
    data['userName'] = userName;
    data['phoneNumber'] = phoneNumber;
    return data;
  }
}

class RequestedDelivery {
  List<dynamic>? requestedDelivery;

  RequestedDelivery({required this.requestedDelivery});

  RequestedDelivery.fromJson(Map<String, dynamic> json) {
    requestedDelivery = json['requestedDelivery'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['requestedDelivery'] = requestedDelivery;
    return data;
  }
}
