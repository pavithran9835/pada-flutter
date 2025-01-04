// import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:deliverapp/core/constants.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../core/colors.dart';
import '../../core/providers/app_provider.dart';
import '../../core/services/api_service.dart';
import '../../core/services/notification_service.dart';
import '../../widgets/button.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../widgets/loading_indicator.dart';

class WalletPage extends StatefulWidget {
  // final dynamic vehicleList;
  const WalletPage({
    super.key,
  });

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  num walletBal = 0.0;
  final TextEditingController _controller = TextEditingController();
  String amount1 = "100";
  String amount2 = "200";
  String amount3 = "500";
  bool isWeb = false;
  bool addSuccess = false;
  dynamic userDetails;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // userData();
  }

  // void userData() async {
  //   await ApiService().getUserProfile().then((value) {
  //     if (value['success']) {
  //       userDetails = value['data'];
  //       walletBal = userDetails['wallet'];
  //       setState(() {});
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: lightWhiteColor,
      body: /*isWeb
          ?  InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri("https://rzp.io/i/ziQSO3I")),

      )
          :*/
          SafeArea(
              child: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              child: Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 0.95,
              child: Card(
                color: Colors.white,
                child: FutureBuilder(
                    future: ApiService().getUserProfile(),
                    builder: (context, snapShotData) {
                      if (snapShotData.hasData) {
                        if (snapShotData.data['success']) {
                          userDetails = snapShotData.data['data'];
                          walletBal = userDetails['wallet'];
                        }
                        return SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    "Wallet",
                                    style: GoogleFonts.inter(
                                        color: pureBlack,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20.0, horizontal: 10),
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                      width: MediaQuery.of(context).size.width,
                                      child: Card(
                                          elevation: 4,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Wallet Balance",
                                                      style: GoogleFonts.inter(
                                                          color: pureBlack,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5.0),
                                                      child: Text(
                                                        "Balance $rupeeSymbol $walletBal",
                                                        style: GoogleFonts.inter(
                                                            color:
                                                                addressTextColor,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.025,
                                                  child: CustomButton(
                                                      borderRadius: 5,
                                                      buttonLabel: "Add Money",
                                                      backGroundColor:
                                                          buttonColor,
                                                      onTap: () {
                                                        showModalBottomSheet(
                                                            context: context,
                                                            builder: (context) {
                                                              return SafeArea(
                                                                child: SizedBox(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.27,
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.95,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            15.0),
                                                                        child:
                                                                            Text(
                                                                          "Add Money",
                                                                          style: GoogleFonts.inter(
                                                                              color: pureBlack,
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.w500),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            left:
                                                                                15.0),
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              MediaQuery.of(context).size.width * 0.4,
                                                                          height:
                                                                              MediaQuery.of(context).size.height * 0.05,
                                                                          child:
                                                                              TextField(
                                                                            controller:
                                                                                _controller,
                                                                            keyboardType:
                                                                                TextInputType.number,
                                                                            maxLength:
                                                                                10,
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                            style: GoogleFonts.inter(
                                                                                color: pureBlack,
                                                                                fontSize: 18,
                                                                                fontWeight: FontWeight.w400),
                                                                            decoration: InputDecoration(
                                                                                hintStyle: GoogleFonts.inter(color: greyBorderColor, fontSize: 16, fontWeight: FontWeight.w400),
                                                                                counterText: '',
                                                                                hintText: "Enter amount",
                                                                                border: OutlineInputBorder(borderSide: const BorderSide(color: greyBorderColor, width: 1), borderRadius: BorderRadius.circular(10))),
                                                                            onChanged:
                                                                                (str) {
                                                                              // if (str.length != 10) {
                                                                              //   isFilled = false;
                                                                              // } else {
                                                                              //   isFilled = true;
                                                                              // }
                                                                              setState(() {});
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            vertical:
                                                                                10.0),
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              MediaQuery.of(context).size.width * 0.5,
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceEvenly,
                                                                            children: [
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  _controller.text = amount1;
                                                                                },
                                                                                child: Container(
                                                                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: greyBorderColor.withOpacity(0.5)),
                                                                                  child: Text(
                                                                                    "+ $amount1",
                                                                                    style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  _controller.text = amount2;
                                                                                },
                                                                                child: Container(
                                                                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: greyBorderColor.withOpacity(0.5)),
                                                                                  child: Text(
                                                                                    "+ $amount2",
                                                                                    style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  _controller.text = amount3;
                                                                                },
                                                                                child: Container(
                                                                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: greyBorderColor.withOpacity(0.5)),
                                                                                  child: Text(
                                                                                    "+ $amount3",
                                                                                    style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const Divider(
                                                                        color:
                                                                            greyBorderColor,
                                                                        thickness:
                                                                            1,
                                                                      ),
                                                                      const Spacer(),
                                                                      SafeArea(
                                                                        child: Align(
                                                                            alignment: Alignment.center,
                                                                            child: SizedBox(
                                                                                height: MediaQuery.of(context).size.height * 0.05,
                                                                                child: CustomButton(
                                                                                    buttonLabel: "Proceed",
                                                                                    backGroundColor: buttonColor,
                                                                                    onTap: () async {
                                                                                      if (_controller.text == "" || _controller.text.isEmpty) {
                                                                                        if (mounted) {
                                                                                          notificationService.showToast(context, "Please enter amount to process", type: NotificationType.error);
                                                                                        }
                                                                                      } else {
                                                                                        // var result = await (Connectivity().checkConnectivity());
                                                                                        // if (result == ConnectivityResult.wifi || result == ConnectivityResult.mobile) {
                                                                                        if (context.mounted) {
                                                                                          LoadingOverlay.of(context).show();
                                                                                          await ApiService().postPaymentApi(amount: int.parse(_controller.text)).then((value) {
                                                                                            print("sksksk:: $value");
                                                                                            Navigator.push(
                                                                                                context,
                                                                                                MaterialPageRoute(
                                                                                                    builder: (context) => WalletWebView(
                                                                                                          webUrl: value['data']['liink'],
                                                                                                        ))).then((onValue) {
                                                                                              LoadingOverlay.of(context).hide();
                                                                                              addSuccess = true;
                                                                                              setState(() {});
                                                                                              Future.delayed(const Duration(seconds: 2), () {
                                                                                                setState(() {
                                                                                                  addSuccess = false;
                                                                                                });
                                                                                              });

                                                                                              Navigator.pop(context);
                                                                                            });
                                                                                          });
                                                                                        }
                                                                                        // } else {
                                                                                        //   if (context.mounted) {
                                                                                        //     notificationService.showToast(context, "Please check your Internet Connection", type: NotificationType.error);
                                                                                        //   }
                                                                                        // }
                                                                                      }
                                                                                    },
                                                                                    buttonWidth: MediaQuery.of(context).size.width * 0.9))),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            });
                                                      },
                                                      buttonTextSize: 12,
                                                      buttonWidth: 100),
                                                )
                                              ],
                                            ),
                                          )),
                                    )),
                              ]),
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
              ),
            ),
          )),
          addSuccess
              ? Positioned(
                  right: 8,
                  child: Lottie.asset(
                    'assets/images/succesGif.json', // Replace with your Lottie success animation
                    width: 50,
                    height: 50,
                    repeat: false,
                  ),
                )
              : Offstage(),
        ],
      )),
    );
  }
}

class WalletWebView extends StatefulWidget {
  const WalletWebView({super.key, required this.webUrl});
  final String webUrl;

  @override
  State<WalletWebView> createState() => _WalletWebViewState();
}

class _WalletWebViewState extends State<WalletWebView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: InAppWebView(
        onLoadStart: (con, uri) {
          LoadingOverlay.of(context).show();
        },
        onLoadStop: (con, uri) {
          LoadingOverlay.of(context).hide();
        },
        initialUrlRequest: URLRequest(url: WebUri(widget.webUrl)),
      ),
    ));
  }
}
