import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/colors.dart';
import '../../core/services/notification_service.dart';
import '../../core/utils.dart';
import '../../widgets/button.dart';
import 'otp_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController mobNumberController = TextEditingController();
  bool isFilled = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: pureWhite,
      body: SafeArea(
          child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.45,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: primaryColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.15,
                              height: MediaQuery.of(context).size.height * 0.06,
                              child: SvgPicture.asset(
                                  'assets/images/pada_logo.svg',
                                  fit: BoxFit.fill)),
                          Text("PADA DELIVERY",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                  color: pureWhite,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900))
                        ],
                      ),
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.18,
                        child: SvgPicture.asset('assets/images/login_image.svg',
                            fit: BoxFit.fill))
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                // height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: pureWhite,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.05,
                            height: MediaQuery.of(context).size.height * 0.025,
                            child: SvgPicture.asset('assets/images/hand.svg',
                                fit: BoxFit.fill)),
                        const SizedBox(
                          width: 5,
                        ),
                        Text("WELCOME",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                color: const Color(0xFF737373),
                                fontSize: 22,
                                fontWeight: FontWeight.w800))
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 30),
                    Text(
                        "Enter mobile number", //"To place a delivery order, register using your social media login or OTP mobile number.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w400)),
                    SizedBox(height: MediaQuery.of(context).size.height / 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.07,
                              height: MediaQuery.of(context).size.height * 0.02,
                              child: SvgPicture.asset(
                                  'assets/images/india_flag.svg',
                                  fit: BoxFit.fill)),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: TextField(
                            controller: mobNumberController,
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                color: pureBlack,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                            decoration: InputDecoration(
                                hintStyle: GoogleFonts.inter(
                                    color: pureBlack,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                                counterText: '',
                                hintText: "Mobile Number",
                                border: const UnderlineInputBorder()),
                            onChanged: (str) {
                              if (str.length != 10) {
                                isFilled = false;
                              } else {
                                isFilled = true;
                              }
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: CustomButton(
                          buttonLabel: 'Login',
                          buttonWidth: double.infinity,
                          backGroundColor: buttonColor,
                          onTap: () async {
                            !isFilled
                                ? notificationService.showToast(
                                    context, "Enter valid mobile number",
                                    type: NotificationType.error)
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OtpScreen(
                                        mobNumber: mobNumberController.text,
                                      ),
                                    ),
                                  );
                          },
                        ),
                      ),
                    ),

                    /// ============== Social signin button start ==============
                    ///
                    /*  SizedBox(height: MediaQuery.of(context).size.height / 50),
                    Text("OR",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                            color: const Color(0xFF737373),
                            fontSize: 18,
                            fontWeight: FontWeight.w800)),
                    SizedBox(height: MediaQuery.of(context).size.height / 50),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: SocialSignInButton(
                                  buttonImage: 'assets/images/google.svg',
                                  onTap: () async {
                                    // await signInWithGoogle().then((value) {
                                    //   ApiService()
                                    //       .socialSignIn(
                                    //           socialId:
                                    //               value.credential!.providerId,
                                    //           deviceToken: "deviceToken",
                                    //           email: value.user!.email,
                                    //           displayName:
                                    //               value.user!.displayName)
                                    //       .then((resp) async {
                                    //     if (resp!['success'] == true) {
                                    //       storageService
                                    //           .setActiveConnectionStatus(true);
                                    //       storageService.setAuthToken(
                                    //           resp!['data']['accessToken'] ??
                                    //               '');
                                    //       storageService.setRefreshToken(
                                    //           resp!['data']['refreshToken'] ??
                                    //               '');
                                    //       apiService.setAuthorisation(
                                    //           resp!['data']['accessToken'] ??
                                    //               '');
                                    //
                                    //       await Navigator.pushAndRemoveUntil(
                                    //         context,
                                    //         MaterialPageRoute(
                                    //             builder: (context) =>
                                    //             const DashboardPage()),
                                    //             (Route<dynamic> route) => false,
                                    //       );
                                    //       setState(() {});
                                    //     } else {
                                    //       notificationService.showToast(
                                    //           context, resp['message'],
                                    //           type: NotificationType.error);
                                    //     }
                                    //   });
                                    // });
                                  },
                                  borderColor: pureBlack,
                                  width: 30,
                                  height: 30,
                                  iconWidth: 22,
                                  iconHeight: 22),
                            ),
                            // Padding(
                            //   padding:
                            //       const EdgeInsets.symmetric(horizontal: 5.0),
                            //   child: SocialSignInButton(
                            //       buttonImage: 'assets/images/facebook.svg',
                            //       onTap: () async {
                            //         // await signInWithFacebook();
                            //       },
                            //       borderColor: pureBlack,
                            //       width: 30,
                            //       height: 30,
                            //       iconWidth: 22,
                            //       iconHeight: 22),
                            // ),
                          ]),
                    ),*/

                    /// ============== Social signin button end ==============
                    ///
                    SizedBox(height: MediaQuery.of(context).size.height / 50),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      width: MediaQuery.of(context).size.width,
                      child: Text.rich(
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 3,
                        TextSpan(
                          text: 'By clicking on log in, you agree to the ',
                          style: GoogleFonts.inter(
                              fontSize: 12, color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Terms and Conditions',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  launchURL(Uri.parse(
                                      'https://innlyn.com/terms-and-conditions-and-privacy-policy/')); // Replace with your link URL
                                },
                            ),
                            TextSpan(
                              text: ' and ',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: 'privacy policy.',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  launchURL(Uri.parse(
                                      'https://innlyn.com/terms-and-conditions-and-privacy-policy/')); // Replace with your link URL
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  // Future<UserCredential> signInWithGoogle() async {
  //   // Trigger the authentication flow
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //
  //   // Obtain the auth details from the request
  //   final GoogleSignInAuthentication? googleAuth =
  //       await googleUser?.authentication;
  //
  //   // Create a new credential
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );
  //
  //   // Once signed in, return the UserCredential
  //   return await FirebaseAuth.instance.signInWithCredential(credential);
  // }

  // Future<UserCredential> signInWithFacebook() async {
  //   // Trigger the sign-in flow
  //   final LoginResult loginResult = await FacebookAuth.instance.login();
  //
  //   // Create a credential from the access token
  //   final OAuthCredential facebookAuthCredential =
  //       FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);
  //
  //   // Once signed in, return the UserCredential
  //   return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  // }
}
