class ReqAcceptModel {
  String? userId;
  String? deliveryBoyId;
  String? orderId;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? email;
  String? image;
  String? shortCode;
  String? gender;
  String? vehicleNumber;
  String? vehicle;
  String? totalAmount;
  String? discountAmount;
  String? userPaid;
  List<double>? location;
  PickUp? pickUp;
  PickUp? drop;

  ReqAcceptModel(
      {this.userId,
      this.deliveryBoyId,
      this.orderId,
      this.firstName,
      this.lastName,
      this.phoneNumber,
      this.email,
      this.image,
      this.shortCode,
      this.gender,
      this.totalAmount,
      this.discountAmount,
      this.userPaid,
      this.vehicleNumber,
      this.vehicle,
      this.location,
      this.pickUp,
      this.drop});

  ReqAcceptModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    deliveryBoyId = json['deliveryBoyId'];
    orderId = json['orderId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    image = json['image'];
    shortCode = json['shortCode'];
    gender = json['gender'];
    vehicleNumber = json['vehicleNumber'];
    vehicle = json['vehicle'];
    totalAmount = json['totalAmount'];
    discountAmount = json['discountAmount'];
    userPaid = json['userPaid'];
    location = json['location'].cast<double>();
    pickUp =
        json['pickUp'] != null ? PickUp.fromJson(json['pickUp']) : null;
    drop = json['drop'] != null ? PickUp.fromJson(json['drop']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['deliveryBoyId'] = deliveryBoyId;
    data['orderId'] = orderId;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['phoneNumber'] = phoneNumber;
    data['email'] = email;
    data['image'] = image;
    data['shortCode'] = shortCode;
    data['gender'] = gender;
    data['vehicleNumber'] = vehicleNumber;
    data['vehicle'] = vehicle;
    data['totalAmount'] = totalAmount;
    data['discountAmount'] = discountAmount;
    data['userPaid'] = userPaid;
    data['location'] = location;
    if (pickUp != null) {
      data['pickUp'] = pickUp!.toJson();
    }
    if (drop != null) {
      data['drop'] = drop!.toJson();
    }
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
