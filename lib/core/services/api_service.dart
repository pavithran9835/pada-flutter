import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';
import 'package:deliverapp/core/models/connector_model.dart';
import 'package:deliverapp/core/services/service_locator.dart';

import '../constants.dart';
import '../models/vehicle_list_model.dart';
import 'api_client.dart';

final ApiService apiService = locator.get<ApiService>();

class ApiService {
  BaseClient? api = BaseClient();

  setAuthorisation(String token) {
    api?.setToken(token);
    print("token success:: $token");
  }

  _processError(e) {
    // if (e is ClientException) {

    debugPrint("e:: ${e.message}");
    return e.message;

    // }
  }

  Future getOtp({String? mobileNumber}) async {
    try {
      const url = "/app/auth/send-otp";
      var formData = FormData.fromMap({"phoneNumber": mobileNumber});
      var response = await api?.otpPost(
          url: url, payload: formData, isAuthenticated: false);
      return response;
    } catch (e) {
      _processError(e);
      rethrow;
    }
  }

  Future updateProfile(
      {String? firstName, String? lastName, String? email}) async {
    try {
      const url = "/app/user";
      dynamic payload = {
        "firstName": firstName,
        "lastName": lastName,
        "email": email
      };
      var response = await api?.postNew(
          url: url,
          payload: payload,
          isAuthenticated: true,
          headers: {"Content-Type": "application/json"});
      return response;
    } catch (e) {
      _processError(e);
      rethrow;
    }
  }

  Future getUserProfile({dynamic address}) async {
    try {
      const url = "/app/user";
      var response = await api?.get(url: url, isAuthenticated: true);
      debugPrint("//////// $response");
      return response;
    } catch (e) {
      _processError(e);
      rethrow;
    }
  }

  Future mobileSignIn(
      {String? mobileNumber,
      String? deviceToken,
      String? verificationCode}) async {
    try {
      const url = "/app/auth/verify-otp";
      dynamic payload = {
        "phoneNumber": mobileNumber,
        "deviceToken": deviceToken,
        "verificationCode": verificationCode
      };
      var response =
          await api?.post(url: url, payload: payload, isAuthenticated: false);
      return response;
    } catch (e) {
      _processError(e);
      rethrow;
    }
  }

  Future socialSignIn(
      {String? socialId,
      String? deviceToken,
      String? email,
      String? displayName}) async {
    try {
      const url = "/app/auth/social-signin";
      dynamic payload = {
        "socialId": socialId,
        "email": email,
        "displayName": displayName,
        "deviceToken": deviceToken
      };
      var response =
          await api?.post(url: url, payload: payload, isAuthenticated: false);
      return response;
    } catch (e) {
      _processError(e);
      rethrow;
    }
  }

  Future searchPlace({String? sessionToken, String? input}) async {
    try {
      const String baseURL =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json';
      String url =
          '$baseURL?input=$input&key=$PLACES_API_KEY&sessiontoken=$sessionToken';
      var response = await api?.get(url: url, isAuthenticated: false);
      debugPrint("//////// $response");
      return response;
    } catch (e) {
      _processError(e);
      rethrow;
    }
  }

  Future getPlaceDetailsById({String? placeId, String? id}) async {
    try {
      String baseURL =
          'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$PLACES_API_KEY';
      // String url =
      //     '$baseURL?input=$input&key=$PLACES_API_KEY&sessiontoken=$sessionToken';
      var response = await api?.get(url: baseURL, isAuthenticated: false);
      debugPrint("//////// $response");
      return response;
    } catch (e) {
      _processError(e);
      rethrow;
    }
  }

  Future getPlaceId(double lat, double lng) async {
    try {
      final String url =
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$PLACES_API_KEY';
      var response = await api?.get(url: url, isAuthenticated: false);
      debugPrint("//////// $response");
      return response;
    } catch (e) {
      _processError(e);
      rethrow;
    }
  }

  Future getPlaceDetailsByCoordinates(double lat, double lng) async {
    try {
      final String url =
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$PLACES_API_KEY';
      var response = await api?.get(url: url, isAuthenticated: false);
      debugPrint("//////// $response");
      return response;
    } catch (e) {
      _processError(e);
      rethrow;
    }
  }

  Future<VehicleModel> getVehicleList({String? parentId}) async {
    try {
      const url = "/app/vehicle/list";
      dynamic payload = {"parentId": parentId};
      var response =
          await api?.postNew(url: url, payload: payload, isAuthenticated: true);
      debugPrint("//////// $response");
      return VehicleModel.fromJson(response);
    } catch (e) {
      _processError(e);
      rethrow;
    }
  }

  Future saveAddress({dynamic address}) async {
    try {
      const url = "/app/user/address";
      dynamic payload = {
        "nickName": "Home",
        "address": address["address"],
        "location": address["location"],
        "userName": address["name"],
        "phoneNumber": address["phone"],
        "placeId": address["placeId"],
      };
      var response =
          await api?.post(url: url, payload: payload, isAuthenticated: true);
      debugPrint("//////// $response");
      return response;
    } catch (e) {
      _processError(e);
      rethrow;
    }
  }

