import 'package:flutter/material.dart';

class PushButton extends StatefulWidget {
  const PushButton({Key? key, this.onTap, this.text = ''}) : super(key: key);

  final Function()? onTap;
  final String text;

  @override
  _PushButtonState createState() => _PushButtonState();
}

class _PushButtonState extends State<PushButton>
    with SingleTickerProviderStateMixin {

  bool _hold = false;

  late AnimationController _animationController;
  late Animation<double> _backgroundScaleAnimation;
  late Animation<double> _textScaleAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 100),
        reverseDuration: const Duration(milliseconds: 100),
        vsync: this
    )..addListener(() {
      if(mounted) {
        setState(() {
          if(!_hold && !_animationController.isAnimating) {
            _animationController.reverse();
          }
        });
      }
    });
    _backgroundScaleAnimation = Tween<double>(begin: 1, end: 0.93)
        .animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.0, 0.6,
        curve: Curves.easeInOut,
      ),
      reverseCurve: const Interval(
        0.0, 0.6,
        curve: Curves.easeInOut,
      ),
    ));
    _textScaleAnimation = Tween<double>(begin: 1, end: 0.85)
        .animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.0, 1.0,
        curve: Curves.easeInOut,
      ),
      reverseCurve: const Interval(
        0.0, 1.0,
        curve: Curves.easeInOut,
      ),
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() {
        print('tap');
        widget.onTap?.call();
        if(!_animationController.isAnimating) {
          _animationController.reverse();
        }
        _hold = false;
      }),
      onTapDown: (details) => setState(() {
        _hold = true;
        if(!_animationController.isAnimating) {
          _animationController.forward();
        }
      }),
      child: Transform.scale(
        scale: _backgroundScaleAnimation.value,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          decoration: BoxDecoration(
            color: Colors.deepOrange,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Transform.scale(
            scale: _textScaleAnimation.value,
            child: Text(widget.text, style: const TextStyle(
              color: Colors.white, fontSize: 20.0,
            )),
          ),
        ),
      ),
    );
  }
}
