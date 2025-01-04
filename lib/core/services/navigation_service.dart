import 'package:flutter/material.dart';
import 'package:deliverapp/core/services/service_locator.dart';

final NavigationService navigationService = locator.get<NavigationService>();

class NavigationService {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  get currentContext => _navigatorKey.currentContext;

  Future<dynamic>? navigateTo(String routeName, Object? argument) {
    return _navigatorKey.currentState
        ?.pushNamed(routeName, arguments: argument);
  }

  void navigatePushReplacementNamedTo(String routeName, Object? argument) {
    if (_navigatorKey.currentState != null) {
      _navigatorKey.currentState
          ?.pushReplacementNamed(routeName, arguments: argument);
    }
  }


  void navigatePushNamedAndRemoveUntilTo(String routeName, Object? argument) {
    // if (_navigatorKey.currentState != null) {
    //   debugPrint(".../ ${_navigatorKey.currentContext?.mounted}");
      _navigatorKey.currentState?.pushNamedAndRemoveUntil(
          routeName, (Route<dynamic> route) => false,
          arguments: argument);
    // }
  }

  void navigatePop() {
    return _navigatorKey.currentState?.pop();
  }
}
