// import 'dart:async';
// import 'package:connectivity/connectivity.dart';
// import 'package:deliverapp/core/services/service_locator.dart';

// final ConnectivityService connectivityService =
//     locator.get<ConnectivityService>();

// class ConnectivityService {
//   StreamController<ConnectivityStatus> connectionStatusController =
//       StreamController<ConnectivityStatus>();

//   ConnectivityService() {
//     Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
//       connectionStatusController.add(_getStatusFromResult(result));
//     });
//   }

//   ConnectivityStatus _getStatusFromResult(ConnectivityResult result) {
//     switch (result) {
//       case ConnectivityResult.mobile:
//         return ConnectivityStatus.cellular;
//       case ConnectivityResult.wifi:
//         return ConnectivityStatus.wifi;
//       case ConnectivityResult.none:
//         return ConnectivityStatus.offline;
//       default:
//         return ConnectivityStatus.wifi;
//     }
//   }
// }

// enum ConnectivityStatus { wifi, cellular, offline }
