import 'package:deliverapp/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors.dart';
import 'bottom_navigation_page.dart';

class NotAcceptedPage extends StatelessWidget {
  const NotAcceptedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: pureWhite,
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Not Accepted",
                          style: GoogleFonts.inter(
                              color: pureBlack,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: SizedBox(
                            child: CustomButton(
                                buttonLabel: "Go to HomePage",
                                backGroundColor: buttonColor,
                                onTap: () {
                                  if (context.mounted) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const BottomNavPage()),
                                    );
                                  }
                                },
                                buttonWidth:
                                    MediaQuery.of(context).size.width * 0.6),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ))
        ],
      )),
    );
  }
}
