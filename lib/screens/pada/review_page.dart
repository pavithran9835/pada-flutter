import 'dart:ui';

import 'package:deliverapp/core/errors/exceptions.dart';
import 'package:deliverapp/screens/pada/payment_method_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:deliverapp/core/services/api_service.dart';
import 'package:deliverapp/core/services/notification_service.dart';
import 'package:deliverapp/widgets/button.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../core/providers/app_provider.dart';
import '../../core/utils.dart';
import '../../widgets/loading_indicator.dart';
import 'order_map_page.dart';

class ReviewPage extends StatefulWidget {
  final dynamic vehicleDetail;
  final dynamic price;
  final double distance;
  const ReviewPage(
      {super.key,
      required this.vehicleDetail,
      required this.price,
      required this.distance});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  var vehicleList;
  var bannerList;
  final Prog _prog = Prog();
  String validateStr = '';
  dynamic couponDetails;
  double totalPrice = 0.0;
  double couponPrice = 0.0;
  double netFare = 0.0;
  double payableAmount = 0.0;
  int? _selectedVehicle;
  TextEditingController fromLocController = TextEditingController();
  TextEditingController toLocController = TextEditingController();
  TextEditingController couponController = TextEditingController();
  FocusNode couponFocusNode = FocusNode();
  bool isEnabled = false;
  final dynamic _paymentMethod = 1;
  dynamic selectedPaymentMethod;
  bool _showSuccessAlert = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalPrice = double.parse(widget.price.toString());
    netFare = double.parse(widget.price.toString());
    payableAmount = double.parse(widget.price.toString());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  applyCoupon() async {
    couponPrice = 0.0;
    netFare = 0.0;
    payableAmount = 0.0;
    setState(() {});
    dynamic resp;
    if (couponController.text != '') {
      try {
        LoadingOverlay.of(context).show();
        await ApiService().validateCoupon(couponController.text).then((value) {
          debugPrint("......// $value");
          LoadingOverlay.of(context).hide();
          if (value != null) {
            if (value['success'] == true) {
              if (value['data'] != null &&
                  value['message'].toString().toLowerCase() ==
                      'request was successfull') {
                setState(() {
                  _showSuccessAlert = true;
                });

                // Hide the animation after it completes
                Future.delayed(const Duration(seconds: 2), () {
                  setState(() {
                    _showSuccessAlert = false;
                  });
                });
                couponDetails = value['data'];
                couponPrice = double.parse((double.parse(
                            (double.parse(widget.price.toString()) *
                                    double.parse(
                                        couponDetails['discountPercentage']
                                            .toString()))
                                .toString()) /
                        100)
                    .ceilToDouble()
                    .toString());
                double.parse(couponDetails['discountPercentage'].toString());
                netFare = double.parse((double.parse(widget.price.toString()) -
                            double.parse(couponPrice.toString()))
                        .toString())
                    .ceilToDouble();
                payableAmount = netFare;
                debugPrint("/////// $couponDetails");
                debugPrint("/////// $netFare");
                setState(() {});
              } else {
                couponPrice = 0.0;
                netFare = double.parse((double.parse(widget.price.toString()) -
                            double.parse(couponPrice.toString()))
                        .toString())
                    .ceilToDouble();
                payableAmount = netFare;
                debugPrint("/////// $netFare");
                setState(() {});
                notificationService.showToast(context, value['message'],
                    type: NotificationType.error);
              }
            }
          }
        }).catchError((onError) {
          LoadingOverlay.of(context).hide();
        });
      } catch (e) {
        debugPrint("eeeeee::: $e");
        if (e is ClientException) {
          notificationService.showToast(context, e.message.toString(),
              type: NotificationType.error);
        }
      }
    } else {
      notificationService.showToast(context, "Enter valid coupon code",
          type: NotificationType.error);
    }

    couponFocusNode.unfocus();
    setState(() {});
  }

