import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final ValueChanged onChanged, onSubmit;
  final String hintText;
  final int? maxLines;
  final int? maxLength;
  final TextInputType? textInputType;
  final Widget? prefixIcon;
  final bool showShadow, showBorder, textAlignCenter, readOnly;
  final double textSize;
  final VoidCallback? onTap;
  const CustomTextField(
      {super.key,
      required this.textEditingController,
      required this.onChanged,
      required this.hintText,
      required this.onSubmit,
      this.showShadow = false,
      this.textInputType,
      this.showBorder = true,
      this.textAlignCenter = true,
      this.textSize = 18,
      this.prefixIcon,
      this.readOnly = false,
      this.onTap,
      this.maxLines,
      this.maxLength});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(5),
      elevation: widget.showShadow ? 10.0 : 0,
      shadowColor: widget.showShadow ? buttonColor : transparentColor,
      child: TextFormField(
        maxLength: widget.maxLength,
        keyboardType: widget.textInputType ?? TextInputType.text,
        cursorColor: pureBlack,
        maxLines: widget.maxLines,
        onTap: widget.onTap,
        readOnly: widget.readOnly,
        style: GoogleFonts.poppins(
            color: pureBlack,
            fontSize: widget.textSize,
            fontWeight: FontWeight.w500),
        textAlign: widget.textAlignCenter ? TextAlign.center : TextAlign.start,
        controller: widget.textEditingController,
        decoration: InputDecoration(
          counterText: "",
            prefixIcon: widget.prefixIcon,
            prefixIconColor: pureBlack.withOpacity(0.5),
            hintText: widget.hintText,
            hintStyle: GoogleFonts.poppins(
                color: pureBlack.withOpacity(0.5),
                fontSize: widget.textSize,
                fontWeight: FontWeight.w500),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 1,
                    color: widget.showBorder ? pureBlack : transparentColor)),
            border: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 1,
                    color: widget.showBorder ? pureBlack : transparentColor)),
            focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: errorColor)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 1,
                    color: widget.showBorder ? pureBlack : transparentColor)),
            errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: errorColor))),
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onSubmit,
      ),
    );
  }
}
