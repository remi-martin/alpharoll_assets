import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CharacterPageView extends StatefulWidget {
  const CharacterPageView({Key? key}) : super(key: key);

  @override
  State<CharacterPageView> createState() => _CharacterPageViewState();
}

class _CharacterPageViewState extends State<CharacterPageView> {
  late final PageController _pageController;

  late double _pageOffset;

  final int length = 10;

  @override
  void initState() {
    _pageController = PageController(
      viewportFraction: 0.8,
      initialPage: length ~/ 2,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey.shade800,
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
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 20,
            ),
            child: Text(
              "Choisissez votre race",
              style: TextStyle(fontSize: 30),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: PageView.builder(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                itemCount: length,
                itemBuilder: (context, index) {
                  return Align(
                    alignment: Alignment.lerp(
                      Alignment.bottomCenter,
                      Alignment.topCenter,
                      _getPageOffset(index),
                    )!,
                    child: CharacterCard(
                      index: index,
                      pageOffset: _getPageOffset(index),
                      onAction: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    CharacterPage(
                              index: index,
                            ),
                            opaque: false,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CharacterCard extends StatefulWidget {
  const CharacterCard(
      {Key? key, this.onAction, this.pageOffset = 0.0, this.index = 0})
      : super(key: key);

  final Function()? onAction;
  final double pageOffset;
  final int index;

  @override
  State<CharacterCard> createState() => _CharacterCardState();
}

class _CharacterCardState extends State<CharacterCard> {
  late final Timer _timer;

  double _dragOffset = 0.0;
  double _filteredDragOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if ((_dragOffset * 1000).floor() !=
          (_filteredDragOffset * 1000).floor()) {
        setState(() {
          _filteredDragOffset += (_dragOffset - _filteredDragOffset) * 0.1;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxOffset = MediaQuery.of(context).size.height / 4;
        return GestureDetector(
          onVerticalDragStart: (details) => setState(() {
            _dragOffset = 0;
          }),
          onVerticalDragUpdate: (details) => setState(() {
            _dragOffset += details.delta.dy * 0.7;
            if (_dragOffset > maxOffset) _dragOffset = maxOffset;
            if (_dragOffset < 0) _dragOffset = 0;
          }),
          onVerticalDragEnd: (details) => setState(() {
            if (_filteredDragOffset > maxOffset * 0.8 &&
                widget.onAction != null) widget.onAction!();
            _dragOffset = 0;
          }),
          onTap: widget.onAction,
          child: Transform.translate(
            offset: Offset(0, _filteredDragOffset),
            child: Hero(
              tag: 'card ${widget.index}',
              child: Container(
                height: constraints.maxHeight * 0.9,
                width: constraints.maxWidth * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 1,
                      spreadRadius: 0.1,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 32, left: 32, right: 32, bottom: 8),
                        child:
                            LayoutBuilder(builder: (context, innerConstraints) {
                          return SizedBox(
                            width: innerConstraints.maxWidth,
                            height: innerConstraints.maxWidth * 1.1,
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
                                child: Text(
                              "Nain",
                              style: TextStyle(
                                fontSize: 30,
                              ),
                            )),
                            const Text(
                              "Le nain est petit mais robuste.\nIl aime amasser de l’or. ",
                              textAlign: TextAlign.center,
                            ),
                            Column(
                              children: const [
                                Text(
                                  "Caractéristiques",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text("+2 CON, -2 DEX"),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  color: Colors.blue.shade700),
                              child: const Text(
                                "Choisir",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CharacterPage extends StatefulWidget {
  const CharacterPage({Key? key, this.index = 0}) : super(key: key);

  final int index;

  @override
  State<CharacterPage> createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  late final Timer _timer;

  final double _dragStartDelay = 100;

  double _dragPosition = 0.0;
  double _dragOffset = 0.0;
  double _filteredDragOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if ((_dragOffset * 1000).floor() !=
          (_filteredDragOffset * 1000).floor()) {
        setState(() {
          _filteredDragOffset += (_dragOffset - _filteredDragOffset) * 0.1;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData screen = MediaQuery.of(context);
    double maxOffset = screen.size.height + _dragStartDelay;
    return GestureDetector(
      onVerticalDragStart: (details) => setState(() {
        _dragPosition = 0;
        _dragOffset = 0;
      }),
      onVerticalDragUpdate: (details) => setState(() {
        _dragPosition += details.delta.dy * 0.8;
        if (_dragPosition < _dragStartDelay) return;
        if (_dragPosition > maxOffset) {
          _dragOffset = 1;
        } else if (_dragPosition < 0) {
          _dragOffset = 0;
        } else {
          _dragOffset = _dragPosition / maxOffset;
        }

        if (_filteredDragOffset > 0.4) Navigator.of(context).pop();
      }),
      onVerticalDragEnd: (details) => setState(() {
        _dragPosition = 0;
        _dragOffset = 0;
      }),
      child: Transform.translate(
        offset: Offset(0, _filteredDragOffset * screen.size.height),
        child: Transform.scale(
          scale: 1 - (0.3 * _filteredDragOffset),
          child: Hero(
            tag: 'card ${widget.index}',
            child: Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius:
                    BorderRadius.circular(30 * _filteredDragOffset * 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 1,
                    spreadRadius: 0.1,
                    offset: const Offset(1, 1),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(
                    top: screen.padding.top * (1 - _filteredDragOffset * 2)),
                child: LayoutBuilder(builder: (context, innerConstraints) {
                  return SizedBox.square(
                    dimension: innerConstraints.maxWidth,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
