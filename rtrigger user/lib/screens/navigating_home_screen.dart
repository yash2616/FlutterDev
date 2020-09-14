import 'package:flutter/material.dart';
import 'package:user/auth/auth.dart';
import 'package:user/models/profile.dart';
import 'package:user/screens/drawer_contact_screen.dart';
import 'package:user/screens/drawer_order_screen.dart';
import 'package:user/screens/drawer_profile_screen.dart';
import 'package:user/screens/drawer_cart_screen.dart';
import 'package:user/screens/home_screen.dart';
import 'package:user/widgets/homedrawer.dart';
import '../Models/apptheme.dart';
import '../widgets/customdrawer.dart';

class NavigationHomeScreen extends StatefulWidget {
  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget screenView;
  DrawerIndex drawerIndex;

  @override
  void initState() {
    drawerIndex = DrawerIndex.HOME;
    screenView = Home();

    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.grey,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppTheme.nearlyWhite,
          body: DrawerUserController(
              screenIndex: drawerIndex,
              drawerWidth: MediaQuery.of(context).size.width * 0.75,
              onDrawerCall: (DrawerIndex drawerIndexdata) {
                changeIndex(drawerIndexdata);
                //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
              },
              screenView: screenView,
              //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
            ),
        ),
      ),
    );
  }


  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.HOME) {
        setState(() {
          screenView = Home();
          drawerIndex = DrawerIndex.HOME;
        });
      } else if (drawerIndex == DrawerIndex.ORDERS) {
        setState(() {
          screenView = OrderScreen(false);
          drawerIndex = DrawerIndex.ORDERS;
        });
      } else if (drawerIndex == DrawerIndex.MYCART) {
        setState(() {
          screenView = FoodCart(false);
          drawerIndex = DrawerIndex.MYCART;
        });
      } else if (drawerIndex == DrawerIndex.PROFILE) {
        setState(() {
          screenView = Profile(isAppBar: false);
          drawerIndex = DrawerIndex.PROFILE;
        });
      } else if (drawerIndex == DrawerIndex.CONTACTUS) {
        setState(() {
          screenView = Contact();
          drawerIndex = DrawerIndex.CONTACTUS;
        });
      } else {
        //do in your way......
      }
    }
  }
}
