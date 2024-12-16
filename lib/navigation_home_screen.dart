import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:petspa_flutter/app_theme.dart';
import 'package:petspa_flutter/custom_drawer/drawer_user_controller.dart';
import 'package:petspa_flutter/custom_drawer/home_drawer.dart';
import 'package:petspa_flutter/feedback_screen.dart';
import 'package:petspa_flutter/fitness_app/fitness_app_home_screen.dart';
import 'package:petspa_flutter/help_screen.dart';
import 'package:petspa_flutter/home_screen.dart';
import 'package:petspa_flutter/invite_friend_screen.dart';
import 'package:petspa_flutter/introduction_animation/introduction_animation_screen.dart';
import 'package:flutter/material.dart';
import 'package:petspa_flutter/model/user_model.dart';
import 'package:petspa_flutter/screens/login/login.dart';
import 'package:petspa_flutter/services/rest_service.dart';
import 'package:petspa_flutter/services/user_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationHomeScreen extends StatefulWidget {
  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget? screenView;
  DrawerIndex? drawerIndex;
  bool _isFirstOpen = true;
  bool isLoading = true;
  final user = UserStorage().getUser();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  /// Kiểm tra trạng thái đăng nhập
  Future<void> checkLoginStatus() async {
    String? token = await UserStorage().getAccessToken();
    print("User: $user | Token: $token");
    if (token != null) {
      try {
        ApiResponse response = await RestService.post('/auth/login-token', {});
        print("Response: ${response.status} | ${response.data}");

        if (response.status == 200) {
          print("200");

          await UserStorage().saveUserDataAsync(User.fromJson(response.data));
          await UserStorage().saveToken(response.data['token'], response.data['refreshToken']);
          _navigateToHome();
          return;
        } else if (response.status == 401) {
          // Thử làm mới token nếu token hết hạn
          print("401");
          await _handleTokenRefresh();
        } else {
          print("Login status error: ${response.data}");
        }
      } catch (e) {
        print("Error during login check: $e");
      }
    }
    print("Not logged in.");
    _navigateToLogin();
  }

  /// Làm mới token khi token hết hạn
  Future<void> _handleTokenRefresh() async {
    try {
      String? newToken = await RestService.refreshToken();
      if (newToken != null) {
        ApiResponse response = await RestService.post('/auth/login-token', {});
        if (response.status == 200) {
          print("_handleTokenRefresh 200");
          await UserStorage().saveUserDataAsync(User.fromJson(response.data));
          await UserStorage().saveToken(response.data['token'], response.data['refreshToken']);
          _navigateToHome();
        } else {
          print("_handleTokenRefresh error: ${response.data}");
          _navigateToLogin();
        }
      } else {
        print("Token refresh failed.");
        _navigateToLogin();
      }
    } catch (e) {
      print("Error during token refresh: $e");
      _navigateToLogin();
    }
  }

  /// Chuyển đến màn hình chính
  void _navigateToHome() {
    setState(() {
      isLoading = false;
      screenView = const MyHomePage();
    });
  }

  /// Chuyển đến màn hình đăng nhập
  void _navigateToLogin() {
    // setState(() {
    //   isLoading = false;
    // });
    // Get.offAll(() => LoginScreen());
    // _navigateToHome();
    setState(() {
      isLoading = false;
      screenView = const MyHomePage();
    });
  }

  /// Kiểm tra lần mở đầu tiên
  Future<void> _checkFirstOpen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isFirstOpen = prefs.getBool('isFirstOpen') ?? true;

    if (_isFirstOpen) {
      await prefs.setBool('isFirstOpen', false);
    }
  }

  /// Khởi tạo màn hình ban đầu
  Future<void> _initialize() async {
    await _checkFirstOpen();
    if (_isFirstOpen) {
      setState(() {
        screenView = IntroductionAnimationScreen();
        isLoading = false;
      });
    } else {
      await checkLoginStatus();
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
          body: isLoading
              ? Center(child: CircularProgressIndicator()) // Hiển thị trạng thái tải
              : screenView is IntroductionAnimationScreen
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

  /// Thay đổi màn hình khi chọn từ menu
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
        case DrawerIndex.Profile:
          setState(() {
            screenView = FitnessAppHomeScreen();
          });
          break;
        default:
          break;
      }
    }
  }
}
