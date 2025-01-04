import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SocialSignInButton extends StatefulWidget {
  final String buttonImage;
  final VoidCallback onTap;
  final Color borderColor;
  final double width, height, iconWidth, iconHeight;
  const SocialSignInButton(
      {super.key,
      required this.buttonImage,
      required this.onTap,
      required this.borderColor,
      required this.width,
      required this.height,
      required this.iconWidth,
      required this.iconHeight});

  @override
  State<SocialSignInButton> createState() => _SocialSignInButtonState();
}

class _SocialSignInButtonState extends State<SocialSignInButton> {
  @override
  Widget build(BuildContext context) {
    return //ElevatedButton(

        // style: ButtonStyle(
        //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        //         RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(5.0),
        //             side: BorderSide(color: widget.borderColor, width: 0.7)
        //         )
        //
        //     ),
        //     fixedSize: MaterialStateProperty.all(Size(widget.width, widget.height)),
        //     backgroundColor: MaterialStateProperty.all(pureWhite)
        // ),
        InkWell(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 5,right: 5),
        child: SvgPicture.asset(widget.buttonImage,
            width: widget.iconWidth, height: widget.iconHeight),
      ),
    );
  }
}