  book() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    LoadingOverlay.of(context).show();
    debugPrint(".....vahicle ${widget.vehicleDetail.sId}");
    var errorText = "";
    var paymentDet = {
      "paymentType": _paymentMethod == 1 ? "wallet" : "cash", //paymentType,
      "price": num.parse(totalPrice.toString()),
      "discountAmount": num.parse(couponPrice.toString()),
      "userPaid": num.parse(payableAmount.toString()),
    };
    try {
      await ApiService()
          .orderCreate(
              pickup: appProvider.pickupAddress!,
              drop: appProvider.dropAddress!,
              paymentDetails: paymentDet,
              distance: widget.distance,
              coupon: couponController.text,
              vehicleId: widget.vehicleDetail.sId)
          .then((value) {
        LoadingOverlay.of(context).hide();
        debugPrint("order resp:::::::$value");
        errorText = value['message'];
        if (value['success']) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      OrderMapPage(orderId: value['data']['_id'])));
        } else {
          debugPrint("error::::1 ${value['message']}");
          LoadingOverlay.of(context).hide();
          errorText = value['message'];
          notificationService.showToast(context, value['message'],
              type: NotificationType.error);
        }
      });
    } catch (e) {
      debugPrint("error::::2 $e");
      if (context.mounted) {
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
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    fromLocController.text = appProvider.pickupAddress!.addressString!;
    toLocController.text = appProvider.dropAddress!.addressString!;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.11,
          decoration: const BoxDecoration(
              color: pureWhite,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5), topRight: Radius.circular(5))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "$rupeeSymbol $netFare",
                        style: GoogleFonts.inter(
                            color: pureBlack,
                            fontSize: 20,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: CustomButton(
                      buttonLabel: "Choose Payment Method",
                      backGroundColor: buttonColor,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PaymentMethodPage(
                                      vehicleDetail: widget.vehicleDetail,
                                      price: 0.0,
                                      couponPrice: couponPrice,
                                      totalPrice: totalPrice,
                                      coupon: couponController.text,
                                      payableAmount: payableAmount,
                                      distance: 0.0,
                                    )));
                      },
                      buttonWidth: double.infinity),
                ),
              )
            ]),
          ),
        ),
      ),
      backgroundColor: pureWhite,
      body: /*vehicleList == null || vehicleList.length == 0
          ? const SafeArea(
              child: Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            ))
          :*/
          GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            SafeArea(
                child: Container(
              color: primaryColor,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      top: 10.0,
                      right: 20.0,
                    ),
                    child: SizedBox(
                      child: Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
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
                                "Review and place your order",
                                style: GoogleFonts.inter(
                                    color: pureBlack,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.arrow_back_ios,
                                color: pureWhite,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    // height: MediaQuery.of(context).size.height * 0.70,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            child: Card(
                              elevation: 2,
                              child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      color: pureWhite,
                                      borderRadius: BorderRadius.circular(5)),
                                  height:
                                      MediaQuery.of(context).size.height * 0.27,
                                  // width: MediaQuery.of(context).size.width * 0.9,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                  height: 22,
                                                  width: 22,
                                                  child: SvgPicture.asset(
                                                      'assets/images/source_ring.svg',
                                                      fit: BoxFit.contain)),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.65,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      appProvider.pickupAddress!
                                                          .addressString!,
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.inter(
                                                          color: pureBlack,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 3.0),
                                                      child: Text(
                                                        "${appProvider.pickupAddress!.name!} : ${appProvider.pickupAddress!.phone} ",
                                                        style:
                                                            GoogleFonts.inter(
                                                                color:
                                                                    pureBlack,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                      ),
                                                    ),
                                                    const Divider(
                                                      color: addressTextColor,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ]),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                  height: 18,
                                                  width: 18,
                                                  child: SvgPicture.asset(
                                                      'assets/images/dest_marker.svg',
                                                      fit: BoxFit.contain)),
                                              SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.65,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        appProvider.dropAddress!
                                                            .addressString!,
                                                        maxLines: 3,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            GoogleFonts.inter(
                                                                color:
                                                                    pureBlack,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 3.0),
                                                        child: Text(
                                                          "${appProvider.dropAddress!.name!} : ${appProvider.dropAddress!.phone} ",
                                                          style:
                                                              GoogleFonts.inter(
                                                                  color:
                                                                      pureBlack,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                        ),
                                                      ),
                                                      const Divider(
                                                        color: addressTextColor,
                                                      )
                                                    ],
                                                  )),
                                            ]),
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Offer and discounts",
                                style: GoogleFonts.inter(
                                    color: pureBlack,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            child: Card(
                              elevation: 2,
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Spacer(),
                                    const Spacer(),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.65,
                                      child: TextFormField(
                                        keyboardType: TextInputType.text,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        focusNode: couponFocusNode,
                                        maxLength: 16,
                                        controller: couponController,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        onChanged: (str) {
                                          if (str.isNotEmpty) {
                                            isEnabled = true;
                                          } else {
                                            isEnabled = false;
                                          }
                                          setState(() {});
                                        },
                                        // validator: (str) {
                                        //   if (str!.isEmpty) {
                                        //     return validateStr;
                                        //   }
                                        //   return null;
                                        // },
                                        style: GoogleFonts.inter(
                                            color: pureBlack,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                        decoration: InputDecoration(
                                            // errorStyle: const TextStyle(fontSize: 0.01),
                                            counterText: "",
                                            errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: const BorderSide(
                                                color: Colors.red,
                                                width: 1,
                                                style: BorderStyle.solid,
                                              ),
                                            ),
                                            helperStyle: GoogleFonts.inter(
                                                color: pureBlack,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                            hintText: "Coupon",
                                            border: InputBorder.none),
                                      ),
                                    ),
                                    const Spacer(),
                                    TextButton(
                                      onPressed: isEnabled ? applyCoupon : null,
                                      child: Text(
                                        "Apply",
                                        style: GoogleFonts.inter(
                                            color: isEnabled
                                                ? secondaryColor
                                                : Colors.grey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    )
                                  ]),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Fare Summary",
                                style: GoogleFonts.inter(
                                    color: pureBlack,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            child: Card(
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Trip Fare (Motorcycle)",
                                            style: GoogleFonts.inter(
                                                color: addressTextColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          const Spacer(),
                                          Text(
                                            "$rupeeSymbol ${double.parse(widget.price.toString())}",
                                            style: GoogleFonts.inter(
                                                color: pureBlack,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                            child: Text(
                                              "Coupon Discount - ${couponController.text.toUpperCase()}",
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.inter(
                                                  color: addressTextColor,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            " - $rupeeSymbol $couponPrice",
                                            style: GoogleFonts.inter(
                                                color: Colors.green,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(
                                      color: addressTextColor,
                                      // indent: 5,
                                      // endIndent: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Net Fare",
                                            style: GoogleFonts.inter(
                                                color: addressTextColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          const Spacer(),
                                          Text(
                                            "$rupeeSymbol $netFare",
                                            style: GoogleFonts.inter(
                                                color: pureBlack,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(
                                      color: addressTextColor,
                                      // indent: 5,
                                      // endIndent: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Amount payable",
                                            style: GoogleFonts.inter(
                                                color: addressTextColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          const Spacer(),
                                          Text(
                                            "$rupeeSymbol $payableAmount", //couponDetails['price']
                                            style: GoogleFonts.inter(
                                                color: pureBlack,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, right: 20.0),
                                      child: Text.rich(
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                        maxLines: 3,
                                        TextSpan(
                                          text:
                                              'Exclude extra fees (e.g . toll or parking fee) . please settle with the driver according to the',
                                          style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: Colors.black),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: ' standard pricing.',
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                color: buttonColor,
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
                                      // Text(
                                      //   "Exclude extra fees (e.g . toll or parking fee) . please settle with the driver according to the standard pricing.",
                                      //   style: GoogleFonts.inter(
                                      //       color: addressTextColor,
                                      //       fontSize: 12,
                                      //       fontWeight: FontWeight.w400),
                                      // ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )),
            if (_showSuccessAlert)
              Center(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 50,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Lottie.asset(
                      'assets/images/succesGif.json', // Replace with your Lottie animation file
                      backgroundLoading: false,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                      repeat: false, // Play only once
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
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
                // SizedBox(
                //     child: SvgPicture.network('$imageUrl$image',
                //         fit: BoxFit.contain)),
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
