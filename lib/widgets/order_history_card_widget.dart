import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:deliverapp/widgets/button.dart';
import 'package:intl/intl.dart';
import '../../core/models/vehicle_list_model.dart' as vehicle;

import '../core/colors.dart';
import '../core/constants.dart';
import '../core/models/history_model.dart' as order;

class ConnectHistoryListCardWidget extends StatelessWidget {
  const ConnectHistoryListCardWidget(
      {required this.historyList,super.key});
  final order.Data historyList;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: pureWhite,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                    color: greyLight1.withOpacity(0.6),
                    blurRadius: 6,
                    spreadRadius: 3,
                    offset: const Offset(1, 1) //New
                    )
              ]),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ListTile(
                      minLeadingWidth: 0,
                      contentPadding: EdgeInsets.zero,
                      leading:
                          historyList.vehicleImage.toString().contains(".svg")
                              ? SvgPicture.network(
                                  '$imageUrl${historyList.vehicleImage}',
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.contain)
                              : Image.network(
                                  '$imageUrl${historyList.vehicleImage}',
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.contain),
                      title: Text(
                        historyList.vehicleName!,
                        style: GoogleFonts.inter(
                            color: pureBlack,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        DateFormat("MMM dd'th' yyyy")
                            .format(DateTime.parse(historyList.createdAt!)),
                        style: GoogleFonts.inter(
                            color: pureBlack,
                            fontSize: 10,
                            fontWeight: FontWeight.w400),
                      ),
                      trailing: Text(
                        "$rupeeSymbol ${historyList.totalAmount}",
                        style: GoogleFonts.inter(
                            color: pureBlack,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              color: transparentColor,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 10.0, top: 3),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                              'assets/images/source_ring.svg',
                                              width: 12,
                                              height: 12),
                                          Container(
                                            margin: const EdgeInsets.all(5),
                                            width: 1,
                                            height: 45,
                                            color: Colors.black,
                                          ),
                                          SvgPicture.asset(
                                              'assets/images/dest_marker.svg',
                                              width: 12,
                                              height: 12),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.7,
                                                color: transparentColor,
                                                child: Text(
                                                    /*'Sarjapur'*/ "${historyList.pickUp!.userName} : ${historyList.pickUp!.phoneNumber}",
                                                    textAlign: TextAlign.start,
                                                    // overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    softWrap: true,
                                                    style: GoogleFonts.poppins(
                                                        color: pureBlack,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400))),
                                            Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.7,
                                                color: transparentColor,
                                                child: Text(
                                                    /*'Sarjapur'*/ "${historyList.pickUp!.address}",
                                                    textAlign: TextAlign.start,
                                                    // overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    softWrap: true,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                        color: pureBlack,
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w400))),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Column(
                                          children: [
                                            Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.7,
                                                color: transparentColor,
                                                child: Text(
                                                    /*'Marathahalli Rd'*/ "${historyList.drop!.userName}  : ${historyList.drop!.phoneNumber}  ",
                                                    textAlign: TextAlign.start,
                                                    // overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    softWrap: true,
                                                    style: GoogleFonts.poppins(
                                                        color: pureBlack,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400))),
                                            Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.7,
                                                color: transparentColor,
                                                child: Text(
                                                    /*'Marathahalli Rd'*/ "${historyList.drop!.address}",
                                                    textAlign: TextAlign.start,
                                                    // overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    softWrap: true,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                        color: pureBlack,
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w400))),
                                          ],
                                        )
                                      ],
                                    ),
                                  ]),
                            ),
                          ),
                        ]),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container()
                        // Divider(height: 1, thickness: 1, color: greyLight1),
                        ),
                    Container(
                        color: transparentColor,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 3.0),
                                    child: Icon(
                                      historyList.status.toString() == "7"
                                          ? Icons.done
                                          : Icons.cancel,
                                      color:
                                          historyList.status.toString() == "7"
                                              ? Colors.green
                                              : cancelStatusColor,
                                      size: 18,
                                    ),
                                  ),
                                  Text(
                                      /*'Dropped'*/ historyList.status
                                                  .toString() ==
                                              "1"
                                          ? "Waiting"
                                          : historyList.status.toString() == "2"
                                              ? "Accepted"
                                              : historyList.status.toString() ==
                                                      "3"
                                                  ? "On the way to pickup"
                                                  : historyList.status
                                                              .toString() ==
                                                          "4"
                                                      ? "Order collected"
                                                      : historyList.status
                                                                  .toString() ==
                                                              "5"
                                                          ? "On the way to deliver"
                                                          : historyList.status
                                                                      .toString() ==
                                                                  "6"
                                                              ? "Reached destination"
                                                              : historyList
                                                                          .status
                                                                          .toString() ==
                                                                      "7"
                                                                  ? "Completed"
                                                                  : historyList
                                                                              .status
                                                                              .toString() ==
                                                                          "10"
                                                                      ? "Expired"
                                                                      : "Cancelled",
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: GoogleFonts.poppins(
                                          color: historyList.status!
                                                      .toString()
                                                      .toLowerCase() ==
                                                  "7"
                                              ? Colors.green
                                              : cancelStatusColor,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                              SizedBox(
                                  height: 22,
                                  child: CustomButton(
                                    buttonLabel: "${historyList.paymentType}",
                                    backGroundColor: buttonColor,
                                    onTap: () {},
                                    buttonWidth: 110,
                                    buttonTextSize: 12,
                                    fontWeight: FontWeight.w700,
                                  )),
                            ]))
                  ]))),
    );
  }
}

class DottedWidget extends StatelessWidget {
  const DottedWidget({super.key, required this.len});
  final int len;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/icons/green_dot_icon.svg',
              width: 8, height: 8),
          for (int i = 0; i < len; i++) ...{
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 1.3),
                child: Container(
                  width: 1,
                  height: 1,
                  color: greyLight,
                ))
          },
          SvgPicture.asset('assets/icons/red_marker_icon.svg',
              width: 15, height: 15),
        ]);
  }
}