  Future getSavedAddress({dynamic address}) async {
    try {
      const url = "/app/user/getAddress";
      var response = await api?.get(url: url, isAuthenticated: true);
      debugPrint("//////// $response");
      return response;
    } catch (e) {
      _processError(e);
      rethrow;
    }
  }

  Future deleteAddress(String id) async {
    try {
      String url = "/app/user/address/$id";
      var response = await api?.delete(url: url, isAuthenticated: true);
      debugPrint("//////// $response");
      return response;
    } catch (e) {
      _processError(e);
      rethrow;
    }
  }

  Future createConnect(
      {required String description,
      required LatLng pickup,
      required LatLng drop,
      required String pickupString,
      required String dropString}) async {
    try {
      const url = "/app/connect";
      dynamic payload = {
        "description": description,
        "pickup": [pickup.latitude, pickup.longitude],
        "drop": [drop.latitude, drop.longitude],
        "address": {
          "pickup": pickupString,
          "drop": dropString,
        }
      };
      var response =
          await api?.post(url: url, payload: payload, isAuthenticated: true);
      return response;
    } catch (e) {
      _processError(e);
      rethrow;
    }
  }

  Future searchConnect({required LatLng pickup, required LatLng drop}) async {
    try {
      const url = "/app/connect/search";
      dynamic payload = {
        "pickup": [pickup.latitude, pickup.longitude],
        "drop": [drop.latitude, drop.longitude]
      };
      var response =
          await api?.post(url: url, payload: payload, isAuthenticated: true);
      return response;
    } catch (e) {
      _processError(e);
      rethrow;
    }
  }

  Future newSearchConnect(
      {required LatLng pickup, required LatLng drop}) async {
    try {
      const url = "/app/connect/newsearch";
      dynamic payload = {
        "pickup": [pickup.latitude, pickup.longitude],
        "drop": [drop.latitude, drop.longitude]
      };
      var response =
          await api?.post(url: url, payload: payload, isAuthenticated: true);
      return response;
    } catch (e) {
      _processError(e);
      rethrow;
    }
  }

  Future cancelConnect({required String connectId}) async {
    try {
      final url = "/app/connect/cancel/$connectId";
      var response =
          await api?.post(url: url, payload: null, isAuthenticated: true);
      return response;
    } catch (e) {
      _processError(e);
      rethrow;
    }
  }

  Future createConversion(
      {required String senderId,
      required String receiverId,
      required String connectId}) async {
    try {
      const url = "/app/conversation";
      dynamic payload = {
        "senderId": senderId,
        "receiverId": receiverId,
        "connectId": connectId
      };
      var response =
          await api?.post(url: url, payload: payload, isAuthenticated: true);
      return response;
    } catch (e) {
      _processError(e);
      rethrow;
    }
  }

  Future getMessages({required String conversationId}) async {
    try {
      var url = "/app/message/$conversationId";
      // dynamic payload = {
      //   "senderId": senderId,
      //   "receiverId": receiverId,
      //   "connectId": connectId
      // };
      var response = await api?.get(url: url, isAuthenticated: true);
      return response;
    } catch (e) {
      _processError(e);
      rethrow;
    }
  }

  Future createRating(
      {required double rating,
      required String ratingTo,
      required String connectId,
      required String comment}) async {
    try {
      const url = "/app/rating";
      dynamic payload = {
        "rating": rating,
        "ratingTo": ratingTo,
        "connectId": connectId,
        "comment": comment
      };
      var response =
          await api?.post(url: url, payload: payload, isAuthenticated: true);
      return response;
    } catch (e) {
      _processError(e);
      rethrow;
    }
  }

  Future getOrderHistory({required String skip, required String limit}) async {
    try {
      var url = "/app/order/history";
      dynamic payload = {"skip": skip, "limit": limit};
      var response =
          await api?.post(url: url, payload: payload, isAuthenticated: true);
      return response;
    } catch (e) {
      _processError(e);
      rethrow;
    }
  }

  Future getBannerImage(String type) async {
    try {
      var url = "/app/banner/list";
      dynamic payload = {
        "type": type,
      };
      var response =
          await api?.postNew(url: url, payload: payload, isAuthenticated: true);
      return response;
    } catch (e) {
      _processError(e);
      rethrow;
    }
  }

  Future validateCoupon(String code) async {
    try {
      var url = "/app/coupon/validate";
      dynamic payload = {
        "code": code,
      };
      var response =
          await api?.post(url: url, payload: payload, isAuthenticated: true);
      return response;
    } catch (e) {
      _processError(e);
      rethrow;
    }
  }

  Future distanceCalc(dynamic pickup, dynamic drop) async {
    try {
      var url = "/app/order/distance";
      dynamic payload = {
        "pickup": pickup,
        "drop": drop,
      };
      var response =
          await api?.post(url: url, payload: payload, isAuthenticated: true);
      return response;
    } catch (e) {
      _processError(e);
      rethrow;
    }
  }

