import 'package:petspa_flutter/home_screen.dart';
import 'package:petspa_flutter/introduction_animation/components/shop_n_stay_view.dart';
import 'package:petspa_flutter/introduction_animation/components/center_next_button.dart';
import 'package:petspa_flutter/introduction_animation/components/connect_view.dart';
import 'package:petspa_flutter/introduction_animation/components/pnp_view.dart';
import 'package:petspa_flutter/introduction_animation/components/splash_view.dart';
import 'package:petspa_flutter/introduction_animation/components/top_back_skip_view.dart';
import 'package:petspa_flutter/introduction_animation/components/welcome_view.dart';
import 'package:flutter/material.dart';
import 'package:petspa_flutter/navigation_home_screen.dart';
import 'package:petspa_flutter/screens/signup/sign_up.dart';

class IntroductionAnimationScreen extends StatefulWidget {
  const IntroductionAnimationScreen({Key? key}) : super(key: key);

  @override
  _IntroductionAnimationScreenState createState() => _IntroductionAnimationScreenState();
}

class _IntroductionAnimationScreenState extends State<IntroductionAnimationScreen> with TickerProviderStateMixin {
  AnimationController? _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 8));
    _animationController?.animateTo(0.0);
    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(_animationController?.value);
    return Scaffold(
      backgroundColor: Color(0xffF7EBE1),
      body: ClipRect(
        child: Stack(
          children: [
            SplashView(
              animationController: _animationController!,
            ),
            RelaxView(
              animationController: _animationController!,
            ),
            CareView(
              animationController: _animationController!,
            ),
            MoodDiaryVew(
              animationController: _animationController!,
            ),
            WelcomeView(
              animationController: _animationController!,
            ),
            TopBackSkipView(
              onBackClick: _onBackClick,
              onSkipClick: _onSkipClick,
              animationController: _animationController!,
            ),
            CenterNextButton(
              animationController: _animationController!,
              onNextClick: _onNextClick,
            ),
          ],
        ),
      ),
    );
  }

  void _onSkipClick() {
    _animationController?.animateTo(0.8, duration: Duration(milliseconds: 1200));
  }

  void _onBackClick() {
    if (_animationController!.value >= 0 && _animationController!.value <= 0.2) {
      _animationController?.animateTo(0.0);
    } else if (_animationController!.value > 0.2 && _animationController!.value <= 0.4) {
      _animationController?.animateTo(0.2);
    } else if (_animationController!.value > 0.4 && _animationController!.value <= 0.6) {
      _animationController?.animateTo(0.4);
    } else if (_animationController!.value > 0.6 && _animationController!.value <= 0.8) {
      _animationController?.animateTo(0.6);
    } else if (_animationController!.value > 0.8 && _animationController!.value <= 1.0) {
      _animationController?.animateTo(0.8);
    }
  }

  void _onNextClick() {
    if (_animationController!.value >= 0 && _animationController!.value <= 0.2) {
      _animationController?.animateTo(0.4);
    } else if (_animationController!.value > 0.2 && _animationController!.value <= 0.4) {
      _animationController?.animateTo(0.6);
    } else if (_animationController!.value > 0.4 && _animationController!.value <= 0.6) {
      _animationController?.animateTo(0.8);
    } else if (_animationController!.value > 0.6 && _animationController!.value <= 0.8) {
      _signUpClick();
    }
  }

  void _signUpClick() {
    // Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => SignUpScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }
}
