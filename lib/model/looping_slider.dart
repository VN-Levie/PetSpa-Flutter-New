import 'dart:async';
import 'package:flutter/material.dart';

class LoopingSlider extends StatefulWidget {
  @override
  _LoopingSliderState createState() => _LoopingSliderState();
}

class _LoopingSliderState extends State<LoopingSlider> {
  final PageController _pageControllerLoop = PageController();
  late Timer _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Tự động chuyển trang sau mỗi 3 giây
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_pageControllerLoop.hasClients) {
        setState(() {
          _currentPage = (_currentPage + 1) % 3; // Loop qua các trang
          _pageControllerLoop.animateToPage(
            _currentPage,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Hủy timer khi widget bị dispose
    _pageControllerLoop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
      width: double.infinity,
      height: 150.0,
      child: PageView(
        controller: _pageControllerLoop,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              image: DecorationImage(
                image: AssetImage('assets/introduction_animation/su.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              image: DecorationImage(
                image: AssetImage('assets/introduction_animation/su.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              image: DecorationImage(
                image: AssetImage('assets/introduction_animation/su.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
