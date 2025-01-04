import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/colors.dart';

class SavedAddressPage extends StatefulWidget {
  const SavedAddressPage({super.key});

  @override
  State<SavedAddressPage> createState() => _SavedAddressPageState();
}

class _SavedAddressPageState extends State<SavedAddressPage> {
  TextEditingController fromLocController = TextEditingController();
  List<dynamic> savedList = [
    {
      "name": "Home",
      "address":
          "Whitefield,Bengaluru,Whitefield Main Road,Sathya   Karnataka,India +91-9999999999"
    },
    {
      "name": "Work",
      "address":
          "Door No 6.Abc Building Nalluralli Whitefield   Bangalore 560066 +91-9999999999"
    }
  ];
  bool isFilled = false;
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
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: addressTextColor.withOpacity(0.3),
                              ),
                              borderRadius: BorderRadius.circular(5)),
                          child: SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  child: SvgPicture.asset(
                                      'assets/images/arrow_back.svg',
                                      fit: BoxFit.contain),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: SizedBox(
                                      child: Text(
                                    "Saved Addresses",
                                    style: GoogleFonts.inter(
                                        color: addressTextColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  )),
                                ),
                                const SizedBox()
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: SizedBox(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return savedCard(context, index);
                            },
                            itemCount: savedList.length,
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ))
        ],
      )),
    );
  }

  Container savedCard(BuildContext context, int index) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.all(8),
      child: ListTile(
        onTap: () {
          Navigator.pop(context);
        },
        horizontalTitleGap: 0,
        visualDensity: VisualDensity.compact,
        leading: const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.bookmark,
              color: addressTextColor,
              size: 24,
            ),
          ],
        ),
        title: Text(
          savedList[index]['name'],
          style: GoogleFonts.inter(
              color: pureBlack, fontSize: 16, fontWeight: FontWeight.w400),
        ),
        subtitle: Text(
          savedList[index]['address'],
          style: GoogleFonts.inter(
              color: addressTextColor,
              fontSize: 13,
              fontWeight: FontWeight.w400),
        ),
        trailing: PopupMenuButton<int>(
          itemBuilder: (context) => [
            // PopupMenuItem 1
            PopupMenuItem(
                value: 1,
                padding: EdgeInsets.zero,
                height: 20,
                onTap: () {},
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  padding: const EdgeInsets.all(5),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey)),
                  child: Text(
                    "Delete",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                )),
            PopupMenuItem(
              value: 2,
              padding: EdgeInsets.zero,
              height: 20,
              onTap: () {},
              child: Container(
                width: MediaQuery.of(context).size.width * 0.2,
                padding: const EdgeInsets.all(5),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey)),
                child: Text(
                  "Edit",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ],
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.2,
          ),
          position: PopupMenuPosition.over,
          icon: const Icon(
            Icons.more_vert,
            color: addressTextColor,
            size: 24,
          ),
          splashRadius: 15,
          // offset: const Offset(0, 0),
          elevation: 0,
          // on selected we show the dialog box
          onSelected: (value) {
            // if value 1 show dialog
            // if (value == 1) {
            //   _showDialog(context);
            //   // if value 2 show dialog
            // } else if (value == 2) {
            //   _showDialog(context);
            // }
          },
        ),
      ),
    );
  }
}
