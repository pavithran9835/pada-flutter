class VehicleModel{
  bool? success;
  String? message;
  List<Data>? data;

  VehicleModel({this.success, this.message, this.data});

  VehicleModel.fromJson(Map<String, dynamic> json) {
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
  String? image;
  String? name;
  int? km;
  String? price;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.sId,
        this.image,
        this.name,
        this.km,
        this.price,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    image = json['image'];
    name = json['name'];
    km = json['km'];
    price = json['price'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['image'] = image;
    data['name'] = name;
    data['km'] = km;
    data['price'] = price;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}