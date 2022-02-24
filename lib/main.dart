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
            AnimatedProcessingIcon(),
          ],
        ),
      ),
    );
  }
}



class AnimatedProcessingIcon extends StatefulWidget {
  const AnimatedProcessingIcon({Key? key}) : super(key: key);

  @override
  _AnimatedProcessingIconState createState() => _AnimatedProcessingIconState();
}
class _AnimatedProcessingIconState extends State<AnimatedProcessingIcon> with TickerProviderStateMixin {

  late AnimationController _controller;
  late final Animation<double> hexA;
  late final Animation<double> hexB;
  late final Animation<double> hexC;

  @override
  void initState() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1000),
        reverseDuration: const Duration(milliseconds: 300),
        vsync: this
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
        0.4, 1,
        curve: Curves.easeOutQuart,
      ),
    ),
    );
    _controller.repeat(
      reverse: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
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
    );
  }
}
