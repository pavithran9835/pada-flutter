import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../constants.dart';
import '../models/connector_model.dart';
import '../models/create_connect_response.dart';
import '../models/user_profile_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../services/storage_service.dart';

class AppProvider extends ChangeNotifier {
  AddressModel? pickupAddress;
  AddressModel? dropAddress;
  UserProfileModel userDetails = UserProfileModel("Guest", "", "", "", 1, "");
  ReqAcceptModel? acceptedData;
  late IO.Socket? socketIO;
  setPickupAddress(AddressModel source) {
    print("dest string::: $source");
    pickupAddress = source;
    notifyListeners();
  }

  double latitude = 0.0;
  double longitude = 0.0;

  setLatLong({required double lat, required double lng}) {
    print("set latlng::: $lat, $lng");
    latitude = lat;
    longitude = lng;
    notifyListeners();
  }

  Placemark? currentLocationAddress;
  setCurrentLocationAddress({required Placemark address}) {
    currentLocationAddress = address;
    notifyListeners();
  }

  setDropAddress(AddressModel destination) {
    print("dest string::: $destination");
    dropAddress = destination;
    notifyListeners();
  }

  setAcceptedData(ReqAcceptModel data) {
    print("ReqAcceptModel string::: $data");
    acceptedData = data;
    notifyListeners();
  }
  // DataCreateConnect dataCreateConnect = DataCreateConnect();

  // Future<IO.Socket> socketConnect() async {
  //   String? token = await storageService.getAuthToken();
  //   IO.Socket socket = IO.io(
  //       'http://13.233.100.215:7000',
  //       OptionBuilder().setExtraHeaders({
  //         'x-api-key': xApiKey,
  //         'Authorization': "Bearer ${token!}",
  //         'autoConnect': false
  //       }).setTransports(['websocket']).build());
  //   socket.onError((data) {
  //     print("socket error in connect===================//==//== $data");
  //   });
  //   return socket;
  // }
  Future socketConnect() async {
    String? token = await storageService.getAuthToken();
    socketIO = IO.io(
        'http://13.233.100.215:7000',
        OptionBuilder().setExtraHeaders({
          'x-api-key': xApiKey,
          'Authorization': "Bearer ${token!}",
          'autoConnect': false
        }).setTransports(['websocket']).build());
    print('<=========== SOCKET CONNECTED: ${socketIO!.id}===========>');
    socketIO!.onError((data) {
      print("socketIO error in connect===================//==//== $data");
    });
    notifyListeners();
  }

  void socketEmit(
      IO.Socket socket, String event, dynamic data, dynamic appProvider) async {
    socket.onConnect((_) {
      if (kDebugMode) {
        print('<=========== SOCKET CONNECTED: ${socket.id}===========>');
      }
      socket.emit(event, data);
    });
  }

  // Future<Stream> socketListen(IO.Socket socket, String event, dynamic appProvider) async {
  //   socket.onConnect((_) {
  //     // if (kDebugMode) {
  //       print('<=========== SOCKET LISTENING: ${socket.id}===========>');
  //     // }
  //   return  socket.on(event, (data) {
  //       return data;
  //     });
  //   });
  // }

  void socketDisConnect(
      IO.Socket socket, String event, dynamic appProvider) async {
    socket.onDisconnect((_) {
      if (kDebugMode) {
        print('<=========== SOCKET DISCONNECTED ===========>');
      }
    });
  }
}
