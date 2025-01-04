import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/colors.dart';

class DrawerTileWidget extends StatefulWidget {
  final VoidCallback onTap;
  final String imageUrl, title;
  final bool isWallet;
  const DrawerTileWidget({super.key, required this.onTap, required this.imageUrl, required this.title, this.isWallet = false});

  @override
  State<DrawerTileWidget> createState() => _DrawerTileWidgetState();
}

class _DrawerTileWidgetState extends State<DrawerTileWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      onTap: widget.onTap,
      child: Container(
          color: transparentColor,
          height: MediaQuery.of(context).size.height/14,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(widget.imageUrl, color: pureWhite, width: 24, height: 24),
                  SizedBox(
                      width: MediaQuery.of(context).size.width/30
                  ),
                  Text(
                      widget.title,
                      textAlign: TextAlign.start,
                      style: GoogleFonts.poppins(
                          color: pureWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.w400
                      )
                  )
                ]),
          )),
    );
  }
}
