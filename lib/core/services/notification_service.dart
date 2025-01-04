import 'package:flutter/material.dart';
import 'package:deliverapp/core/services/service_locator.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

enum NotificationType { success, error, warning }

final NotificationService notificationService =
    locator.get<NotificationService>();

class NotificationService {
  // final _navigationKey = locator<NavigationService>().navigatorKey;
  void showToast(BuildContext context, String? message,
      {NotificationType type = NotificationType.success}) {
    if (type == NotificationType.success) {
      showTopSnackBar(
        displayDuration: const Duration(milliseconds: 1500),
        Overlay.of(context),
        CustomSnackBar.success(
          message: message ?? "",
        ),
      );
    } else {
      showTopSnackBar(
        displayDuration: const Duration(milliseconds: 1500),
        Overlay.of(context),
        CustomSnackBar.error(
          backgroundColor: Colors.deepOrange,
          message: message ?? "",
        ),
      );
    }
  }
  // void showToast(BuildContext context, String? message,
  //     {NotificationType type = NotificationType.success}) {
  //   // Use ScaffoldMessenger for Snackbar to ensure no overlay issues
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       // margin: EdgeInsets.all(5),
  //       // padding: const EdgeInsets.all(10),
  //       behavior: SnackBarBehavior.floating,
  //       duration: const Duration(seconds: 2),
  //       clipBehavior: Clip.antiAliasWithSaveLayer,
  //       margin: EdgeInsets.all(16),
  //       dismissDirection: DismissDirection.horizontal,
  //       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
  //       elevation: 5,
  //       content: Text(message??""),
  //       backgroundColor: _getSnackBarColor(type),
  //     ),
  //   );
  // }
  //
  // Color _getSnackBarColor(NotificationType type) {
  //   switch (type) {
  //     case NotificationType.error:
  //       return Colors.red;
  //     case NotificationType.success:
  //       return Colors.green;
  //     default:
  //       return Colors.blue;
  //   }
  // }
}
