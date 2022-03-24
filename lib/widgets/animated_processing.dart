import 'dart:math';

import 'package:flutter/material.dart';


enum ProcessingAnimations {
  scale,
  reverseScale,
  rotate,
  leave,
  fade,
  pingPong,
}

class AnimatedProcessingIcon extends StatefulWidget {
  const AnimatedProcessingIcon({Key? key,
    this.animation = ProcessingAnimations.scale, this.maxLeaveWidth = 100,
    this.dimension = 120, this.isActive = true,
  }) : super(key: key);

  final ProcessingAnimations animation;
  final double maxLeaveWidth;
  final double dimension;
  final bool isActive;

  @override
  _AnimatedProcessingIconState createState() => _AnimatedProcessingIconState();
}
class _AnimatedProcessingIconState extends State<AnimatedProcessingIcon>
    with TickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> hexA;
  late Animation<double> hexB;
  late Animation<double> hexC;
  final double animatedOpacity = 0.7;

  @override
  void initState() {
    _buildAnimations();
    if(!widget.isActive) {
      _controller.stop(canceled: true);
    }
    super.initState();
  }

  void _buildAnimations() {
    switch(widget.animation) {
      case ProcessingAnimations.scale: _scaleAnimationBuilder();
      break;
      case ProcessingAnimations.reverseScale: _reverseScaleAnimationBuilder();
      break;
      case ProcessingAnimations.rotate: _rotateAnimationBuilder();
      break;
      case ProcessingAnimations.leave: _leaveAnimationBuilder();
      break;
      case ProcessingAnimations.fade: _opacityAnimationBuilder();
      break;
      case ProcessingAnimations.pingPong: _pingPongAnimationBuilder();
      break;
      default: _scaleAnimationBuilder();
      break;
    }
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
    hexB = Tween<double>(begin: 0, end: widget.dimension*0.24)
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
  void _reverseScaleAnimationBuilder() {
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
        0.2, 0.9,
        curve: Curves.easeInOutQuart,
      ),
    ),
    );
    hexB = Tween<double>(begin: 0, end: widget.dimension*0.24)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.1, 0.7,
        curve: Curves.easeInOut,
      ),
    ),
    );
    hexC = Tween<double>(begin: 0, end: widget.dimension*0.2)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.0, 0.5,
        curve: Curves.easeIn,
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
  void _opacityAnimationBuilder() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000),
        vsync: this
    )..addListener(() {
      if(mounted) setState(() {});
    });
    hexA = Tween<double>(begin: 0, end: animatedOpacity*2)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.2, 0.9,
        curve: Curves.ease,
      ),
    ),
    );
    hexB = Tween<double>(begin: 0, end: animatedOpacity*2)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.1, 0.8,
        curve: Curves.ease,
      ),
    ),
    );
    hexC = Tween<double>(begin: 0, end: animatedOpacity*2)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.0, 0.7,
        curve: Curves.ease,
      ),
    ),
    );
    _controller.repeat();
  }
  void _pingPongAnimationBuilder() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000),
        vsync: this
    )..addListener(() {
      if(mounted) setState(() {});
    });
    hexA = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.5, 0.8,
        curve: Curves.easeOut,
      ),
    ),
    );
    hexB = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.2, 0.5,
        curve: Curves.easeIn,
      ),
    ),
    );
    hexC = Tween<double>(begin: -1, end: 1)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0, 1,
        curve: Curves.easeInOut,
      ),
    ),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if(!widget.isActive && _controller.isAnimating) {
      _controller.stop(canceled: true);
      _controller.animateTo(1, duration: const Duration(milliseconds: 100));
    } else if(widget.isActive && !_controller.isAnimating) {
      _buildAnimations();
    }
    return SizedBox(
      width: widget.dimension,
      child: Stack(
        alignment: Alignment.center,
        children: _buildHexagonList(),
      ),
    );
  }

  List<Widget> _buildHexagonList() {
    double heightA = widget.dimension;
    double heightB = widget.dimension*0.65;
    double heightC = widget.dimension*0.4;

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
      case ProcessingAnimations.fade: return [
        _buildHexagon(dimension: heightA, opacity: 1-animatedOpacity + (hexA.value-animatedOpacity).abs()),
        _buildHexagon(dimension: heightB, opacity: 1-animatedOpacity + (hexB.value-animatedOpacity).abs()),
        _buildHexagon(dimension: heightC, opacity: 1-animatedOpacity + (hexC.value-animatedOpacity).abs()),
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
      case ProcessingAnimations.pingPong: return [
        _buildHexagon(dimension: heightA,
          turn: _controller.status == AnimationStatus.reverse ? hexB.value : hexA.value,
        ),
        _buildHexagon(dimension: heightB,
          turn: _controller.status == AnimationStatus.reverse ? hexB.value : hexA.value,
          offset: Offset(hexC.value*(widget.maxLeaveWidth/4), 0),
        ),
        _buildHexagon(dimension: heightC,
          turn: hexC.value*2,
          offset: Offset(hexC.value*(widget.maxLeaveWidth/2), 0),
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
    double turn = 0, String hexagon = 'assets/hexagon.png', double opacity = 1
  }) {
    return Transform.translate(
      offset: offset,
      child: Transform.rotate(
        angle: turn * pi,
        child: SizedBox.square(
          dimension: dimension,
          child: Opacity(
            opacity: opacity,
            child: Image.asset(hexagon,
              fit: BoxFit.contain,
            ),
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