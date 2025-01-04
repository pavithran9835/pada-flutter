import 'dart:io';

import 'package:deliverapp/core/errors/exceptions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:deliverapp/screens/pada/registration_page.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../core/colors.dart';
import '../../core/models/get_otp_response.dart';
import '../../core/models/mobile_sign_in_response.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/services/api_service.dart';
import '../../core/services/notification_service.dart';
import '../../core/services/storage_service.dart';
import '../../widgets/button.dart';
import '../../widgets/loading_indicator.dart';
import 'dashboard_page.dart';
import 'login_page.dart';

class OtpScreen extends StatefulWidget {
  final String mobNumber;
  const OtpScreen({super.key, required this.mobNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  bool isFilled = false;
  bool buttonLoading = false;
  TextEditingController otpController = TextEditingController();
  String? otp = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOtp();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future getOtp() async {
    String? token = '998089090909900';
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      if (Platform.isAndroid) {
        await Firebase.initializeApp();
        token = await FirebaseMessaging.instance.getToken();
      }
      otpController.clear();
      authProvider.otpReceived = '';
      var response = await authProvider.getOtp(phoneNumber: widget.mobNumber);
      print("ress:: $response");
      GetOtpResponse getOtpResponse = GetOtpResponse.fromJson(response);
      if (getOtpResponse.success ?? false) {
        authProvider.setPhoneNumber(
            phone: getOtpResponse.data?.phoneNumber ?? '');
        print("ress:: ${getOtpResponse.data?.verificationCode.toString()}");
        authProvider.setOtp(
            otp: getOtpResponse.data?.verificationCode.toString() ?? '');
        authProvider.setDeviceToken(deviceTokenFromResponse: token!);
        // authProvider.setDeviceToken(
        //     deviceTokenFromResponse:
        //         DateTime.now().millisecondsSinceEpoch.toString());
        if (authProvider.otpReceived != '') {
          // otpController.text = authProvider.otpReceived;
          otp =  authProvider.otpReceived;
          isFilled = true;
          setState(() {});
        }
      } else {
        notificationService.showToast(context, getOtpResponse.message,
            type: NotificationType.error);
      }
    } catch (e) {
      // notificationService.showToast(context, e.toString(), type: NotificationType.error);
      if (e is ClientException) {
        notificationService.showToast(context, e.message,
            type: NotificationType.error);
      }
      if (e is HttpException) {
        notificationService.showToast(context, e.message,
            type: NotificationType.error);
      }
      if (e is ServerException) {
        notificationService.showToast(context, e.message,
            type: NotificationType.error);
      }
    }
  }

  Future mobileSignIn() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      setState(() {
        buttonLoading = true;
      });
      LoadingOverlay.of(context).show();
      var response = await authProvider.mobileSignIn(
          otp: otpController.text.trim().toString());
      LoadingOverlay.of(context).hide();
      print("resssss::::${response.toString()}");
      MobileSignInResponse mobileSignInResponse =
          MobileSignInResponse.fromJson(response);
      if (mobileSignInResponse.success ?? false) {
        storageService
            .setAuthToken(mobileSignInResponse.data?.accessToken ?? '');
        storageService
            .setRefreshToken(mobileSignInResponse.data?.refreshToken ?? '');
        apiService
            .setAuthorisation(mobileSignInResponse.data?.accessToken ?? '');
        setState(() {
          buttonLoading = false;
        });
        if (mobileSignInResponse.data!.user!.firstName == '') {
          if (mounted) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RegistrationPage(
                          mobNumber: widget.mobNumber,
                        )));
          }
        } else {
          if (mounted) {
            storageService.setStartLocString("");
            storageService.setEndLocString("");

            await Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const DashboardPage()),
              (Route<dynamic> route) => false,
            );
          }
        }
      } else {
        setState(() {
          buttonLoading = false;
        });
        if (mounted) {
          LoadingOverlay.of(context).hide();
          notificationService.showToast(context, mobileSignInResponse.message,
              type: NotificationType.error);
        }
      }
    } catch (e) {
      setState(() {
        buttonLoading = false;
      });
      if (mounted) {
        LoadingOverlay.of(context).hide();
        if (e is ClientException) {
          print("errorr::::${e.message.toString()}");
          notificationService.showToast(context, e.message.toString(),
              type: NotificationType.error);
        } else if (e is ServerException) {
          print("errorr::::${e.message.toString()}");
          notificationService.showToast(context, e.message.toString(),
              type: NotificationType.error);
        } else if (e is HttpException) {
          print("errorr::::${e.message.toString()}");
          notificationService.showToast(context, e.message.toString(),
              type: NotificationType.error);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: pureWhite,
      body: otp == ''
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.35,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          color: primaryColor,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.15,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.06,
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
                          ],
                        ),
                      ),
                      Container(
                        // height: MediaQuery.of(context).size.height * 0.5,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          color: pureWhite,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.08,
                                    height: MediaQuery.of(context).size.height *
                                        0.02,
                                    child: SvgPicture.asset(
                                        'assets/images/india_flag.svg',
                                        fit: BoxFit.fill)),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(widget.mobNumber.toString(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                        color: pureBlack,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  child: Text("CHANGE",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(
                                          color: changeOTPColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400)),
                                  onTap: () async {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()),
                                      (Route<dynamic> route) => false,
                                    );
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 30),
                            Text(
                                "One Time Password (OTP) has been sent to this number",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300)),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: PinCodeTextField(
                                appContext: context,
                                pastedTextStyle: GoogleFonts.poppins(
                                    color: pureBlack,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400),
                                textStyle: GoogleFonts.poppins(
                                    color: pureBlack,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400),
                                backgroundColor: pureWhite,
                                length: otp!.length,
                                obscureText: false,
                                blinkWhenObscuring: true,
                                animationType: AnimationType.fade,
                                validator: (v) {
                                  if (v!.length < otp!.length) {
                                    return "";
                                  } else {
                                    return null;
                                  }
                                },
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(5),
                                  fieldHeight: 50,
                                  fieldWidth: 50,
                                  activeFillColor: pureWhite,
                                  selectedColor: greyText,
                                  selectedFillColor: pureWhite,
                                  inactiveColor: greyText,
                                  disabledColor: Colors.brown,
                                  activeColor: greyText,
                                  inactiveFillColor: pureWhite,
                                  errorBorderColor: Colors.red,
                                ),
                                cursorColor: pureBlack,
                                animationDuration:
                                    const Duration(milliseconds: 300),
                                enableActiveFill: true,
                                controller: otpController,
                                keyboardType: TextInputType.number,
                                boxShadows: const [
                                  BoxShadow(
                                    offset: Offset(0, 0),
                                    color: greyColor,
                                    blurRadius: 0.5,
                                  )
                                ],
                                onCompleted: (v) {
                                  print("Completed");
                                },
                                // onTap: () {
                                //   print("Pressed");
                                // },
                                onChanged: (value) {},
                                beforeTextPaste: (text) {
                                  print("Allowing to paste $text");
                                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                  //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                  return true;
                                },
                              ),
                              /*
                              * PinCodeTextField(
                                appContext: context,
                                pastedTextStyle: GoogleFonts.poppins(
                                    color: pureBlack, fontSize: 18, fontWeight: FontWeight.w400),
                                textStyle: GoogleFonts.poppins(
                                    color: pureBlack, fontSize: 18, fontWeight: FontWeight.w400),
                                backgroundColor: pureWhite,
                                length: otp!.length,
                                obscureText: false,
                                blinkWhenObscuring: true,
                                animationType: AnimationType.fade,
                                validator: (v) {
                                  // Only validate after user starts typing
                                  if (v == null || v.isEmpty) {
                                    return null; // No error for initial state or empty input
                                  } else if (v.length < otp!.length) {
                                    return ""; // Error for incomplete input
                                  }
                                  return null; // Valid input
                                },
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(5),
                                  fieldHeight: 50,
                                  fieldWidth: 50,
                                  activeFillColor: pureWhite,
                                  selectedColor: greyText,
                                  selectedFillColor: pureWhite,
                                  inactiveColor: greyText,
                                  disabledColor: Colors.brown,
                                  activeColor: greyText,
                                  inactiveFillColor: pureWhite,
                                  errorBorderColor: Colors.red,
                                ),
                                cursorColor: pureBlack,
                                animationDuration: const Duration(milliseconds: 300),
                                enableActiveFill: true,
                                controller: otpController,
                                keyboardType: TextInputType.number,
                                boxShadows: const [
                                  BoxShadow(
                                    offset: Offset(0, 0),
                                    color: greyColor,
                                    blurRadius: 0.5,
                                  )
                                ],
                                onCompleted: (v) {
                                  print("Completed");
                                },
                                onChanged: (value) {
                                  setState(() {
                                    isFilled = value.length == otp!.length;
                                  });
                                },
                                beforeTextPaste: (text) {
                                  print("Allowing to paste $text");
                                  return true; // Allow pasting
                                },
                              ),
                              * */
                            ),
                            SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: CustomButton(
                                        loading: buttonLoading,
                                        buttonLabel: 'Verify',
                                        buttonWidth: double.infinity,
                                        backGroundColor: !isFilled
                                            ? Colors.grey
                                            : buttonColor,
                                        onTap: isFilled
                                            ? () async {
                                                await mobileSignIn();
                                              }
                                            : () {}))),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 20),
                            InkWell(
                              onTap: () async {
                                await getOtp();
                              },
                              child: Text("Resend OTP",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                      color: resendOTPColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 50),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
    );
  }
}
