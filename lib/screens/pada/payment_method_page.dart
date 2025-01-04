import 'package:deliverapp/core/errors/exceptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:deliverapp/core/services/api_service.dart';
import 'package:deliverapp/core/services/notification_service.dart';
import 'package:deliverapp/widgets/button.dart';
import 'package:provider/provider.dart';
import '../../core/colors.dart';
import '../../core/providers/app_provider.dart';
import '../../widgets/loading_indicator.dart';
import 'order_map_page.dart';

class PaymentMethodPage extends StatefulWidget {
  final dynamic vehicleDetail;
  final dynamic price;
  final dynamic couponPrice;
  final dynamic totalPrice;
  final dynamic coupon;
  final dynamic payableAmount;
  final double distance;
  const PaymentMethodPage(
      {super.key,
      required this.vehicleDetail,
      required this.price,
      required this.couponPrice,
      required this.totalPrice,
      required this.coupon,
      required this.payableAmount,
      required this.distance});

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  final Prog _prog = Prog();
  bool isEnabled = false;
  dynamic _paymentMethod = 1;
  dynamic selectedPaymentMethod;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  book() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    LoadingOverlay.of(context).show();
    debugPrint(".....vahicle ${widget.vehicleDetail.sId}");
    var errorText = "";
    var paymentDet = {
      "paymentType": _paymentMethod == 1 ? "wallet" : "cash", //paymentType,
      "price": num.parse(widget.totalPrice.toString()),
      "discountAmount": num.parse(widget.couponPrice.toString()),
      "userPaid": num.parse(widget.payableAmount.toString()),
    };
    try {
      await ApiService()
          .orderCreate(
              pickup: appProvider.pickupAddress!,
              drop: appProvider.dropAddress!,
              paymentDetails: paymentDet,
              distance: widget.distance,
              coupon: widget.coupon,
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: pureWhite,
      body: SafeArea(
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
                          "Payment Method",
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
                          height: MediaQuery.of(context).size.height * 0.27,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.40,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey, width: 1),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: RadioListTile(
                                    activeColor: primaryColor,
                                    title: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25.0),
                                          child: SvgPicture.asset(
                                              'assets/images/wallet_money.svg',
                                              fit: BoxFit.contain),
                                        ),
                                        Text(
                                          "Online",
                                          style: GoogleFonts.inter(
                                              color: pureBlack,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    value: 1,
                                    groupValue: _paymentMethod,
                                    onChanged: (val) {
                                      print("Radio $val");
                                      selectedPaymentMethod = val;
                                      _paymentMethod = val;
                                      setState(() {});
                                    },
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey, width: 1),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: RadioListTile(
                                    activeColor: primaryColor,
                                    title: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25.0),
                                          child: SvgPicture.asset(
                                              'assets/images/rupee.svg',
                                              fit: BoxFit.contain),
                                        ),
                                        Text(
                                          "Cash",
                                          style: GoogleFonts.inter(
                                              color: pureBlack,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    value: 2,
                                    groupValue: _paymentMethod,
                                    onChanged: (val) {
                                      print("Radio $val");
                                      selectedPaymentMethod = val;
                                      _paymentMethod = val;
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.95,
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: CustomButton(
                            buttonLabel: "Book ${widget.vehicleDetail.name}",
                            backGroundColor: buttonColor,
                            onTap: book,
                            buttonWidth: double.infinity),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
