import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alpha Roll Assets',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ProcessingView(),
    );
  }
}

class ProcessingView extends StatefulWidget {
  const ProcessingView({Key? key}) : super(key: key);

  @override
  _ProcessingViewState createState() => _ProcessingViewState();
}
class _ProcessingViewState extends State<ProcessingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox.square(
              dimension: 100,
              child: AnimatedProcessingIcon(
                dimension: 120,
              ),
            ),
            const Divider(),
            AnimatedProcessingIcon(
              dimension: 100,
              animation: ProcessingAnimations.leave,
              maxLeaveWidth: MediaQuery.of(context).size.width,
            ),
            const Divider(),
            const AnimatedProcessingIcon(
              dimension: 100,
              animation: ProcessingAnimations.rotate,
            ),
          ],
        ),
      ),
    );
  }
}

enum ProcessingAnimations {
  scale,
  rotate,
  scaleRotate,
  leave,
}

class AnimatedProcessingIcon extends StatefulWidget {
  const AnimatedProcessingIcon({Key? key,
    this.animation = ProcessingAnimations.scale, this.maxLeaveWidth = 100,
    this.dimension = 120,
  }) : super(key: key);

  final ProcessingAnimations animation;
  final double maxLeaveWidth;
  final double dimension;

  @override
  _AnimatedProcessingIconState createState() => _AnimatedProcessingIconState();
}
class _AnimatedProcessingIconState extends State<AnimatedProcessingIcon>
    with TickerProviderStateMixin {

  late AnimationController _controller;
  late final Animation<double> hexA;
  late final Animation<double> hexB;
  late final Animation<double> hexC;

  @override
  void initState() {
    switch(widget.animation) {
      case ProcessingAnimations.scale: _scaleAnimationBuilder();
        break;
      case ProcessingAnimations.rotate: _rotateAnimationBuilder();
        break;
      case ProcessingAnimations.leave: _leaveAnimationBuilder();
        break;
      default: _scaleAnimationBuilder();
        break;
    }
    super.initState();
  }

  void _scaleAnimationBuilder() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1000),
        reverseDuration: const Duration(milliseconds: 300),
        vsync: this
    )..addListener(() {
      if(mounted) setState(() {});
    });
    hexA = Tween<double>(begin: 0, end: widget.dimension*0.3)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.0, 0.3,
        curve: Curves.easeIn,
      ),
    ),
    );
    hexB = Tween<double>(begin: 0, end: widget.dimension*0.27)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.1, 0.6,
        curve: Curves.easeInOut,
      ),
    ),
    );
    hexC = Tween<double>(begin: 0, end: widget.dimension*0.2)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.4, 1,
        curve: Curves.easeOutQuart,
      ),
    ),
    );
    _controller.repeat(
      reverse: true,
    );
  }
  void _rotateAnimationBuilder() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 3000),
        vsync: this
    )..addListener(() {
      if(mounted) setState(() {});
    });
    hexA = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.0, 0.7,
        curve: Curves.easeInOutSine,
      ),
    ),
    );
    hexB = Tween<double>(begin: 0, end: -2)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.2, 0.8,
        curve: Curves.easeInOutCubic,
      ),
    ),
    );
    hexC = Tween<double>(begin: 0, end: 3)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.3, 0.9,
        curve: Curves.easeInOutQuad,
      ),
    ),
    );
    _controller.repeat();
  }
  void _leaveAnimationBuilder() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000),
        vsync: this
    )..addListener(() {
      if(mounted) setState(() {});
    });
    hexA = Tween<double>(begin: 0, end: widget.maxLeaveWidth+widget.dimension)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.0, 0.7,
        curve: Curves.easeInOutSine,
      ),
    ),
    );
    hexB = Tween<double>(begin: 0, end: widget.maxLeaveWidth+widget.dimension)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.1, 0.75,
        curve: Curves.easeInOutCubic,
      ),
    ),
    );
    hexC = Tween<double>(begin: 0, end: widget.maxLeaveWidth+widget.dimension)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.2, 0.75,
        curve: Curves.easeInOutQuad,
      ),
    ),
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.dimension,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            alignment: Alignment.center,
            children: _buildHexagonList(constraints),
          );
        },
      ),
    );
  }

  List<Widget> _buildHexagonList(BoxConstraints constraints) {
    double heightA = constraints.maxWidth;
    double heightB = constraints.maxWidth*0.7;
    double heightC = constraints.maxWidth*0.4;
    switch(widget.animation) {
      case ProcessingAnimations.scale: return [
        _buildHexagon(dimension: heightA - hexA.value),
        _buildHexagon(dimension: heightB - hexB.value),
        _buildHexagon(dimension: heightC - hexC.value),
      ];
      case ProcessingAnimations.rotate: return [
        _buildHexagon(dimension: heightA, turn: hexA.value),
        _buildHexagon(dimension: heightB, turn: hexB.value),
        _buildHexagon(dimension: heightC, turn: hexC.value),
      ];
      case ProcessingAnimations.leave: return [
        _buildHexagon(dimension: heightA,
          turn: hexA.value/(widget.maxLeaveWidth+widget.dimension),
          offset: Offset(_leaveTranslation(hexA.value), 0),
        ),
        _buildHexagon(dimension: heightB,
          turn: hexB.value/(widget.maxLeaveWidth+widget.dimension),
          offset: Offset(_leaveTranslation(hexB.value), 0),
        ),
        _buildHexagon(dimension: heightC,
          turn: hexC.value/(widget.maxLeaveWidth+widget.dimension),
          offset: Offset(_leaveTranslation(hexC.value), 0),
        ),
      ];
      default: return  [
        _buildHexagon(dimension: heightA - hexA.value),
        _buildHexagon(dimension: heightB - hexB.value),
        _buildHexagon(dimension: heightC - hexC.value),
      ];
    }
  }

  double _leaveTranslation(double value) {
    if(value <= (widget.maxLeaveWidth+widget.dimension)/2) return value;
    return value-(widget.maxLeaveWidth+widget.dimension);
  }

  _buildHexagon({Offset offset = Offset.zero, double dimension = 100,
    double turn = 0, String hexagon = 'assets/hexagon.png'
  }) {
    return Transform.translate(
      offset: offset,
      child: Transform.rotate(
        angle: turn * pi,
        child: SizedBox.square(
          dimension: dimension,
          child: Image.asset(hexagon,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class AnimatedPushIcon extends StatefulWidget {
  const AnimatedPushIcon({Key? key}) : super(key: key);

  @override
  _AnimatedPushIconState createState() => _AnimatedPushIconState();
}
class _AnimatedPushIconState extends State<AnimatedPushIcon> with TickerProviderStateMixin {

  late AnimationController _controller;
  late final Animation<double> hexA;
  late final Animation<double> hexB;
  late final Animation<double> hexC;


  @override
  void initState() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 400),
        reverseDuration: const Duration(milliseconds: 300),
        vsync: this,
        upperBound: 0.8,
    )..addListener(() {
      if(mounted) setState(() {});
    });
    hexA = Tween<double>(begin: 0, end: 30)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.0, 0.3,
        curve: Curves.easeIn,
      ),
    ),
    );
    hexB = Tween<double>(begin: 0, end: 25)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.1, 0.6,
        curve: Curves.easeInOut,
      ),
    ),
    );
    hexC = Tween<double>(begin: 0, end: 20)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.5, 0.8,
        curve: Curves.easeOutQuart,
      ),
    ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward().then(
          (value) => _controller.reverse()
        );
      },
      onTapDown: (details) => _controller.forward(),
      onPanDown: (details) => print("hello"),
      child: SizedBox.square(
        dimension: 120,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox.square(
              dimension: 120 - hexA.value,
              child: Image.asset('assets/hexagon.png',
                fit: BoxFit.contain,
              ),
            ),
            SizedBox.square(
              dimension: 80 - hexB.value,
              child: Image.asset('assets/hexagon.png',
                fit: BoxFit.contain,
              ),
            ),
            SizedBox.square(
              dimension: 50 - hexC.value,
              child: Image.asset('assets/hexagon.png',
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}