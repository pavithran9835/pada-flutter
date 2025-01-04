class ChatMessagesModel {
  bool? success;
  String? message;
  List<Data>? data;

  ChatMessagesModel({this.success, this.message, this.data});

  ChatMessagesModel.fromJson(Map<String, dynamic> json) {
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
  String? conversationId;
  String? sender;
  String? receiver;
  String? message;
  String? file;
  bool? isMedia;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.sId,
      this.conversationId,
      this.sender,
      this.receiver,
      this.message,
      this.file,
      this.isMedia,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    conversationId = json['conversationId'];
    sender = json['sender'];
    receiver = json['receiver'];
    message = json['message'];
    file = json['file'];
    isMedia = json['isMedia'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['conversationId'] = conversationId;
    data['sender'] = sender;
    data['receiver'] = receiver;
    data['message'] = message;
    data['file'] = file;
    data['isMedia'] = isMedia;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
