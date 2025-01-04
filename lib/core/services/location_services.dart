import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:deliverapp/core/services/service_locator.dart';
import 'package:deliverapp/core/services/storage_service.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

final LocationService locationService = locator.get<LocationService>();

class LocationService {
  // StreamController<geo.LocationPermission> locationPermissionController =
  // StreamController<geo.LocationPermission>();
  // bool gpsStatus = true;
  //
  // StreamSubscription<geo.ServiceStatus> serviceStatusStream =
  // geo.Geolocator.getServiceStatusStream().listen((geo.ServiceStatus status) {});
  //
  // requestLocationPermission() async {
  //   geo.LocationPermission permission, permissionNew;
  //   permission = await geo.Geolocator.checkPermission();
  //   if (permission == geo.LocationPermission.denied) {
  //     permissionNew = await geo.Geolocator.requestPermission();
  //     locationPermissionController.add(permissionNew);
  //   } else if (permission == geo.LocationPermission.deniedForever ||
  //       permission == geo.LocationPermission.unableToDetermine) {
  //     locationPermissionController.add(permission);
  //   } else {
  //     locationPermissionController.add(permission);
  //     geo.Geolocator.getCurrentPosition();
  //   }
  // }

  StreamSubscription<geo.Position> positionStream(BuildContext context) {
    return geo.Geolocator.getPositionStream(
        locationSettings: const geo.LocationSettings(
          distanceFilter: 50,
        )).listen((geo.Position? position) async {
      final appProvider = Provider.of<AppProvider>(
          context,
          listen: false);
      if (position != null) {
        if (kDebugMode) {
          print(" POSITION ACCURACY ${position.accuracy} METERS");
        }
        storageService.setLatitude(position.latitude.toString());
        storageService.setLongitude(position.longitude.toString());

        // appProvider.setLatLong(
        //     lat: position.latitude.toString(),
        //     lng: position.longitude.toString());

      } else {
        String lat, lng;
        lat = await storageService.getLatitude() ?? '0.0000';
        lng = await storageService.getLongitude() ?? '0.0000';
        // appProvider.setLatLong(lat: lat, lng: lng);
      }
      if (kDebugMode) {
        print(position == null
            ? 'CANNOT FETCH LOCATION'
            : 'LOCATION UPDATED ${position.latitude.toString()}, ${position.longitude.toString()}');
      }
    });
  }

}
