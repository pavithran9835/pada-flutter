import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/colors.dart';
import '../../core/providers/app_provider.dart';

class TermsAndConditionsPage extends StatefulWidget {
  // final dynamic vehicleList;
  const TermsAndConditionsPage({
    super.key,
  });

  @override
  State<TermsAndConditionsPage> createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditionsPage> {

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: lightWhiteColor,
      body: SafeArea(
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
                        child: SingleChildScrollView(
                          child: Column(children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: InkWell(
                                      child: const Icon(
                                        Icons.arrow_back_ios,
                                        color: pureBlack,
                                      ),
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    "Terms and Conditions",
                                    style: GoogleFonts.inter(
                                        color: pureBlack,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.arrow_back_ios,
                                    color: pureWhite,
                                  ),
                                ],
                              ),
                            ),
                            // Padding(
                            //     padding: const EdgeInsets.all(10.0),
                            //     child:  Card(
                            //       child: ListTile(
                            //         onTap: (){},
                            //         leading: SvgPicture.asset(
                            //           'assets/images/call.svg',
                            //           fit: BoxFit.fill,
                            //           height: 15,
                            //           width: 15,
                            //           color: buttonColor,
                            //         ),
                            //         title: Text(
                            //           "+91 9999999999",
                            //           style: GoogleFonts.inter(
                            //               color: pureBlack,
                            //               fontSize: 16,
                            //               fontWeight: FontWeight.w400),
                            //         ),
                            //       ),
                            //     )
                            // ),
                            // Padding(
                            //     padding: const EdgeInsets.all(10.0),
                            //     child:  Card(
                            //       child: ListTile(
                            //         onTap: (){},
                            //         leading: SvgPicture.asset(
                            //           'assets/images/mail.svg',
                            //           fit: BoxFit.fill,
                            //           height: 15,
                            //           width: 15,
                            //           color: buttonColor,
                            //         ),
                            //         title: Text(
                            //           "na@pada.com",
                            //           style: GoogleFonts.inter(
                            //               color: pureBlack,
                            //               fontSize: 16,
                            //               fontWeight: FontWeight.w400),
                            //         ),
                            //       ),
                            //     )
                            // )
                          ]),
                        ),
                      ),
                    ),
                  ))
            ],
          )),
    );
  }
}