  Future cancelOrder(String orderId, dynamic reason) async {
    try {
      var url = "/app/order/cancel-request";
      dynamic payload = {"orderId": orderId, "cancelReason": reason};
      var response =
          await api?.post(url: url, payload: payload, isAuthenticated: true);
      return response;
    } catch (e) {
      _processError(e);
      rethrow;
    }
  }

  Future orderCreate(
      {required AddressModel pickup,
      required AddressModel drop,
      required String vehicleId,
      required String coupon,
      required dynamic paymentDetails,
      required double distance}) async {
    // try {
    var url = "/app/order";
    dynamic payload = {
      "pickUp": {
        "address": pickup.addressString,
        "location": [
          pickup.latlng!.latitude,
          pickup.latlng!.longitude,
        ],
        "userName": pickup.name,
        "phoneNumber": pickup.phone
      },
      "drop": {
        "address": drop.addressString,
        "location": [
          drop.latlng!.latitude,
          drop.latlng!.longitude,
        ],
        "userName": drop.name,
        "phoneNumber": drop.phone
      },
      "vehicleId": vehicleId,
      "coupon": coupon,
      "paymentType": paymentDetails["paymentType"],
      "distance": distance,
      "price": paymentDetails['price'],
      "discountAmount": paymentDetails['discountAmount'],
      "userPaid": paymentDetails['userPaid']
    };
    var response =
        await api?.post(url: url, payload: payload, isAuthenticated: true);
    debugPrint("resp:: $response");
    return response;
    // } catch (e) {
    //   _processError(e);
    //   rethrow;
    // }
  }

  Future getRTCToken(
      {required String channel,
      required String role,
      required String tokenType,
      required int uid}) async {
    try {
      var url = "/app/connect/token/$channel/$role/$tokenType/$uid";
      // dynamic payload = {
      //   "senderId": senderId,
      //   "receiverId": receiverId,
      //   "connectId": connectId
      // };
      var response = await api?.post(url: url, isAuthenticated: true);
      return response;
    } catch (e) {
      _processError(e);
      rethrow;
    }
  }

  Future getNewRefreshToken() async {
    try {
      var url = "/app/auth/refreshToken";
      // dynamic payload = {
      //   "senderId": senderId,
      //   "receiverId": receiverId,
      //   "connectId": connectId
      // };
      var response = await api?.getRefreshTok(
        url: url,
      );
      return response;
    } catch (e) {
      _processError(e);
      rethrow;
    }
  }

  Future getOrderInvoice(String orderId) async {
    try {
      const url = "/app/order/invoice";
      dynamic payload = {"orderId": orderId};
      var response =
          await api?.postNew(url: url, payload: payload, isAuthenticated: true);
      debugPrint("//////// $response");
      return response;
    } catch (e) {
      _processError(e);
      rethrow;
    }
  }

  Future postReport(
      {required String receiverId,
      required String connectId,
      required String message}) async {
    try {
      var url = "/app/report";
      dynamic payload = {
        "reportedUser": receiverId,
        "connectId": connectId,
        "message": message
      };
      var response =
          await api?.post(url: url, payload: payload, isAuthenticated: true);
      return response;
    } catch (e) {
      _processError(e);
      rethrow;
    }
  }

  Future getFaqList() async {
    try {
      var url = "/admin/faq";
      var response = await api?.get(url: url, isAuthenticated: true);
      return response;
    } catch (e) {
      _processError(e);
      rethrow;
    }
  }

  Future getFaqDetail({required String id}) async {
    try {
      var url = "/admin/faq$id";
      // dynamic payload = {
      //   "senderId": senderId,
      //   "receiverId": receiverId,
      //   "connectId": connectId
      // };
      var response = await api?.get(url: url, isAuthenticated: true);
      return response;
    } catch (e) {
      _processError(e);
      rethrow;
    }
  }

  Future deleteUser() async {
    try {
      var url = "/app/user/delete";
      // dynamic payload = {
      //   "senderId": senderId,
      //   "receiverId": receiverId,
      //   "connectId": connectId
      // };
      var response = await api?.get(url: url, isAuthenticated: true);
      return response;
    } catch (e) {
      _processError(e);
      rethrow;
    }
  }

  Future getOrderIdForPayment({required String amount}) async {
    try {
      var url = "/app/payment";
      dynamic payload = {"amount": amount};
      var response =
          await api?.post(url: url, payload: payload, isAuthenticated: true);
      return response;
    } catch (e) {
      _processError(e);
      rethrow;
    }
  }

  Future getStatusOfPayment(
      {required String amount, required String orderId}) async {
    try {
      var url = "/app/payment/status/$orderId";
      dynamic payload = {"amount": amount};
      var response =
          await api?.post(url: url, payload: payload, isAuthenticated: true);
      return response;
    } catch (e) {
      _processError(e);
      rethrow;
    }
  }

  Future postPaymentApi({required int amount}) async {
    try {
      var url = "/app/user/wallet/recharge";
      dynamic payload = {"amount": amount};
      var response =
          await api?.post(url: url, payload: payload, isAuthenticated: true);
      return response;
    } catch (e) {
      _processError(e);
      rethrow;
    }
  }
}
