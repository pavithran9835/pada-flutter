import 'package:deliverapp/screens/pada/bottom_navigation_page.dart';
import 'package:deliverapp/screens/pada/login_page.dart';
import 'package:deliverapp/screens/pada/not_accepted_page.dart';
import 'package:deliverapp/screens/pada/order_history_page.dart';
import 'package:deliverapp/screens/pada/wallet_page.dart';
import 'package:flutter/material.dart';
import 'package:deliverapp/routers/routing_constants.dart';
import 'package:page_transition/page_transition.dart';

import '../screens/pada/order_accepted_page.dart';
import '../screens/splash_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case splashScreenRoute:
      return PageTransition(
          type: PageTransitionType.rightToLeft,
          child: const SplashScreen(),
          isIos: true,
          settings: settings,
          duration: const Duration(milliseconds: 500));

    case homeScreenRoute:
      return PageTransition(
          type: PageTransitionType.rightToLeft,
          child: const BottomNavPage(),
          isIos: true,
          settings: settings,
          duration: const Duration(milliseconds: 500));

    case loginScreenRoute:
      return PageTransition(
          type: PageTransitionType.rightToLeft,
          child: const LoginPage(),
          isIos: true,
          settings: settings,
          duration: const Duration(milliseconds: 500));

    case onAcceptScreenRoute:
      return PageTransition(
          type: PageTransitionType.rightToLeft,
          child: const OrderAcceptedPage(),
          isIos: true,
          settings: settings,
          duration: const Duration(milliseconds: 500));

    case orderHistoryScreenRoute:
      return PageTransition(
          type: PageTransitionType.rightToLeft,
          child: const OrderHistoryPage(),
          isIos: true,
          settings: settings,
          duration: const Duration(milliseconds: 500));

    case notAcceptScreenRoute:
      return PageTransition(
          type: PageTransitionType.rightToLeft,
          child: const NotAcceptedPage(),
          isIos: true,
          settings: settings,
          duration: const Duration(milliseconds: 500));

    case paymentScreenRoute:
      return PageTransition(
          type: PageTransitionType.rightToLeft,
          child: const WalletPage(),
          isIos: true,
          settings: settings,
          duration: const Duration(milliseconds: 500));

    default:
      return PageTransition(
          type: PageTransitionType.rightToLeft,
          child: const BottomNavPage(),
          isIos: true,
          settings: settings,
          duration: const Duration(milliseconds: 500));
  }
}
