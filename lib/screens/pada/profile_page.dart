import 'package:deliverapp/core/errors/exceptions.dart';
import 'package:deliverapp/core/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:deliverapp/screens/pada/login_page.dart';
import 'package:deliverapp/screens/pada/support_page.dart';
import 'package:deliverapp/screens/pada/termsAndContions_page.dart';
import 'package:provider/provider.dart';
import '../../core/colors.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/services/notification_service.dart';
import '../../widgets/alert_dialog_widget.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool success = false;
  List<dynamic> historyList = [];
  final ScrollController _scrollController = ScrollController();

  bool isLoading = false;

  // List<ConnectHistoryModel> names = [];
  int skip = 0;
  int limit = 10;
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), getData()); // getData();
    // this._getMoreData();
    super.initState();
  }

  getData() {
    historyList = [
      {
        "label": "Edit Profile",
        "icon": 'assets/images/profile.svg',
        "onTap": () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const EditProfilePage()));
        }
      },
      {
        "label": "Terms and conditions",
        "icon": 'assets/images/terms.svg',
        "onTap": () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const TermsAndConditionsPage()));
        }
      },
      {
        "label": "Support",
        "icon": 'assets/images/mail.svg',
        "onTap": () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SupportPage()));
        }
      },
      {
        "label": "Logout",
        "icon": 'assets/images/logout.svg',
        "onTap": () {
          CustomAlertDialog().successDialog(context, "Alert!",
              "Are you sure you want to logout?", "Confirm", "Cancel", () {
            final authProvider =
                Provider.of<AuthProvider>(context, listen: false);
            authProvider.clearLoginCredentials();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
              (Route<dynamic> route) => false,
            );
          }, () {
            Navigator.pop(context);
          }, okBtnColor: Colors.red);
        }
      },
      {
        "label": "Delete user",
        "icon": 'assets/images/hand.svg',
        "onTap": () {
          CustomAlertDialog().successDialog(
              context,
              "Alert!",
              "Are you sure you want to delete your data?",
              "Confirm",
              "Cancel", () async {
            final authProvider =
                Provider.of<AuthProvider>(context, listen: false);
            authProvider.clearLoginCredentials();
            try {
              await ApiService().deleteUser().then((value) {
                debugPrint("ress:: $value");
                if (value['success']) {
                  if (mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                      (Route<dynamic> route) => false,
                    );
                  }
                } else {
                  if (mounted) {
                    notificationService.showToast(context, value['message'],
                        type: NotificationType.error);
                  }
                }
              });
            } catch (e) {
              if (e is ClientException) {
                notificationService.showToast(context, e.message,
                    type: NotificationType.error);
              }
              if (e is HttpException) {
                notificationService.showToast(context, e.message,
                    type: NotificationType.error);
              }
              if (e is ServerException) {
                notificationService.showToast(context, e.message,
                    type: NotificationType.error);
              }
            }
          }, () {
            Navigator.pop(context);
          }, okBtnColor: Colors.red);
        }
      },
    ];
    success = true;
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    skip = 0;
    limit = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 25),
                      child: Text(
                        "Account",
                        style: GoogleFonts.inter(
                            color: pureBlack,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          child: ListView.builder(
                              controller: _scrollController,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: historyList.length,
                              padding: EdgeInsets.zero,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  child: ListTile(
                                    onTap: historyList[index]['onTap'],
                                    leading: SvgPicture.asset(
                                      historyList[index]['icon'],
                                      fit: BoxFit.fill,
                                      height: 15,
                                      width: 15,
                                      color: buttonColor,
                                    ),
                                    title: Text(
                                      historyList[index]["label"],
                                      style: GoogleFonts.inter(
                                          color: pureBlack,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    trailing: const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 24,
                                      color: pureBlack,
                                    ),
                                  ),
                                );
                              }),
                        ))
                  ]),
                ),
              ),
            ),
          ))
        ],
      )),
    );
  }
}
