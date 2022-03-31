import 'package:flutter/material.dart';

class CharacterPageView extends StatefulWidget {
  const CharacterPageView({Key? key}) : super(key: key);

  @override
  State<CharacterPageView> createState() => _CharacterPageViewState();
}
class _CharacterPageViewState extends State<CharacterPageView> with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  late double _pageOffset;
  bool _details = false;

  final int _length = 10;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _pageController = PageController(
      viewportFraction: 0.8,
      initialPage: _length ~/ 2,
    )..addListener(() {
      if (mounted && _pageController.page != null) {
        setState(() {
          _pageOffset = _pageController.page!;
        });
      }
    });
    _pageOffset = _pageController.initialPage.toDouble();
    super.initState();
  }

  @override
  dispose() {
    _pageController.dispose();
    super.dispose();
  }

  double _getPageOffset(int index) {
    if (_pageOffset.floor() == index) {
      return 1 - (_pageOffset - _pageOffset.floor()).abs();
    } else if (_pageOffset.ceil() == index) {
      return (_pageOffset - _pageOffset.floor()).abs();
    }
    return 0;
  }
  double _getPageTransform(int index) {
    if (_pageOffset.floor() == index) {
      return -50 * (_pageOffset - _pageOffset.floor()).abs();
    } else if (_pageOffset.ceil() == index) {
      return 50 * (1 - (_pageOffset - _pageOffset.floor()).abs());
    }
    if(index < _pageOffset) return 50;
    return -50;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey, Colors.white],
          stops: [0, 0.8],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(Icons.arrow_back_ios, size: 20),
              Text(
                "Annuler",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: _details ? 0 : 1,
                    child: const Text("Choisissez votre race",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, animation) {
                        _pageController = PageController(
                          initialPage: _pageOffset.round(),
                          viewportFraction: 0.8 + _animation.value * 0.2,
                        )..addListener(() {
                          if (mounted && _pageController.page != null
                              && _animationController.isDismissed) {
                            WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
                              setState(() {
                                _pageOffset = _pageController.page!;
                              });
                            });
                          }
                        });
                        return PageView.builder(
                          controller: _pageController,
                          physics: _details
                              ? const NeverScrollableScrollPhysics()
                              : const BouncingScrollPhysics(),
                          itemCount: _length,
                          itemBuilder: (context, index) {
                            return Align(
                              alignment: Alignment.bottomCenter,
                              child: CharacterCard(
                                controller: _animationController,
                                animation: _animation,
                                pageOffset: _getPageOffset(index),
                                onAction: () => setState(() {
                                  _details = !_details;
                                  if (_details) {
                                    _animationController.forward();
                                  } else {
                                    _animationController.reverse();
                                  }
                                }),
                              ),
                            );
                          },
                        );
                      }
                    ),
                  ),
                ),
                GestureDetector(
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, animation) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 32,
                        ),
                        padding: const EdgeInsets.all(16),
                        width: MediaQuery.of(context).size.width*0.7
                            + MediaQuery.of(context).size.width * 0.1 * _animation.value,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue.shade900,
                        ),
                        child: const Text(
                          "Choisir",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CharacterCard extends StatefulWidget {
  const CharacterCard({Key? key, this.onAction, this.pageOffset = 0.0, this.index = 0,
    required this.controller, required this.animation,
  }) : super(key: key);

  final Function()? onAction;
  final double pageOffset;
  final int index;
  final AnimationController controller;
  final Animation<double> animation;

  @override
  State<CharacterCard> createState() => _CharacterCardState();
}
class _CharacterCardState extends State<CharacterCard> with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double cardHeight = constraints.maxHeight * 0.9
            + constraints.maxHeight * 0.1
                * (widget.pageOffset - widget.animation.value);
        double cardWidth = constraints.maxWidth * 0.9
            + constraints.maxWidth * 0.1 * widget.animation.value;

        double contentHeight = constraints.maxHeight * 0.9
            + constraints.maxHeight * 0.1 * widget.animation.value;
        return GestureDetector(
          onTap: widget.onAction,
          child: Container(
            height: cardHeight,
            width: cardWidth,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              color: Colors.white,
            ),
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: contentHeight,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 32,
                      left: 32,
                      right: 32,
                      bottom: 8,
                    ),
                    child: LayoutBuilder(builder: (context, imageConstraints) {
                      double imageHeight = imageConstraints.maxWidth * 1.1 * (1-widget.animation.value);
                      double imageWidth = imageConstraints.maxWidth * (1-widget.animation.value);
                      return SizedBox(
                        width: imageWidth,
                        height: imageHeight,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      );
                    }),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Center(
                          child: Text("Nain",
                            style: TextStyle(
                              fontSize: 30,
                            ),
                          ),
                        ),
                        const Text("Le nain est petit mais robuste.\nIl aime amasser de l’or. ",
                          textAlign: TextAlign.center,
                        ),
                        Column(
                          children: const [
                            Text("Caractéristiques",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text("+2 CON, -2 DEX"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: constraints.maxHeight * 0.5 * widget.animation.value,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
