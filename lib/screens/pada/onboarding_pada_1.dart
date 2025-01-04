import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors.dart';
import 'login_page.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  void initState() {
    FlutterNativeSplash.remove();
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: greyLight1.withOpacity(0.7)));
    return Scaffold(
        backgroundColor: pureWhite,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height / 50),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: MediaQuery.of(context).size.height * 0.20,
                            child: SvgPicture.asset(
                                'assets/images/onboarding_1.svg',
                                fit: BoxFit.fill)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Text(' Pickup anywhere',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                    color: pureBlack,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w600))),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height / 50),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: MediaQuery.of(context).size.height * 0.20,
                            child: SvgPicture.asset(
                                'assets/images/onboarding_2.svg',
                                fit: BoxFit.fill)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Text('Delivery anywhere',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                    color: pureBlack,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w600))),
                      )
                    ]))));
  }
}
