import 'dart:convert';

import 'package:deliverapp/routers/router.dart';
import 'package:deliverapp/routers/routing_constants.dart';
import 'package:deliverapp/screens/pada/dashboard_page.dart';
import 'package:deliverapp/screens/pada/wallet_page.dart';
import 'package:deliverapp/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:push/push.dart' as push;
import 'core/colors.dart';
import 'core/providers/providers_list.dart';
import 'core/services/firebase_options.dart';
import 'core/services/navigation_service.dart';
import 'core/services/push_messaging.dart';
import 'core/services/service_locator.dart';
import 'core/services/storage_service.dart';
import 'package:path_provider/path_provider.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp()'
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  setupLocator();
  await storageService.initHiveInApp();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await PushNotificationServiceByPush().setupInteractedMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Handle notification launching app from terminated state
  push.Push.instance.notificationTapWhichLaunchedAppFromTerminated.then((data) {
    if (data == null) {
      print("App was not launched by tapping a notification");
    } else {
      print("App was launched by tapping a notification");
      _handleNavigation(data);
    }
  });

  WidgetsBinding.instance.addPostFrameCallback((_) {});
  await Future.delayed(const Duration(seconds: 2));
  _checkFirstLaunch();
  runApp(App());
  FlutterNativeSplash.remove();
}

void _handleNavigation(Map<String?, dynamic> data) {
  print("Handling navigation with data: $data");

  if (data.containsKey('payload')) {
    Map<String, dynamic> payload = json.decode(data['payload']);
    if (payload.containsKey('body')) {
      Map<String, dynamic> body = json.decode(payload['body']);
      String? type = body['type']?.toString();

      if (type == '1') {
        print("Navigating to Home Screen");
        navigationService.navigatePushNamedAndRemoveUntilTo(
            homeScreenRoute, null);
      } else if (type == '4') {
        // print("Navigating to Order History Screen");
        // Navigator.pushAndRemoveUntil(
        //   navigationService.currentContext,
        //   MaterialPageRoute(builder: (context) => const OrderHistoryPage()),
        //   (Route<dynamic> route) => false,
        // );
      } else if (type == '5') {
        print("Navigating to Dashboard Screen");
        Navigator.pushAndRemoveUntil(
          navigationService.currentContext,
          MaterialPageRoute(builder: (context) => const WalletPage()),
          (Route<dynamic> route) => false,
        );
      } else if (type == '6') {
        print("Navigating to Promotions Screen");
        Navigator.pushAndRemoveUntil(
          navigationService.currentContext,
          MaterialPageRoute(builder: (context) => const DashboardPage()),
          (Route<dynamic> route) => false,
        );
      } else {
        print("Unhandled notification type");
      }
    }
  }
}

Future<void> _checkFirstLaunch() async {
  var isFirstTime = await storageService.getIsFirstTime() ?? "true";

  if (isFirstTime == "true") {
    // Clear cache directory
    final cacheDir = await getTemporaryDirectory();
    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }

    // Clear app's support directory
    final appSupportDir = await getApplicationSupportDirectory();
    if (appSupportDir.existsSync()) {
      appSupportDir.deleteSync(recursive: true);
    }

    storageService.setIsFirstTime("false");
  }
}

class App extends StatefulWidget {
  App({super.key}); // Make it final to ensure it's properly assigned

  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  // final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final navigationService = locator.get<NavigationService>();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers(),
      child: MaterialApp(
        scaffoldMessengerKey: scaffoldMessengerKey,
        builder: (context, child) {
          final myMediaQuery = MediaQuery.of(context);
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                  textScaler: myMediaQuery.textScaler
                      .clamp(minScaleFactor: 0.8, maxScaleFactor: 1.0)),
              child: Stack(
                children: [
                  child!,
                ],
              ));
        },
        title: "PADA DELIVERY",
        theme: ThemeData(
            useMaterial3: false,
            primaryColor: primaryColor,
            scaffoldBackgroundColor: scaffoldBackgroundColor,
            fontFamily: 'openSans',
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
                .copyWith(secondary: accentColor)
                .copyWith(background: backgroundColor)),
        debugShowCheckedModeBanner: false,
        navigatorKey: navigationService.navigatorKey,
        onGenerateRoute: generateRoute,
        home: const SplashScreen(),
      ),
      // ),
    );
  }
}
