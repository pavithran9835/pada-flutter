import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/services/api_service.dart';
import '../../core/services/navigation_service.dart';
import '../../routers/routing_constants.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  var bannerList = [];
  getBannerList() async {
    var resp = await ApiService().getBannerImage("external");
    debugPrint("banner List::::: $resp");
    bannerList = resp['data'];
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBannerList();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: pureWhite,
      body: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
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
                ],
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  bannerList.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: CarouselSlider(
                              items: [
                                for (int i = 0; i < bannerList.length; i++) ...{
                                  SizedBox(
                                      child: bannerList[i]['image']
                                              .toString()
                                              .contains(".svg")
                                          ? SvgPicture.network(
                                              '$imageUrl${bannerList[i]['image']}',
                                              fit: BoxFit.contain)
                                          : Image.network(
                                              '$imageUrl${bannerList[i]['image']}',
                                              fit: BoxFit.contain)),
                                }
                              ],
                              options: CarouselOptions(
                                height:
                                    MediaQuery.of(context).size.height * 0.22,
                                aspectRatio: 16 / 9,
                                viewportFraction: 1,
                                initialPage: 0,
                                enableInfiniteScroll: true,
                                reverse: false,
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 5),
                                autoPlayAnimationDuration:
                                    const Duration(milliseconds: 800),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enlargeCenterPage: true,
                                enlargeFactor: 0.3,
                                scrollDirection: Axis.horizontal,
                              )),
                        )
                      : const Offstage(),
                  // Padding(
                  //   padding: const EdgeInsets.all(5.0),
                  //   child: SizedBox(
                  //     height: 50,
                  //     width: MediaQuery.of(context).size.width * 0.8,
                  //     child: CustomButton(
                  //         buttonLabel: "Goods Delivery",
                  //         backGroundColor: buttonColor,
                  //         onTap: () {
                  //           navigationService.navigatePushNamedAndRemoveUntilTo(
                  //               homeScreenRoute, null);
                  //           // if (context.mounted) {
                  //           //   Navigator.pushAndRemoveUntil(
                  //           //     context,
                  //           //     MaterialPageRoute(
                  //           //         builder: (context) => const BottomNavPage()),
                  //           //     (Route<dynamic> route) => false,
                  //           //   );
                  //           // }
                  //         },
                  //         fontWeight: FontWeight.bold,
                  //         buttonWidth: double.infinity),
                  //   ),
                  // ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: InkWell(
                      onTap: () {
                        navigationService.navigatePushNamedAndRemoveUntilTo(
                            homeScreenRoute, null);
                        // if (context.mounted) {
                        //   Navigator.pushAndRemoveUntil(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => const BottomNavPage()),
                        //     (Route<dynamic> route) => false,
                        //   );
                        // }
                      },
                      child: Card(
                        elevation: 2,
                        shadowColor: secondaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                                width: 2, color: secondaryColor)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  child: SvgPicture.asset(
                                      'assets/images/delivery_bike.svg',
                                      fit: BoxFit.contain)),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 5.0),
                                      child: Text(
                                        "Goods Delivery",
                                        style: GoogleFonts.inter(
                                            color: secondaryColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(5.0),
                  //   child: SizedBox(
                  //     height: 50,
                  //     width: MediaQuery.of(context).size.width * 0.8,
                  //     child: CustomButton(
                  //         buttonLabel: "Express Delivery",
                  //         backGroundColor: buttonColor,
                  //         onTap: () async {
                  //           authProvider.clearLoginCredentials();
                  //           if (context.mounted) {
                  //             Navigator.pushAndRemoveUntil(
                  //               context,
                  //               MaterialPageRoute(
                  //                   builder: (context) =>
                  //                       const LoginPage()),
                  //               (Route<dynamic> route) => false,
                  //             );
                  //           }
                  //         },
                  //         fontWeight: FontWeight.bold,
                  //         buttonWidth: double.infinity),
                  //   ),
                  // ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
