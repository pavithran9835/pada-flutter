import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAlertDialog {
  successDialog(BuildContext context, String? title, String? content,
      String? alertOk, String? cancel, dynamic action, dynamic backAction,
      {Color okBtnColor = Colors.green, Color cancelBtnColor = Colors.grey}) {
     return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            /*title:SvgPicture.asset("assets/icons/about_icon_drawer.svg", fit: BoxFit.cover,
            height: 50,width: 50,color: Colors.yellow,)*/
            content: SizedBox(
              width: MediaQuery.of(context).size.height * 0.4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // SvgPicture.asset(
                  //   "assets/icons/about_icon_drawer.svg",
                  //   fit: BoxFit.cover,
                  //   height: 50,
                  //   width: 50,
                  //   color: Colors.yellow,
                  // ),
                  // Center(
                  //   child: Text(
                  //     title!,
                  //     style: GoogleFonts.poppins(
                  //       wordSpacing: 1.2,
                  //       fontSize: 20,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  Text(
                    content!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      wordSpacing: 1.2,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: cancelBtnColor),
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: backAction,
                    // color: Colors.grey,
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      cancel!,
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: okBtnColor,
                    onPressed: action,
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      alertOk!,
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }

  infoDialog(BuildContext context, String? title, String? content) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            icon: Container(
              alignment: Alignment.centerRight,
              child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.cancel,
                    color: Colors.black,
                  )),
            ),
            title: Text(
              title!,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                wordSpacing: 1.2,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            /*title:SvgPicture.asset("assets/icons/about_icon_drawer.svg", fit: BoxFit.cover,
            height: 50,width: 50,color: Colors.yellow,)*/
            content: SizedBox(
              width: MediaQuery.of(context).size.height * 0.4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    content!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      wordSpacing: 1.2,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
