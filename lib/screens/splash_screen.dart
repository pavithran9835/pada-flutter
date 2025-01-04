import 'dart:io';

import 'package:deliverapp/screens/pada/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:deliverapp/screens/pada/dashboard_page.dart';
import 'package:deliverapp/screens/pada/onboarding_pada_1.dart';
import 'package:provider/provider.dart';

import '../core/colors.dart';
import '../core/providers/auth_provider.dart';
import '../core/services/api_service.dart';
import '../core/services/storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    _checkFirstLaunch();
    super.didChangeDependencies();
  }

  Future<void> _checkFirstLaunch() async {
    var isFirstTime = await storageService.getIsFirstTime() ?? "true";

    if (isFirstTime == 'true') {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.clearLoginCredentials();
      storageService.setIsFirstTime("false");
      authCheck();
      print("first time");
    } else {
      authCheck();
      print("Not first time");
    }
  }

  authCheck() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      bool authStatus = await authProvider.checkAuthState();
      var userDetails;

      if (authStatus) {
        // if (false) {
        storageService.setStartLocString("");
        storageService.setEndLocString("");
        if (mounted) {
          await ApiService().getUserProfile().then((value) {
            if (value['success']) {
              userDetails = value['data'];
              debugPrint("prof::===>> $value");
            }
          });
          if (userDetails['firstName'] != null &&
              userDetails['firstName'] != '') {
            await Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const DashboardPage()),
              (Route<dynamic> route) => false,
            );
          } else {
            await Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => RegistrationPage(
                      mobNumber: userDetails['phoneNumber'].toString())),
              (Route<dynamic> route) => false,
            );
          }
        }
      } else {
        if (mounted) {
          await Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const OnBoardingScreen()),
            (Route<dynamic> route) => false,
          );
        }
      }
    } catch (e) {
      print("error auth:: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: greyLight1.withOpacity(0.7)));
    return const Scaffold(
      backgroundColor: pureWhite,
      resizeToAvoidBottomInset: false,
    );
  }
}
