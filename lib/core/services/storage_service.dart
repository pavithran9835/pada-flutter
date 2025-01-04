import 'package:hive_flutter/hive_flutter.dart';
import 'package:deliverapp/core/services/service_locator.dart';

import '../constants.dart';

final StorageService storageService = locator.get<StorageService>();

class StorageService {
  Future initHiveInApp() async {
    await Hive.initFlutter();
    await Hive.openBox(hiveBoxName);
  }

  clearBox() async {
    var box = Hive.box(hiveBoxName);
    box.clear();
  }

  void setStartLocString(String loc) async {
    try {
      var box = Hive.box(hiveBoxName);
      box.put('START_LOCATION', loc);
      print("START_LOCATION set success");
    } catch (e) {
      rethrow;
    }
  }

  Future<String>? getStartLoc() async {
    try {
      var box = Hive.box(hiveBoxName);
      String token = box.get('START_LOCATION');
      return token;
    } catch (e) {
      rethrow;
    }
  }

  void setEndLocString(String loc) async {
    try {
      var box = Hive.box(hiveBoxName);
      box.put('END_LOCATION', loc);
      print("END_LOCATION set success");
    } catch (e) {
      rethrow;
    }
  }

  Future<String>? getEndLoc() async {
    try {
      var box = Hive.box(hiveBoxName);
      String token = box.get('END_LOCATION');
      return token;
    } catch (e) {
      rethrow;
    }
  }

  void setIsFirstTime(String data) async {
    try {
      var box = Hive.box(hiveBoxName);
      box.put('IS_FIRST_TIME', data);
      print("Token set success");
    } catch (e) {
      rethrow;
    }
  }
  Future<dynamic>? getIsFirstTime() async {
    try {
      var box = Hive.box(hiveBoxName);
      var token = box.get('IS_FIRST_TIME');
      return token;
    } catch (e) {
      rethrow;
    }
  }

  void setNotificationAsk(String data) async {
    try {
      var box = Hive.box(hiveBoxName);
      box.put('NOTIFICATION_ASK', data);
      print("notification permission asked");
    } catch (e) {
      rethrow;
    }
  }
  Future<String>? getNotificationAsk() async {
    try {
      var box = Hive.box(hiveBoxName);
      var value = box.get('NOTIFICATION_ASK');
      return value??"false";
    } catch (e) {
      rethrow;
    }
  }

  Future<String>? getAuthToken() async {
    try {
      var box = Hive.box(hiveBoxName);
      String token = box.get('TOKEN_STORE_KEY');
      return token;
    } catch (e) {
      rethrow;
    }
  }

  Future<String>? getRefreshToken() async {
    try {
      var box = Hive.box(hiveBoxName);
      String token = box.get('REFRESH_TOKEN');
      return token;
    } catch (e) {
      rethrow;
    }
  }

  void setAuthToken(String token) async {
    try {
      var box = Hive.box(hiveBoxName);
      box.put('TOKEN_STORE_KEY', token);
      print("Token set success");
    } catch (e) {
      rethrow;
    }
  }

  void setRefreshToken(String token) async {
    try {
      var box = Hive.box(hiveBoxName);
      box.put('REFRESH_TOKEN', token);
      print("Token set success");
    } catch (e) {
      rethrow;
    }
  }

  void setLatitude(String value) async {
    try {
      var box = Hive.box(hiveBoxName);
      box.put(latitudeHiveKey, value);
    } catch (e) {
      rethrow;
    }
  }

  Future<String?>? getLatitude() async {
    try {
      var box = Hive.box(hiveBoxName);
      String? value = box.get(latitudeHiveKey);

      return value;
    } catch (e) {
      rethrow;
    }
  }

  void setLongitude(String value) async {
    try {
      var box = Hive.box(hiveBoxName);
      box.put(longitudeHiveKey, value);
    } catch (e) {
      rethrow;
    }
  }

  Future<String?>? getLongitude() async {
    try {
      var box = Hive.box(hiveBoxName);
      String? value = box.get(longitudeHiveKey);

      return value;
    } catch (e) {
      rethrow;
    }
  }
}
