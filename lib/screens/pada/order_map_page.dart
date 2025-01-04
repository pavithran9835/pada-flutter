import 'dart:async';
import 'package:deliverapp/widgets/alert_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:deliverapp/core/models/create_connect_response.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:provider/provider.dart';

import '../../core/colors.dart';
import '../../core/errors/exceptions.dart';
import '../../core/providers/app_provider.dart';
import '../../core/services/api_service.dart';
import '../../core/services/navigation_service.dart';
import '../../core/services/notification_service.dart';
import '../../routers/routing_constants.dart';
import 'bottom_navigation_page.dart';

class OrderMapPage extends StatefulWidget {
  final String? orderId;
  const OrderMapPage({super.key, required this.orderId});

  @override
  State<OrderMapPage> createState() => _OrderMapPageState();
}

class _OrderMapPageState extends State<OrderMapPage> {
  // IO.Socket? socketi;
  double value = 0.0;
  late Timer timer;
  CameraPosition? cameraPosition;
  bool isloaded = true;
  bool _loadingDone = false;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(13.1344635197085, 77.6717135197085),
    zoom: 12.4746,
  );
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  List<String> cancelReasonList = [
    "Driver taking too long",
    "Need to change order details",
  ];

  @override
  void initState() {
    super.initState();
    connectSocket();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  updateProgress() async {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (t) {
      setState(() {
        value += 0.00333;
        if (double.parse(value.toStringAsFixed(1)) >= 0.999) {
          _loadingDone = false;
          t.cancel();

          navigationService.navigatePushNamedAndRemoveUntilTo(
              notAcceptScreenRoute, null);
          // Navigator.pushAndRemoveUntil<void>(
          //   context,
          //   MaterialPageRoute<void>(
          //       builder: (BuildContext context) => const NotAcceptedPage()),
          //   ModalRoute.withName('/'),
          // );
        }
      });
    });
  }

  cancelDialog(BuildContext context) async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    try {
      await ApiService()
          .cancelOrder(
              widget.orderId.toString(), "Need to change order details")
          .then((value) {
        if (value['success']) {
          if (context.mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const BottomNavPage()),
              ModalRoute.withName('/home'),
            );

            // navigationService.navigatePushNamedAndRemoveUntilTo(
            //     homeScreenRoute, null);
          }
        } else {
          notificationService.showToast(context, "Something went wrong",
              type: NotificationType.error);
        }
      });
    } catch (e) {
      if (context.mounted) {
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
  }

  connectSocket() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    updateProgress();

    // try {
    await appProvider.socketConnect();
    appProvider.socketIO!.onConnect((_) {
      print(
          '<=========== SOCKET CONNECTED: ${appProvider.socketIO!.id}===========>');
      // socketi!.emit(
      //   'postLiveLocation',
      //   {
      //     "userDetails": {
      //       "location": [
      //         double.parse(appProvider.latitude),
      //         double.parse(appProvider.longitude)
      //       ]
      //     },
      //   },
      // );
      //
      //   print("=======> before getLiveLocation");
      //
      appProvider.socketIO!.on('getAcceptOrder', (data) {
        print(
            '<=========== GET LIVE LOCATION SOCKET LISTEN DATA $data ===========>');
        if (data.length != 0) {
          print('<=========== GET LIVE  DATA $data ===========>');
          print('<=========== GET ONE DATA ${data['userId']} ===========>');
          appProvider.setAcceptedData(
            ReqAcceptModel(
                userId: data['userId'],
                deliveryBoyId: data['deliveryBoy'],
                orderId: data['orderId'],
                firstName: data['firstName'],
                lastName: data['lastName'],
                phoneNumber: data['phoneNumber'],
                email: data['email'],
                image: data['image'],
                shortCode: data['shortCode'],
                gender: data['gender'],
                vehicleNumber: data['vehicleNumber'],
                vehicle: data['vehicle'],
                location: [data['location'][0], data['location'][1]],
                pickUp: PickUp(
                    address: data['pickUp']['address'],
                    location: [
                      data['pickUp']['location'][0],
                      data['pickUp']['location'][1]
                    ],
                    userName: data['pickUp']['userName'],
                    phoneNumber: data['pickUp']['phoneNumber']),
                drop: PickUp(
                    address: data['drop']['address'],
                    location: [
                      data['drop']['location'][0],
                      data['drop']['location'][1]
                    ],
                    userName: data['drop']['userName'],
                    phoneNumber: data['drop']['phoneNumber']),
                totalAmount: data["totalAmount"].toString(),
                discountAmount: data["discountAmount"].toString(),
                userPaid: data["userPaid"].toString()),
          );
          // if (context.mounted) {
          navigationService.navigatePushNamedAndRemoveUntilTo(
              onAcceptScreenRoute, null);
          // Navigator.pushAndRemoveUntil(
          //   context,
          //   MaterialPageRoute(builder: (context) => const OrderAcceptedPage()),
          //   ModalRoute.withName('/onAccepted'),
          // );
          // }
        } else {
          print('<=========== NO DATA ===========>');
        }
        // _add(appProvider);
      });
      // });

      appProvider.socketIO!.onDisconnect((_) {
        print('<=========== SOCKET DISCONNECTED ===========>');
      });
    });
    // } catch (e) {
    //   print("<============ SOCKET CONNECTION FAILED $e==============>");
    // }
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    return Scaffold(
        backgroundColor: pureWhite,
        appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height * 0.05),
          child: SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(100),
                bottomRight: Radius.circular(100),
              )),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Finding a Driver",
                      style: GoogleFonts.inter(
                          color: pureBlack,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
        body: PopScope(
          canPop: false,
          onPopInvoked: (bool) async {
            if (!bool) {
              CustomAlertDialog().successDialog(
                  context,
                  "Alert",
                  "Do you want to cancel the order?",
                  "Yes, Cancel",
                  "No", () async {
                cancelDialog(context);
              }, () {
                Navigator.of(context, rootNavigator: true).pop();
              });
            }
          },
          child: !isloaded
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SafeArea(
                  child: SizedBox(
                    child: Stack(
                      fit: StackFit.passthrough,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: GoogleMap(
                            // zoomControlsEnabled: true,
                            // markers: _markers,
                            onCameraMove: (CameraPosition position) async {},
                            mapType: MapType.normal,
                            initialCameraPosition: _kGooglePlex,
                            myLocationButtonEnabled: false,
                            // polylines: Set<Polyline>.of(polylines.values),
                            onMapCreated: (GoogleMapController controller) {
                              _controller.complete(controller);
                            },
                          ),
                        ),
                        Positioned(
                            // bottom: 20,
                            // left: 20,
                            child: Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Card(
                              elevation: 4,
                              color: pureWhite,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                width: MediaQuery.of(context).size.width * 0.90,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 20),
                                      child: LinearProgressIndicator(
                                        minHeight: 7,
                                        value: value,
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                                buttonColor),
                                        color: buttonColor.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(15),
                                        semanticsLabel:
                                            'Linear progress indicator',
                                      ),
                                    ),
                                    Text(
                                      "Finding 2 Wheeler drivers nearby",
                                      style: GoogleFonts.inter(
                                          color: pureBlack,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      "please wait a moment ",
                                      style: GoogleFonts.inter(
                                          color: const Color(0XFF939393),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        // width: MediaQuery.of(context).size.width *
                                        //     0.50,
                                        child: InkWell(
                                          onTap: () {
                                            showModalBottomSheet(
                                                context: context,
                                                builder: (context) {
                                                  return SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.20,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.95,
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(15.0),
                                                            child: Text(
                                                              "Reason For Cancellation",
                                                              style: GoogleFonts.inter(
                                                                  color:
                                                                      pureBlack,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ),
                                                          ListView.builder(
                                                            shrinkWrap: true,
                                                            physics:
                                                                const NeverScrollableScrollPhysics(),
                                                            itemBuilder:
                                                                (context2,
                                                                    index) {
                                                              return ListTile(
                                                                onTap:
                                                                    () async {
                                                                  CustomAlertDialog().successDialog(
                                                                      context2,
                                                                      "Alert",
                                                                      "Do you want to cancel the order?",
                                                                      "Yes, Cancel",
                                                                      "No",
                                                                      () async {
                                                                    try {
                                                                      await ApiService()
                                                                          .cancelOrder(
                                                                              widget.orderId.toString(),
                                                                              cancelReasonList[index])
                                                                          .then((value) {
                                                                        if (value[
                                                                            'success']) {
                                                                          if (context
                                                                              .mounted) {
                                                                            Navigator.pushAndRemoveUntil(
                                                                              context,
                                                                              MaterialPageRoute(builder: (context) => const BottomNavPage()),
                                                                              ModalRoute.withName('/home'),
                                                                            );

                                                                            // navigationService.navigatePushNamedAndRemoveUntilTo(
                                                                            //     homeScreenRoute, null);
                                                                          }
                                                                        } else {
                                                                          if (context
                                                                              .mounted) {
                                                                            notificationService.showToast(context,
                                                                                value["message"],
                                                                                type: NotificationType.error);
                                                                          }
                                                                        }
                                                                      });
                                                                    } catch (e) {
                                                                      if (context
                                                                          .mounted) {
                                                                        if (e
                                                                            is ClientException) {
                                                                          notificationService.showToast(
                                                                              context,
                                                                              e.message,
                                                                              type: NotificationType.error);
                                                                        }
                                                                        if (e
                                                                            is HttpException) {
                                                                          notificationService.showToast(
                                                                              context,
                                                                              e.message,
                                                                              type: NotificationType.error);
                                                                        }
                                                                        if (e
                                                                            is ServerException) {
                                                                          notificationService.showToast(
                                                                              context,
                                                                              e.message,
                                                                              type: NotificationType.error);
                                                                        }
                                                                      }
                                                                    }
                                                                  }, () {
                                                                    Navigator.of(
                                                                            context2,
                                                                            rootNavigator:
                                                                                true)
                                                                        .pop();
                                                                  });
                                                                  //appProvider.acceptedData?.orderId
                                                                },
                                                                leading: Text(
                                                                  cancelReasonList[
                                                                      index],
                                                                  style: GoogleFonts.inter(
                                                                      color:
                                                                          pureBlack,
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                ),
                                                                trailing:
                                                                    const Icon(
                                                                  Icons
                                                                      .arrow_forward,
                                                                  color: Color(
                                                                      0XFF939393),
                                                                  size: 20,
                                                                ),
                                                              );
                                                            },
                                                            itemCount:
                                                                cancelReasonList
                                                                    .length,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                });
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(right: 5.0),
                                                child: Icon(
                                                  Icons.cancel,
                                                  color: buttonColor,
                                                  size: 18,
                                                ),
                                              ),
                                              Text(
                                                "Cancel Order",
                                                style: GoogleFonts.inter(
                                                    color: pureBlack,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ))
                      ],
                    ),
                  ),
                ),
        ));
  }
}
