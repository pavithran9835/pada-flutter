import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:deliverapp/core/services/api_service.dart';
import 'package:deliverapp/core/services/notification_service.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:deliverapp/screens/pada/review_page.dart';
import 'package:deliverapp/screens/pada/subVehicle_list_page.dart';
import 'package:deliverapp/widgets/button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../core/providers/app_provider.dart';
import '../../core/services/storage_service.dart';
import '../../core/utils.dart';
import '../../widgets/alert_dialog_widget.dart';
import '../../widgets/loading_indicator.dart';
import 'map_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var vehicleList;
  var bannerList = [];
  int? _selectedVehicle;
  bool isLocationEnabled = false;
  bool isLocationEnabledChecked = false;
  bool isLoaded = false;
  double? latMe;
  double? longMe;
  TextEditingController fromLocController = TextEditingController();
  TextEditingController toLocController = TextEditingController();
  // BottomNavigationBar? _bottomNavigationBar;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      handlePermissions(); // Sequentially handle permissions after the first frame
    });
    getVehicleList();
    getBannerList();
  }

  Future<void> handlePermissions() async {
    // Check location permissions first
    await checkIsLocationEnabled();
    // await Future.delayed(const Duration(milliseconds: 500));
    // After location permission is handled, request notification permission
    await requestNotificationPermissions();
  }

  Future<void> requestNotificationPermissions() async {
    while (true) {
      // Check the current permission status
      var status = await Permission.notification.status;
      var hasAskedForPermission =
          await storageService.getNotificationAsk() ?? "false";

      if (status.isGranted) {
        print('Notification permission granted');
        return;
      }
      if (hasAskedForPermission == "true") {
        print('Notification permission has already been requested.');
        return; // Exit if permission has already been requested
      }

      if (status.isPermanentlyDenied) {
        storageService.setNotificationAsk("true");
        print('Notification permission permanently denied');
        CustomAlertDialog().successDialog(
            context,
            "Alert",
            "Open settings to enable notification permission!",
            "Yes! Open",
            "No", () async {
          openAppSettings().then((onValue) {
            Navigator.of(context).pop();
          });
        }, () {
          Navigator.of(context).pop();
        });
        // Redirect to settings
        return; // Exit the loop after permanent denial
      }

      // Request permission
      var result = await Permission.notification.request();

      if (result.isGranted) {
        print('Notification permission granted');
        return;
      } else if (result.isDenied) {
        print('Notification permission denied, trying again...');
        // Loop will automatically continue for the next attempt
      }
    }
  }

  Future<void> checkIsLocationEnabled() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);

    if (Platform.isAndroid) {
      var statusPermission = await Permission.location.status;
      if (!statusPermission.isGranted || statusPermission.isLimited) {
        await Permission.location.request();
      }
    }

    var location = await geo.Geolocator.getCurrentPosition();
    isLocationEnabled = await Permission.location.serviceStatus.isEnabled;

    Permission.location.serviceStatus.asStream().listen((event) {
      isLocationEnabled = event != ServiceStatus.disabled;
    });

    if (isLocationEnabled) {
      var location = await geo.Geolocator.getCurrentPosition();
      await appProvider.setLatLong(
          lat: location.latitude, lng: location.longitude);

      Placemark address = await getAddressFromLatLong(
          lat: location.latitude, lng: location.longitude);
      appProvider.setCurrentLocationAddress(address: address);
    }

    setState(() {
      isLocationEnabledChecked = true;
    });
  }

  getVehicleList() async {
    var resp = await ApiService().getVehicleList(parentId: "");
    debugPrint("vehicle List::::: $resp");
    vehicleList = resp.data;
    // Future.delayed(const Duration(seconds: 1), () {
    isLoaded = true;
    // });
    setState(() {});
  }

  getBannerList() async {
    var resp = await ApiService().getBannerImage("external");
    debugPrint("banner List::::: $resp");
    bannerList = resp['data'];
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    return Scaffold(
      // bottomNavigationBar: _bottomNavigationBar,
      backgroundColor: pureWhite,
      body: vehicleList == null || vehicleList.length == 0 || !isLoaded
          ? const SafeArea(
              child: Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            ))
          :
          // PopScope(
          // onPopInvoked: (val) async {
          // CustomAlertDialog().successDialog(
          // context,
          // "Alert",
          // "Are you sure you want to exit?",
          // "Confirm",
          // "Cancel", () async {
          // Navigator.pop(context);
          // SystemNavigator.pop();
          // }, () {
          // Navigator.pop(context);
          // });
          // // return false;
          // // }
          // },
          // child:
          SafeArea(
              child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.40,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          color: primaryColor,
                        ),
                        child: Center(
                          child: Card(
                            elevation: 8,
                            child: Container(
                                padding: const EdgeInsets.all(30),
                                decoration: BoxDecoration(
                                    color: pureWhite,
                                    borderRadius: BorderRadius.circular(5)),
                                height:
                                    MediaQuery.of(context).size.height * 0.30,
                                width: MediaQuery.of(context).size.width * 0.92,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.11,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 20.0),
                                              child: SizedBox(
                                                  height: 24,
                                                  width: 24,
                                                  child: SvgPicture.asset(
                                                      'assets/images/source_ring.svg',
                                                      fit: BoxFit.contain)),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.65,
                                              child: TextFormField(
                                                keyboardType:
                                                    TextInputType.multiline,
                                                maxLines: null,
                                                readOnly: true,
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      (MaterialPageRoute(
                                                          builder: (context) =>
                                                              const AddressPage(
                                                                locType:
                                                                    'pickup',
                                                              )))).then(
                                                      (value) {
                                                    if (value == true) {
                                                      fromLocController.text =
                                                          appProvider
                                                              .pickupAddress!
                                                              .addressString!;
                                                    }
                                                  });
                                                  setState(() {});
                                                },
                                                controller: fromLocController,
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                validator: (str) {
                                                  if (str!.isEmpty) {
                                                    return 'This field must not be empty';
                                                  }
                                                  return null;
                                                },
                                                style: GoogleFonts.inter(
                                                    color: pureBlack,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                decoration: InputDecoration(
                                                    helperStyle:
                                                        GoogleFonts.inter(
                                                            color: pureBlack,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                    hintText:
                                                        "Pick-up location",
                                                    border:
                                                        const UnderlineInputBorder()),
                                              ),
                                            ),
                                          ]),
                                    ),
                                    // const Padding(
                                    //   padding: EdgeInsets.only(left: 5.0),
                                    //   child: DownArrowWidget(
                                    //     count: 5,
                                    //   ),
                                    // ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.11,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 20.0, left: 1),
                                              child: SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child: SvgPicture.asset(
                                                      'assets/images/dest_marker.svg',
                                                      fit: BoxFit.contain)),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.65,
                                              child: TextFormField(
                                                keyboardType:
                                                    TextInputType.multiline,
                                                maxLines: null,
                                                readOnly: true,
                                                controller: toLocController,
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      (MaterialPageRoute(
                                                          builder: (context) =>
                                                              const AddressPage(
                                                                locType: 'drop',
                                                              )))).then(
                                                      (value) {
                                                    if (value == true) {
                                                      toLocController.text =
                                                          appProvider
                                                              .dropAddress!
                                                              .addressString!;
                                                    }
                                                  });
                                                  setState(() {});
                                                },
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                validator: (str) {
                                                  if (str!.isEmpty) {
                                                    return 'This field must not be empty';
                                                  }
                                                  return null;
                                                },
                                                style: GoogleFonts.inter(
                                                    color: pureBlack,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                decoration: InputDecoration(
                                                    helperStyle:
                                                        GoogleFonts.inter(
                                                            color: pureBlack,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                    hintText:
                                                        "Drop-off location",
                                                    border:
                                                        const UnderlineInputBorder()),
                                              ),
                                            ),
                                          ]),
                                    ),
                                  ],
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () async {
                                LoadingOverlay.of(context).show();
                                if (fromLocController.text != '' &&
                                    toLocController.text != '') {
                                  var distance =
                                      await ApiService().distanceCalc([
                                    appProvider.pickupAddress!.latlng!.latitude,
                                    appProvider
                                        .pickupAddress!.latlng!.longitude,
                                  ], [
                                    appProvider.dropAddress!.latlng!.latitude,
                                    appProvider.dropAddress!.latlng!.longitude,
                                  ]);
                                  if (distance['success']) {
                                    if (distance['data'] != null) {
                                      double calculatedTotal = double.parse(
                                              distance['data'].toString()) *
                                          double.parse(vehicleList[index]
                                              .price
                                              .toString());
                                      debugPrint("///////dist :: $distance");
                                      _selectedVehicle = index;
                                      setState(() {});
                                      if (appProvider.pickupAddress != null &&
                                          appProvider.dropAddress != null &&
                                          _selectedVehicle != null) {
                                        await ApiService()
                                            .getVehicleList(
                                                parentId:
                                                    vehicleList[index].sId)
                                            .then((value) {
                                          LoadingOverlay.of(context).hide();
                                          if (value.success == true) {
                                            if (value.data!.isNotEmpty) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          SubVehicleListPage(
                                                            vehicleList:
                                                                value.data,
                                                          )));
                                            } else {
                                              showModalBottomSheet(
                                                  context: context,
                                                  builder: (context) {
                                                    return SafeArea(
                                                      child: SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.12,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.95,
                                                        child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      "Total",
                                                                      style: GoogleFonts.inter(
                                                                          color:
                                                                              pureBlack,
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.w400),
                                                                    ),
                                                                    Text(
                                                                      " $rupeeSymbol ${calculatedTotal.ceilToDouble()}",
                                                                      style: GoogleFonts.inter(
                                                                          color:
                                                                              pureBlack,
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.w400),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.05,
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.95,
                                                                child:
                                                                    CustomButton(
                                                                        buttonLabel:
                                                                            "Next",
                                                                        backGroundColor:
                                                                            buttonColor,
                                                                        onTap:
                                                                            () {
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                  builder: (context) => ReviewPage(
                                                                                        vehicleDetail: vehicleList[index],
                                                                                        price: calculatedTotal.ceilToDouble(),
                                                                                        distance: double.parse(distance['data'].toString()),
                                                                                      )));
                                                                        },
                                                                        buttonWidth:
                                                                            MediaQuery.of(context).size.width *
                                                                                0.95),
                                                              )
                                                            ]),
                                                      ),
                                                    );
                                                  });
                                            }
                                          }
                                        });
                                      }
                                    }
                                  }
                                } else {
                                  LoadingOverlay.of(context).hide();
                                  notificationService.showToast(context,
                                      "Please enter both pickup and drop addresses",
                                      type: NotificationType.warning);
                                }
                              },
                              child: vehicleCard(vehicleList[index].name,
                                  vehicleList[index].image, index),
                            );
                          },
                          itemCount: vehicleList.length,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )),
    );
  }

  Padding carousalWidget(BuildContext context, image) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.15,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: secondaryColor, borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Topup your wallet",
                      style: GoogleFonts.inter(
                          color: pureWhite,
                          fontSize: 20,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "To win Exiting Discounts !  ",
                      style: GoogleFonts.inter(
                          color: pureWhite,
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                SizedBox(
                    child: SvgPicture.network('$imageUrl$image',
                        fit: BoxFit.contain)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Stack vehicleCard(String name, String image, int index) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.45,
          child: Card(
            elevation: _selectedVehicle == index ? 2 : 4,
            shadowColor: _selectedVehicle == index
                ? Colors.deepOrange
                : Colors.grey.shade200,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                    color: _selectedVehicle == index
                        ? Colors.deepOrange
                        : Colors.grey)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      child: SvgPicture.network("$imageUrl$image",
                          fit: BoxFit.contain)),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Text(
                            name,
                            style: GoogleFonts.inter(
                                color: pureBlack,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Book Now ",
                              style: GoogleFonts.inter(
                                  color: pureBlack,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w300),
                            ),
                            SvgPicture.asset(
                              'assets/images/arrow_next.svg',
                              fit: BoxFit.fill,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        _selectedVehicle == index
            ? Positioned(
                right: 10,
                top: 10,
                child: Align(
                  alignment: Alignment.topRight,
                  child: SizedBox(
                      child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.deepOrangeAccent),
                          child: const Icon(
                            Icons.done,
                            color: pureWhite,
                            size: 18,
                          ))),
                ))
            : const Offstage()
      ],
    );
  }
}
