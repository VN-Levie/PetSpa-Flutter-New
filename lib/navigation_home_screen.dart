import 'package:petspa_flutter/app_theme.dart';
import 'package:petspa_flutter/custom_drawer/drawer_user_controller.dart';
import 'package:petspa_flutter/custom_drawer/home_drawer.dart';
import 'package:petspa_flutter/feedback_screen.dart';
import 'package:petspa_flutter/help_screen.dart';
import 'package:petspa_flutter/home_screen.dart';
import 'package:petspa_flutter/invite_friend_screen.dart';
import 'package:petspa_flutter/introduction_animation/introduction_animation_screen.dart';
import 'package:flutter/material.dart';

class NavigationHomeScreen extends StatefulWidget {
  final bool isFirstOpen;

  const NavigationHomeScreen({Key? key, required this.isFirstOpen}) : super(key: key);

  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget? screenView;
  DrawerIndex? drawerIndex;

  @override
  void initState() {
    super.initState();
    drawerIndex = DrawerIndex.HOME;
    if (widget.isFirstOpen) {
      screenView = IntroductionAnimationScreen();
    } else {
      screenView = const MyHomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.white,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppTheme.nearlyWhite,
          body: screenView is IntroductionAnimationScreen
              ? screenView
              : DrawerUserController(
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
      switch (drawerIndex) {
        case DrawerIndex.HOME:
          setState(() {
            screenView = const MyHomePage();
          });
          break;
        case DrawerIndex.Help:
          setState(() {
            screenView = HelpScreen();
          });
          break;
        case DrawerIndex.FeedBack:
          setState(() {
            screenView = FeedbackScreen();
          });
          break;
        case DrawerIndex.Invite:
          setState(() {
            screenView = InviteFriend();
          });
          break;
        default:
          break;
      }
    }
  }
}
