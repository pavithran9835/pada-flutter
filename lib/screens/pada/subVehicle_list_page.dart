import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:deliverapp/core/constants.dart';
import 'package:deliverapp/screens/pada/review_page.dart';
import 'package:provider/provider.dart';
import '../../core/colors.dart';
import '../../core/providers/app_provider.dart';
import '../../core/services/api_service.dart';
import '../../widgets/button.dart';

class SubVehicleListPage extends StatefulWidget {
  final dynamic vehicleList;
  const SubVehicleListPage({super.key, required this.vehicleList});

  @override
  State<SubVehicleListPage> createState() => _SubVehicleListPageState();
}

class _SubVehicleListPageState extends State<SubVehicleListPage> {
  int? _selectedVehicle;
  @override
  void initState() {
    super.initState();
  }

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
                            "Select a vehicle",
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
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () async {
                              var distance = await ApiService().distanceCalc([
                                appProvider.pickupAddress!.latlng!.latitude,
                                appProvider.pickupAddress!.latlng!.longitude,
                              ], [
                                appProvider.dropAddress!.latlng!.latitude,
                                appProvider.dropAddress!.latlng!.longitude,
                              ]);
                              if (distance['success']) {
                                if (distance['data'] != null) {
                                  double calculatedTotal = double.parse(
                                          distance['data'].toString()) *
                                      double.parse(widget
                                          .vehicleList[index].price
                                          .toString());
                                  debugPrint("///////dist :: $distance");
                                  _selectedVehicle = index;
                                  setState(() {});
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.15,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.95,
                                          child: Column(children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Total",
                                                    style: GoogleFonts.inter(
                                                        color: pureBlack,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  Text(
                                                    " $rupeeSymbol ${calculatedTotal.ceilToDouble()}",
                                                    style: GoogleFonts.inter(
                                                        color: pureBlack,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.05,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.95,
                                              child: CustomButton(
                                                  buttonLabel: "Next",
                                                  backGroundColor: buttonColor,
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    ReviewPage(
                                                                      vehicleDetail:
                                                                          widget
                                                                              .vehicleList[_selectedVehicle],
                                                                      price: calculatedTotal
                                                                          .ceilToDouble(),
                                                                      distance:
                                                                          double.parse(
                                                                              distance['data'].toString()),
                                                                    )));
                                                  },
                                                  buttonWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.95),
                                            )
                                          ]),
                                        );
                                      });
                                }
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 10),
                              child: vehicleCard(widget.vehicleList[index].name,
                                  widget.vehicleList[index].name, index),
                            ),
                          );
                        },
                        itemCount: widget.vehicleList.length,
                      ),
                    )
                  ]),
                ),
              ),
            ),
          ))
        ],
      )),
    );
  }

  Stack vehicleCard(String name, String image, int index) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        Card(
          elevation: _selectedVehicle == index ? 2 : 5,
          shadowColor: _selectedVehicle == index
              ? Colors.deepOrange
              : Colors.grey.shade200,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                  color: _selectedVehicle == index
                      ? Colors.deepOrange
                      : Colors.grey)),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.45,
            height: MediaQuery.of(context).size.height * 0.15,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5.0, vertical: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                      child: SvgPicture.network(
                          "$imageUrl${widget.vehicleList[index].image}",
                          fit: BoxFit.contain)),
                  Text(
                    name,
                    style: GoogleFonts.inter(
                        color: pureBlack,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
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
