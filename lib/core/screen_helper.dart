import 'package:flutter/material.dart';

class ScreenHelper extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget laptop;
  final Widget desktop;

  const ScreenHelper(
      {super.key,
      required this.desktop,
      required this.mobile,
      required this.tablet,
      required this.laptop});

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width <= 480.0;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 481.0 &&
      MediaQuery.of(context).size.width <= 769.0;

  static bool isLaptop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 769.0 &&
      MediaQuery.of(context).size.width <= 1072.0;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1073.0;

  static bool isDesktopOrLaptop(BuildContext context) {
    return isDesktop(context) || isLaptop(context);
  }

  static bool isMobileOrTablet(BuildContext context) {
    return isMobile(context) || isTablet(context);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth >= 1073.0) {
          return desktop;
        } else if (constraints.maxWidth >= 769 &&
            constraints.maxWidth < 1073.0) {
          return laptop;
        } else if (constraints.maxWidth >= 481 &&
            constraints.maxWidth < 769.0) {
          return tablet;
        } else {
          return mobile;
        }
      },
    );
  }
}