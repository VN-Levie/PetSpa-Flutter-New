import 'package:petspa_flutter/app_theme.dart';
import 'package:petspa_flutter/custom_drawer/drawer_user_controller.dart';
import 'package:petspa_flutter/custom_drawer/home_drawer.dart';
import 'package:petspa_flutter/feedback_screen.dart';
import 'package:petspa_flutter/help_screen.dart';
import 'package:petspa_flutter/home_screen.dart';
import 'package:petspa_flutter/invite_friend_screen.dart';
import 'package:petspa_flutter/introduction_animation/introduction_animation_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationHomeScreen extends StatefulWidget {
  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget? screenView;
  DrawerIndex? drawerIndex;
  bool _isFirstOpen = true;
  @override
  void initState() {
    super.initState();

    _initialize();
  }

  Future<void> _initialize() async {
    await _checkFirstOpen();
    setState(() {
      drawerIndex = DrawerIndex.HOME;
      if (_isFirstOpen) {
        screenView = IntroductionAnimationScreen();
      } else {
        screenView = const MyHomePage();
      }
    });
  }

  Future<void> _checkFirstOpen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isFirstOpen = prefs.getBool('isFirstOpen') ?? true;
      // Nếu đây là lần mở đầu tiên, lưu trạng thái mới
      if (_isFirstOpen) {
        prefs.setBool('isFirstOpen', false);
      }
    });
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
                  },
                  screenView: screenView,
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
