import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';

class AnimatedPageView extends StatefulWidget {
  const AnimatedPageView({Key? key}) : super(key: key);

  @override
  State<AnimatedPageView> createState() => _AnimatedPageViewState();
}

class _AnimatedPageViewState extends State<AnimatedPageView> {

  late final PageController _pageController;
  int _index = 0;
  double _delta = 0;
  bool _animating = false;

  final List<Widget> _pages = const [
    FirstPage(),
    SecondPage(),
    ThirdPage(),
    FourthPage(),
  ];

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  void _onDragUpdate(details) {
    if(_animating) return;
    setState(() {
      MediaQueryData screenData = MediaQuery.of(context);
      _delta += details.delta.dy;
      if(_delta > screenData.size.height * 0.2) {
        _delta = 0;
        _animating = true;
        if(_index > 0) {
          _index--;
          _pageController.animateToPage(_index,
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeInOut,
          ).then((value) => setState(() {
            _animating = false;
          }));
        }
      } else if(_delta < screenData.size.height * -0.2) {
        _delta = 0;
        _animating = true;
        if(_index < _pages.length) {
          _index++;
          _pageController.animateToPage(_index,
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeInOut,
          ).then((value) => setState(() {
            _animating = false;
          }));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: GestureDetector(
        onVerticalDragStart: (details) => setState(() {
          _delta = 0;
        }),
        onVerticalDragUpdate: _onDragUpdate,
        onVerticalDragEnd: (details) => setState(() {
          _delta = 0;
        }),
        child: PageView(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) => setState(() {
            _index = index;
          }),
          children: _pages,
        ),
      ),
    );
  }
}

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}
class _FirstPageState extends State<FirstPage> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _sunAnimation;
  late final Animation<double> _cloud1Animation;
  late final Animation<double> _cloud2Animation;
  late final Animation<double> _cloud3Animation;
  late final Animation<double> _cloud4Animation;

  late AccelerometerEvent _acceleration;
  late AccelerometerEvent _filteredAcceleration;
  late final StreamSubscription<AccelerometerEvent> _streamSubscription;
  late final Timer _timer;

  final double _sensitivity = 0.1;

  @override
  void initState() {
    _buildParallax();
    _buildAnimations();
    super.initState();
    _animationController.forward();
  }

