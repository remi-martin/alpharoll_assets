import 'dart:math';

import 'package:flutter/material.dart';


class LongPressDial extends StatefulWidget {
  const LongPressDial({Key? key, this.child, this.actions = const [],
    this.actionsDistance = 100, this.actionRadius = 30, this.onHover,
    this.onAction}) : super(key: key);

  final Widget? child;
  final List<ActionCircle> actions;
  final double actionsDistance;
  final double actionRadius;
  final Function(int?)? onHover;
  final Function(int)? onAction;

  @override
  _LongPressDialState createState() => _LongPressDialState();
}
class _LongPressDialState extends State<LongPressDial> with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  bool _isLongPressed = false;
  Offset _longPressOffset = Offset.zero;
  int? _selectedIndex;
  Offset _horizontalOffset = Offset.zero;

  @override
  initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    super.initState();
  }

  double _positionAngle() {

    return _horizontalOffset.direction;
  }

  List<Widget> _actions() {
    if(widget.actions.isEmpty) return [];
    List<Widget> actions = [
      _centerCircle(),
    ];
    for (var action in widget.actions) {
      int actionIndex = widget.actions.indexOf(action);
      double angle = (actionIndex+1)*pi/(widget.actions.length+1) - pi/2
          + _positionAngle();
      Offset actionOffset = Offset(
        widget.actionsDistance * cos(angle),
        -widget.actionsDistance * sin(angle),
      );
      if(_selectedIndex == actionIndex) {
        actionOffset += Offset(10.0 * cos(angle), -10.0 * sin(angle));
      }
      actions.add(LongPressDialAction(
        animationController: _controller,
        radius: action.radius,
        angle: angle,
        selected: actionIndex == _selectedIndex,
        borderRadius: action.borderRadius,
        color: action.color,
        hoveredColor: action.hoveredColor,
        onTap: action.onTap,
        offset: actionOffset,
        gestureOffset: _longPressOffset,
        child: action.child,
      ));
    }
    return actions;
  }

  int? _onHoverAction(Offset gestureOffset) {
    int? index;
    for (var action in widget.actions) {
      int actionIndex = widget.actions.indexOf(action);
      double angle = (actionIndex+1)*pi/(widget.actions.length+1) - pi/2
          + _positionAngle();
      Offset actionOffset = Offset(
        widget.actionsDistance * cos(angle),
        -widget.actionsDistance * sin(angle),
      );
      if(_actionDragCollision(actionOffset, gestureOffset)) {
        index = actionIndex;
      }
    }
    setState(() {
      _selectedIndex = index;
    });
    return index;
  }
  bool _actionDragCollision(Offset itemOffset, Offset gestureOffset) {
    if(gestureOffset >= itemOffset - Offset(widget.actionRadius, widget.actionRadius)
        && gestureOffset <= itemOffset + Offset(widget.actionRadius, widget.actionRadius)) {
      return true;
    }
    return false;
  }

  void _onLongPressStart(details) {
    _controller.forward();
    if(!_isLongPressed) {
      setState(() {
        _isLongPressed = true;
        _longPressOffset = details.localPosition;
        double dx = (details.globalPosition.dx*2/MediaQuery.of(context).size.width)-1;
        double dy = (details.globalPosition.dy*2/MediaQuery.of(context).size.height)-1/2;
        if(dy >= 0) {
          dy = dy/2;
        } else {
          dy = dy*2;
        }
        _horizontalOffset = Offset(
          -dx,
          dy,
        );
      });
    }
  }
  void _onLongPressMoveUpdate(details) {
    if(widget.onHover != null) {
      widget.onHover!(_onHoverAction(details.localOffsetFromOrigin));
    } else {
      _onHoverAction(details.localOffsetFromOrigin);
    }
  }
  void _onLongPressEnd(details) {
    setState(() {
      if(widget.onHover != null) widget.onHover!(null);
      if(widget.onAction != null && _selectedIndex != null) {
        widget.onAction!(_selectedIndex!);
      }
      _selectedIndex = null;
      _controller.reverse().then((value) => setState(() {
        _isLongPressed = false;
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: _onLongPressStart,
      onLongPressMoveUpdate: _onLongPressMoveUpdate,
      onLongPressEnd: _onLongPressEnd,
      child: SizedBox.expand(
        child: Stack(
          children: [
            widget.child ?? const SizedBox.expand(),
            _isLongPressed ? Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black45,
            ) : const SizedBox(),
            _isLongPressed ? Stack(
              children: _actions(),
            ) : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _centerCircle() {
    return Transform.translate(
      offset: _longPressOffset - const Offset(30, 30),
      child: Container(
        width: 60.0,
        height: 60.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(color: Colors.grey.shade700, width: 3.0),
        ),
      ),
    );
  }
}

class LongPressDialAction extends StatefulWidget {
  const LongPressDialAction({Key? key, this.radius = 30, this.borderRadius,
    this.color, this.child, this.hoveredColor, this.onTap,
    this.selected = false, this.offset = const Offset(0, 0),
    this.gestureOffset = const Offset(0, 0), this.animationController,
    this.angle = 0}) : super(key: key);

  final bool selected;
  final double radius;
  final double angle;
  final BorderRadius? borderRadius;
  final Color? color;
  final Color? hoveredColor;
  final Widget? child;
  final Offset offset;
  final Offset gestureOffset;
  final AnimationController? animationController;
  final Function()? onTap;

  @override
  _LongPressDialActionState createState() => _LongPressDialActionState();
}
class _LongPressDialActionState extends State<LongPressDialAction> with SingleTickerProviderStateMixin {

  late AnimationController _hoverController;
  late Animation<double> _sizeAnimation;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _offsetAnimation = Tween<Offset>(begin: Offset.zero,
        end: Offset(10.0 * cos(widget.angle), -10.0 * sin(widget.angle))).animate(
      CurvedAnimation(parent: _hoverController,
          curve: Curves.ease, reverseCurve: Curves.ease),
    )..addListener(() {
      if(mounted) setState(() {});
    });
    _scaleAnimation = Tween<double>(begin: 0, end: 0.2).animate(
      CurvedAnimation(parent: _hoverController,
          curve: Curves.ease, reverseCurve: Curves.ease),
    )..addListener(() {
      if(mounted) setState(() {});
    });
    if(widget.animationController != null) {
      _sizeAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: widget.animationController!, curve: Curves.linear, reverseCurve: Curves.linear),
      )..addListener(() {
        if(mounted) setState(() {});
      });
    }
    super.initState();
  }

  Color? _getHoveredColor() {
    return widget.selected ? widget.hoveredColor : widget.color;
  }
  double _getSize() {
    return widget.radius*2;
  }
  double _getScale() {
    double scale = 1;
    if(widget.animationController != null) {
      scale = _sizeAnimation.value;
    }
    scale += _scaleAnimation.value;
    return scale;
  }

  @override
  Widget build(BuildContext context) {
    if(widget.selected) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
    return Transform.translate(
      offset: widget.gestureOffset - Offset(widget.radius, widget.radius)
          + widget.offset + _offsetAnimation.value,
      child: Transform.scale(
        scale: _getScale(),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: _getSize(),
            height: _getSize(),
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius,
              color: _getHoveredColor(),
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class ActionCircle {
  const ActionCircle({Key? key, this.radius = 25, this.borderRadius,
    this.color, this.child, this.hoveredColor, this.onTap});

  final double radius;
  final BorderRadius? borderRadius;
  final Color? color;
  final Color? hoveredColor;
  final Widget? child;
  final Function()? onTap;
}