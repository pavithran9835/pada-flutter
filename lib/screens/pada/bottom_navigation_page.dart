import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:deliverapp/core/colors.dart';
import 'package:deliverapp/screens/pada/home_page.dart';
import 'package:deliverapp/screens/pada/profile_page.dart';
import 'package:deliverapp/screens/pada/wallet_page.dart';
import 'package:provider/provider.dart';

import '../../core/providers/app_provider.dart';
import 'order_history_page.dart';

enum TabItem { home, orders, wallet, profile }

const Map<TabItem, dynamic> tabName = {
  TabItem.home: {
    'label': 'Home',
    'icon': 'assets/images/home.svg',
    'widget': HomePage()
  },
  TabItem.orders: {
    'label': 'Orders',
    'icon': 'assets/images/record.svg',
    'widget': OrderHistoryPage()
  },
  TabItem.wallet: {
    'label': 'Wallet',
    'icon': 'assets/images/wallet.svg',
    'widget': WalletPage()
  },
  TabItem.profile: {
    'label': 'Profile',
    'icon': 'assets/images/profile.svg',
    'widget': ProfilePage()
  }
};

class BottomNavPage extends StatefulWidget {
  const BottomNavPage({super.key});

  @override
  State<BottomNavPage> createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage> {
  Widget? baseWidget = const HomePage();
  var _currentTab = TabItem.home;

  void _selectTab(TabItem tabItem) {
    setState(() => _currentTab = tabItem);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print("Disposing BottomNavPageState");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: BottomNavigation(
        currentTab: _currentTab,
        onSelectTab: _selectTab,
      ),
    );
  }

  Widget _buildBody() {
    return Container(
        color: pureWhite,
        alignment: Alignment.center,
        child: tabName[_currentTab]['widget']);
  }
}

class BottomNavigation extends StatefulWidget {
  const BottomNavigation(
      {super.key, required this.currentTab, required this.onSelectTab});
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  bool back = false;
  int time = 0;
  int duration = 1000;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<bool> willPop() async {
    int now = DateTime.now().millisecondsSinceEpoch;
    if (back && time >= now) {
      back = false;
      SystemNavigator.pop();
    } else {
      time = DateTime.now().millisecondsSinceEpoch + duration;
      print("again tap");
      back = true;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Press again the button to exit")));
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    return PopScope(
      onPopInvoked: (val) async{
       await willPop();
      },
      child: SafeArea(
        child: BottomNavigationBar(
            backgroundColor: primaryColor,
            type: BottomNavigationBarType.fixed,
            iconSize: 20,
            selectedFontSize: 0.0,
            unselectedFontSize: 0.0,
            items: [
              _buildItem(TabItem.home),
              _buildItem(TabItem.orders),
              _buildItem(TabItem.wallet),
              _buildItem(TabItem.profile),
            ],
            onTap: (index) {
              widget.onSelectTab(
                TabItem.values[index],
              );
              setState(() {});
            }),
      ),
    );
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    return BottomNavigationBarItem(
      icon: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: SvgPicture.asset(
              tabName[tabItem]['icon'],
              fit: BoxFit.fill,
              colorFilter: ColorFilter.mode(
                  widget.currentTab == tabItem ? secondaryColor : Colors.white,
                  BlendMode.srcIn),
              // theme: SvgTheme(currentColor: _colorTabMatching(tabItem)),
            ),
          ),
          Text(
            tabName[tabItem]['label'],
            style: TextStyle(
              fontSize: 12,
              color:
                  widget.currentTab == tabItem ? secondaryColor : Colors.white,
            ),
          )
        ],
      ),
      label: "",
    );
  }

  Color _colorTabMatching(TabItem item) {
    return widget.currentTab == item ? secondaryColor : Colors.grey;
  }
}
