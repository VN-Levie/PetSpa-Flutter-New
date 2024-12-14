import 'package:petspa_flutter/app_theme.dart';
import 'package:flutter/material.dart';
import 'model/homelist.dart';
import 'dart:async';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  List<HomeList> homeList = HomeList.homeList;
  AnimationController? animationController;
  bool multiple = true;
  final PageController _pageControllerLoop = PageController();
  late Timer _timer;
  int _currentPage = 0;
  final List<Map<String, String>> slides = [
    {
      "image": "assets/introduction_animation/su.png",
      "title": "Pamper Your Pet",
      "intro": "Treat your furry friends to the best care!"
    },
    {
      "image": "assets/introduction_animation/su.png",
      "title": "Shop for Your Pet",
      "intro": "Discover a variety of premium pet products!"
    },
    {
      "image": "assets/introduction_animation/su.png",
      "title": "Relax & Stay",
      "intro": "Book a cozy, secure stay for your pet!"
    },
  ];
  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
    // Tự động chuyển trang sau mỗi 3 giây
    _timer = Timer.periodic(Duration(seconds: 6), (Timer timer) {
      if (_pageControllerLoop.hasClients) {
        setState(() {
          _currentPage = (_currentPage + 1) % 3; // Loop qua các trang
          _pageControllerLoop.animateToPage(
            _currentPage,
            duration: Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );
        });
      }
    });
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
  }

  @override
  void dispose() {
    animationController?.dispose();
    _timer.cancel(); // Hủy timer khi widget bị dispose
    _pageControllerLoop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    return Scaffold(
      backgroundColor: isLightMode == true ? AppTheme.white : AppTheme.nearlyBlack,
      body: FutureBuilder<bool>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          } else {
            return Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  appBar(),
                  Expanded(
                    child: FutureBuilder<bool>(
                      future: getData(),
                      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        if (!snapshot.hasData) {
                          return const SizedBox();
                        } else {
                          return Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                                width: double.infinity,
                                height: 230.0, // Tổng chiều cao cho cả ảnh và text
                                child: PageView.builder(
                                  itemCount: slides.length,
                                  controller: _pageControllerLoop,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        // Ảnh trong slider
                                        Expanded(
                                          flex: 4,
                                          child: Stack(
                                            children: [
                                              // Ảnh nền
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(4.0),
                                                  image: DecorationImage(
                                                    image: AssetImage(slides[index]["image"]!),
                                                    fit: BoxFit.fitWidth,
                                                  ),
                                                ),
                                              ),
                                              // Lớp filler bán trong suốt
                                              Positioned.fill(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(4.0),
                                                    color: Colors.black.withOpacity(0.25), // Filler màu đen mờ
                                                  ),
                                                ),
                                              ),
                                              // Text hiển thị trên ảnh
                                              Positioned(
                                                bottom: 16.0,
                                                left: 16.0,
                                                right: 16.0,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      slides[index]["title"]!,
                                                      style: const TextStyle(
                                                        fontSize: 20.0,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white, // Chữ màu trắng
                                                        shadows: [
                                                          Shadow(
                                                            blurRadius: 4.0,
                                                            color: Colors.black54,
                                                            offset: Offset(2.0, 2.0),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4.0),
                                                    Text(
                                                      slides[index]["intro"]!,
                                                      style: const TextStyle(
                                                        fontSize: 14.0,
                                                        color: Colors.white, // Chữ màu trắng
                                                        shadows: [
                                                          Shadow(
                                                            blurRadius: 4.0,
                                                            color: Colors.black54,
                                                            offset: Offset(2.0, 2.0),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 12.0),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              Expanded(
                                child: GridView(
                                  padding: const EdgeInsets.only(top: 0, left: 12, right: 12),
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  children: List<Widget>.generate(
                                    homeList.length,
                                    (int index) {
                                      final int count = homeList.length;
                                      final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0).animate(
                                        CurvedAnimation(
                                          parent: animationController!,
                                          curve: Interval((1 / count) * index, 1.0, curve: Curves.fastOutSlowIn),
                                        ),
                                      );
                                      animationController?.forward();
                                      return HomeListView(
                                        animation: animation,
                                        animationController: animationController,
                                        listData: homeList[index],
                                        callBack: () {
                                          Navigator.push<dynamic>(
                                            context,
                                            MaterialPageRoute<dynamic>(
                                              builder: (BuildContext context) => homeList[index].navigateScreen!,
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: multiple ? 2 : 1,
                                    mainAxisSpacing: 12.0,
                                    crossAxisSpacing: 12.0,
                                    childAspectRatio: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget appBar() {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    return SizedBox(
      height: AppBar().preferredSize.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 8),
            child: Container(
              width: AppBar().preferredSize.height - 8,
              height: AppBar().preferredSize.height - 8,
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Pet Spa',
                  style: TextStyle(
                    fontSize: 22,
                    color: isLightMode ? AppTheme.darkText : AppTheme.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 8),
            child: Container(
              width: AppBar().preferredSize.height - 8,
              height: AppBar().preferredSize.height - 8,
              color: isLightMode ? Colors.white : AppTheme.nearlyBlack,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppBar().preferredSize.height),
                  child: Icon(
                    multiple ? Icons.dashboard : Icons.view_agenda,
                    color: isLightMode ? AppTheme.dark_grey : AppTheme.white,
                  ),
                  onTap: () {
                    setState(() {
                      multiple = !multiple;
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeListView extends StatelessWidget {
  const HomeListView({Key? key, this.listData, this.callBack, this.animationController, this.animation}) : super(key: key);

  final HomeList? listData;
  final VoidCallback? callBack;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(0.0, 50 * (1.0 - animation!.value), 0.0),
            child: AspectRatio(
              aspectRatio: 1.5,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    Positioned.fill(
                      child: Image.asset(
                        listData!.imagePath,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.grey.withOpacity(0.2),
                        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                        onTap: callBack,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