  void _buildParallax() {
    _acceleration = AccelerometerEvent(0, 0, 0);
    _filteredAcceleration = _acceleration;
    _streamSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _acceleration = event;
      });
    });
    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) => setState(() {
      if(mounted) {
        _filteredAcceleration = AccelerometerEvent(
          _filteredAcceleration.x + ((_acceleration.x - _filteredAcceleration.x) * _sensitivity),
          _filteredAcceleration.y + ((_acceleration.y - _filteredAcceleration.y) * _sensitivity),
          _filteredAcceleration.z + ((_acceleration.z - _filteredAcceleration.z) * _sensitivity),
        );
      }
    }));
  }
  void _buildAnimations() {
    _animationController = AnimationController(vsync: this,
      duration: const Duration(seconds: 1),
      reverseDuration: const Duration(milliseconds: 500),
    );
    _sunAnimation = Tween<double>(begin: 1, end: 0)
        .animate(CurvedAnimation(parent: _animationController,
      curve: const Interval(0, 0.7, curve: Curves.easeOut),
    ));
    _cloud1Animation = Tween<double>(begin: 1, end: 0)
        .animate(CurvedAnimation(parent: _animationController,
      curve: const Interval(0.3, 1, curve: Curves.easeOut),
    ));
    _cloud2Animation = Tween<double>(begin: 1, end: 0)
        .animate(CurvedAnimation(parent: _animationController,
      curve: const Interval(0.1, 0.8, curve: Curves.easeOut),
    ));
    _cloud3Animation = Tween<double>(begin: 1, end: 0)
        .animate(CurvedAnimation(parent: _animationController,
      curve: const Interval(0.2, 0.9, curve: Curves.easeOut),
    ));
    _cloud4Animation = Tween<double>(begin: 1, end: 0)
        .animate(CurvedAnimation(parent: _animationController,
      curve: const Interval(0.15, 0.95, curve: Curves.easeOut),
    ));
  }

  @override
  void dispose() {
    _timer.cancel();
    _streamSubscription.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Positioned(
                    left: constraints.maxWidth/2,
                    top: constraints.maxHeight/2 + 50,
                    child: Transform.translate(
                      offset: Offset(_cloud1Animation.value * 170, 0)
                          + Offset(-_filteredAcceleration.x*0.9, _filteredAcceleration.y*0.9),
                      child: Opacity(
                        opacity: (1 - _cloud1Animation.value) * 0.5 + 0.5,
                        child: SizedBox(
                          width: 170,
                          child: Image.network("https://www.seekpng.com/png/full/482-4823332_cloud-white-cloud-vector-png.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: constraints.maxWidth/2 - 140,
                    top: constraints.maxHeight/2 - 80,
                    child: Transform.translate(
                      offset: Offset(_cloud3Animation.value * 130, 0)
                          + Offset(-_filteredAcceleration.x*1, _filteredAcceleration.y*1),
                      child: Opacity(
                        opacity: (1 - _cloud3Animation.value) * 0.5 + 0.5,
                        child: SizedBox(
                          width: 130,
                          child: Image.network("https://www.seekpng.com/png/full/482-4823332_cloud-white-cloud-vector-png.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Transform.translate(
                      offset: Offset(_sunAnimation.value * 100, 0)
                          + Offset(-_filteredAcceleration.x * 2,
                              _filteredAcceleration.y * 2),
                      child: Opacity(
                        opacity: 1,
                        child: Container(
                          height: 200,
                          width: 200,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Colors.yellowAccent, Colors.deepOrange],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black45,
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: constraints.maxWidth/2 - 160,
                    top: constraints.maxHeight/2 + 10,
                    child: Transform.translate(
                      offset: Offset(_cloud2Animation.value * 150, 0)
                          + Offset(-_filteredAcceleration.x * 3,
                              _filteredAcceleration.y * 3),
                      child: Opacity(
                        opacity: (1 - _cloud2Animation.value) * 0.5 + 0.5,
                        child: SizedBox(
                          width: 150,
                          child: Image.network("https://www.seekpng.com/png/full/482-4823332_cloud-white-cloud-vector-png.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: constraints.maxWidth/2 + 50,
                    top: constraints.maxHeight/2 - 70,
                    child: Transform.translate(
                      offset: Offset(_cloud4Animation.value * 120, 0)
                          + Offset(-_filteredAcceleration.x * 2.5,
                              _filteredAcceleration.y * 2.5),
                      child: Opacity(
                        opacity: (1 - _cloud4Animation.value) * 0.5 + 0.5,
                        child: SizedBox(
                          width: 120,
                          child: Image.network("https://www.seekpng.com/png/full/482-4823332_cloud-white-cloud-vector-png.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.translate(
                  offset: Offset(-10 * _cloud4Animation.value, 0),
                  child: Opacity(
                    opacity: 1 - _cloud4Animation.value,
                    child: const Text("App", textAlign: TextAlign.start, style: TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white,
                    )),
                  ),
                ),
                const SizedBox(height: 20),
                Transform.translate(
                  offset: Offset(-20 * _cloud3Animation.value, 0),
                  child: Opacity(
                    opacity: 1 - _cloud3Animation.value,
                    child: Text("Description", textAlign: TextAlign.start, style: TextStyle(
                      fontSize: 20, fontStyle: FontStyle.italic, color: Colors.white.withOpacity(0.7),
                    )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  State<SecondPage> createState() => _SecondPageState();
}
class _SecondPageState extends State<SecondPage> with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _cloud1Animation;
  late final Animation<double> _cloud2Animation;
  late final Animation<double> _cloud3Animation;

  late final AnimationController _repeatAnimationController;
  late final Animation<double> _repeatCloud1Animation;

  @override
  void initState() {
    _buildAnimations();
    _buildRepeatAnimation();
    super.initState();
    _animationController.forward();
    _repeatAnimationController.repeat(reverse: true);
  }

  void _buildRepeatAnimation() {
    _repeatAnimationController = AnimationController(vsync: this,
      duration: const Duration(seconds: 1),
      reverseDuration: const Duration(seconds: 1),
    )..addListener(() {
      if(mounted) {
        setState(() {});
      }
    });
    _repeatCloud1Animation = Tween<double>(begin: 1, end: 0)
        .animate(CurvedAnimation(parent: _repeatAnimationController,
      curve: const Interval(0, 1, curve: Curves.easeInOut),
      reverseCurve: const Interval(0, 1, curve: Curves.easeInOut),
    ));
  }
  void _buildAnimations() {
    _animationController = AnimationController(vsync: this,
      duration: const Duration(seconds: 1),
      reverseDuration: const Duration(milliseconds: 500),
    );
    _cloud1Animation = Tween<double>(begin: 1, end: 0)
        .animate(CurvedAnimation(parent: _animationController,
      curve: const Interval(0.3, 1, curve: Curves.easeOut),
    ));
    _cloud2Animation = Tween<double>(begin: 1, end: 0)
        .animate(CurvedAnimation(parent: _animationController,
      curve: const Interval(0.1, 0.8, curve: Curves.easeOut),
    ));
    _cloud3Animation = Tween<double>(begin: 1, end: 0)
        .animate(CurvedAnimation(parent: _animationController,
      curve: const Interval(0.2, 0.9, curve: Curves.easeOut),
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _repeatAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ClipRect(
          child: Stack(
            children: [
              Positioned(
                left: constraints.maxWidth/2 - 70,
                top: constraints.maxHeight/3 + 20,
                child: Transform.translate(
                  offset: Offset(_cloud3Animation.value * 130, _repeatCloud1Animation.value * 10),
                  child: Opacity(
                    opacity: (1 - _cloud3Animation.value) * 0.5 + 0.5,
                    child: SizedBox(
                      width: 130,
                      child: Image.network("https://www.seekpng.com/png/full/482-4823332_cloud-white-cloud-vector-png.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: constraints.maxWidth/4-70,
                top: constraints.maxHeight*2/3,
                child: Transform.translate(
                  offset: Offset(_cloud1Animation.value * 170, _repeatCloud1Animation.value * 10),
                  child: Opacity(
                    opacity: (1 - _cloud1Animation.value) * 0.5 + 0.5,
                    child: SizedBox(
                      width: 170,
                      child: Image.network("https://www.seekpng.com/png/full/482-4823332_cloud-white-cloud-vector-png.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox.expand(
                child: ClipShadowPath(
                  shadow: const Shadow(
                    color: Colors.black38,
                    blurRadius: 4,
                    offset: Offset.zero,
                  ),
                  clipper: SecondPageClipper(),
                  child: Container(
                    color: Colors.orange.shade600,
                  ),
                ),
              ),
              Positioned(
                left: constraints.maxWidth/2 - 50,
                top: constraints.maxHeight/2,
                child: Transform.translate(
                  offset: Offset(_cloud2Animation.value * 100, _repeatCloud1Animation.value * 10),
                  child: Opacity(
                    opacity: (1 - _cloud2Animation.value) * 0.5 + 0.5,
                    child: SizedBox(
                      width: 150,
                      child: Image.network("https://www.seekpng.com/png/full/482-4823332_cloud-white-cloud-vector-png.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ThirdPage extends StatefulWidget {
  const ThirdPage({Key? key}) : super(key: key);

  @override
  State<ThirdPage> createState() => _ThirdPageState();
}
class _ThirdPageState extends State<ThirdPage> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _backgroundAnimation;

  late AccelerometerEvent _acceleration;
  late AccelerometerEvent _filteredAcceleration;
  late final StreamSubscription<AccelerometerEvent> _streamSubscription;
  late final Timer _timer;

  final double _sensitivity = 0.1;

  @override
  void initState() {
    _buildAnimations();
    _buildParallax();
    super.initState();
    _animationController.forward();
  }

  void _buildParallax() {
    _acceleration = AccelerometerEvent(0, 0, 0);
    _filteredAcceleration = _acceleration;
    _streamSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _acceleration = event;
      });
    });
    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) => setState(() {
      if(mounted) {
        _filteredAcceleration = AccelerometerEvent(
          _filteredAcceleration.x + ((_acceleration.x - _filteredAcceleration.x) * _sensitivity),
          _filteredAcceleration.y + ((_acceleration.y - _filteredAcceleration.y) * _sensitivity),
          _filteredAcceleration.z + ((_acceleration.z - _filteredAcceleration.z) * _sensitivity),
        );
      }
    }));
  }
  void _buildAnimations() {
    _animationController = AnimationController(vsync: this,
      duration: const Duration(seconds: 1),
    );
    _backgroundAnimation = Tween<double>(begin: 1, end: 0)
        .animate(CurvedAnimation(parent: _animationController,
      curve: const Interval(0, 1, curve: Curves.easeInOut),
    ));
  }

  @override
  void dispose() {
    _timer.cancel();
    _streamSubscription.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ClipRect(
          child: Stack(
            children: [
              SizedBox.square(
                dimension: constraints.maxWidth,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox.square(
                        dimension: constraints.maxWidth * 0.5,
                        child: Transform.translate(
                          offset: Offset(_backgroundAnimation.value * constraints.maxWidth, 0)
                              + Offset(-_filteredAcceleration.x * 2, _filteredAcceleration.y * 2),
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      CustomPaint(
                        painter: BorderShadowPainter(
                          radius: constraints.maxWidth * 0.6,
                          shadow: const Shadow(
                            color: Colors.black38,
                            blurRadius: 4,
                          ),
                          border: const BorderSide(width: 3, color: Colors.transparent),
                        ),
                        child: SizedBox.square(
                          dimension: constraints.maxWidth * 0.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ClipPath(
                      clipper: ThirdCirclePageClipper(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.orange.shade600,
                          border: Border.all(color: Colors.orange.shade600,),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ClipRect(
                      child: ClipShadowPath(
                        shadow: const Shadow(
                          color: Colors.black38,
                          blurRadius: 4,
                          offset: Offset(0, 0),
                        ),
                        clipper: ThirdPageClipper(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.orange.shade600,
                            border: Border.all(color: Colors.orange.shade600,),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class FourthPage extends StatefulWidget {
  const FourthPage({Key? key}) : super(key: key);

  @override
  State<FourthPage> createState() => _FourthPageState();
}
class _FourthPageState extends State<FourthPage> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _coverPositionAnimation;
  late final Animation<double> _coverWidthAnimation;
  late final Animation<double> _coverOuterWidthAnimation;
  late final Animation<double> _coverScaleAnimation;

  @override
  void initState() {
    _buildAnimations();
    super.initState();
    _animationController.forward();
  }

  void _buildAnimations() {
    _animationController = AnimationController(vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..addListener(() {
      if(mounted) {
        setState(() {});
      }
    });
    _coverPositionAnimation = Tween<double>(begin: 1, end: 0)
        .animate(CurvedAnimation(parent: _animationController,
      curve: const Interval(0.1, 0.6, curve: Curves.easeOut),
    ));
    _coverWidthAnimation = Tween<double>(begin: 1, end: 0)
        .animate(CurvedAnimation(parent: _animationController,
      curve: const Interval(0.3, 0.6, curve: Curves.easeOut),
    ));
    _coverOuterWidthAnimation = Tween<double>(begin: 1, end: 0)
        .animate(CurvedAnimation(parent: _animationController,
      curve: const Interval(0.6, 0.8, curve: Curves.easeInOut),
    ));
    _coverScaleAnimation = Tween<double>(begin: 1, end: 0)
        .animate(CurvedAnimation(parent: _animationController,
      curve: const Interval(0.7, 1, curve: Curves.easeOut),
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData screen = MediaQuery.of(context);
    return LayoutBuilder(builder: (context, constraints) {
      return ClipRect(
        child: Stack(
          children: [
            SizedBox.expand(
              child: ClipShadowPath(
                shadow: const Shadow(
                  color: Colors.black38,
                  blurRadius: 4,
                  offset: Offset(0, 0),
                ),
                clipper: FourthPageClipper(),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.orange.shade600,
                    border: Border.all(color: Colors.orange.shade600,),
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Transform.translate(
                    offset: Offset(_coverPositionAnimation.value * screen.size.width, 0),
                    child: Transform.scale(
                      scale: 1 - _coverScaleAnimation.value * 0.1,
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black38,
                              spreadRadius: (1 - _coverScaleAnimation.value) * 2,
                              blurRadius: (1 - _coverScaleAnimation.value) * 5,
                              offset: Offset.zero,
                            ),
                          ]
                        ),
                        child: Stack(
                          children: [
                            SizedBox(
                              width: constraints.maxWidth * 2/3,
                              height: constraints.maxWidth * 2/3,
                              child: Image.network("https://coralwebconcept.com/wp-content/uploads/2021/11/mobile-app-development.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              width: _coverOuterWidthAnimation.value * constraints.maxWidth * 2/3
                                  + _coverWidthAnimation.value * constraints.maxWidth,
                              height: constraints.maxWidth * 2/3,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(_coverPositionAnimation.value * screen.size.width, 0),
                    child: Transform.scale(
                      scale: 1 - _coverScaleAnimation.value * 0.1,
                      child: Container(
                        decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black38,
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset.zero,
                              ),
                            ]
                        ),
                        child: Stack(
                          children: [
                            SizedBox(
                              width: constraints.maxWidth * 2/3,
                              height: constraints.maxWidth * 2/3,
                              child: Image.network("https://www.kernix.com/doc/flutterCover.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              width: _coverOuterWidthAnimation.value * constraints.maxWidth * 2/3
                                  + _coverWidthAnimation.value * constraints.maxWidth,
                              height: constraints.maxWidth * 2/3,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}


class SecondPageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }

}
class ThirdCirclePageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    var radius = size.width * 0.3;
    path.addOval(Rect.fromLTRB(
      size.width / 2 - radius,
      size.width / 2 - radius,
      size.width / 2 + radius,
      size.width / 2 + radius,
    ));
    path.fillType = PathFillType.evenOdd;
    path.addRect(Rect.largest);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
class ThirdPageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
class FourthPageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height / 2);
    path.lineTo(size.width / 2, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }

}

class ClipShadowPath extends StatelessWidget {
  final Shadow shadow;
  final CustomClipper<Path> clipper;
  final Widget child;

  const ClipShadowPath({
    Key? key,
    required this.shadow,
    required this.clipper,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ClipShadowShadowPainter(
        clipper: clipper,
        shadow: shadow,
      ),
      child: ClipPath(child: child, clipper: clipper),
    );
  }
}
class _ClipShadowShadowPainter extends CustomPainter {
  final Shadow shadow;
  final CustomClipper<Path> clipper;

  _ClipShadowShadowPainter({required this.shadow, required this.clipper});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = shadow.toPaint();
    var clipPath = clipper.getClip(size).shift(shadow.offset);
    canvas.drawPath(clipPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class BorderShadowPainter extends CustomPainter {
  final Shadow shadow;
  final BorderSide border;
  final double radius;

  BorderShadowPainter({this.shadow = const Shadow(),
    this.border = const BorderSide(), this.radius = 0});

  @override
  void paint(Canvas canvas, Size size) {
    final rectBorder = RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius));
    final rectShadow = RRect.fromRectAndRadius(shadow.offset & size, Radius.circular(radius));

    final shadowPaint = Paint()
      ..strokeWidth = border.width
      ..color = shadow.color
      ..style = PaintingStyle.stroke
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadow.blurRadius);
    final borderPaint = Paint()
      ..strokeWidth = border.width
      ..color = border.color
      ..style = PaintingStyle.stroke;

    canvas.drawRRect(rectShadow, shadowPaint);
    canvas.drawRRect(rectBorder, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}