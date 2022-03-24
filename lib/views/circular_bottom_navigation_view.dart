import 'package:flutter/material.dart';


class CircularBottomNavigationView extends StatefulWidget {
  const CircularBottomNavigationView({Key? key}) : super(key: key);

  @override
  _CircularBottomNavigationViewState createState() => _CircularBottomNavigationViewState();
}
class _CircularBottomNavigationViewState extends State<CircularBottomNavigationView> {

  Offset position = const Offset(10, 10);
  Offset delta = Offset.zero;
  Offset startDelta = Offset.zero;
  bool longPressed = false;
  final TransformationController _controller = TransformationController();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text('Interactive View', style: TextStyle(color: Colors.black)),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return InteractiveViewer(
            transformationController: _controller,
            constrained: false,
            scaleEnabled: false,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                minWidth: constraints.maxWidth,
              ),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Stack(
                  children: [
                    Image.network('https://pbs.twimg.com/media/DzJYVhFXcAAP8ng.jpg',
                      scale: 1,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, widget, event) {
                        if (event == null) return widget;
                        return const Center(
                          child: SizedBox.expand(),
                        );
                      },
                    ),
                    Positioned(
                      left: position.dx + delta.dx,
                      top: position.dy + delta.dy,
                      child: GestureDetector(
                        onLongPressStart: (details) => setState(() {
                          startDelta = details.localPosition;
                          longPressed = true;
                        }),
                        onLongPressEnd: (details) => setState(() {
                          longPressed = false;
                          startDelta = Offset.zero;
                          position = position + delta;
                          delta = Offset.zero;
                        }),
                        onLongPressMoveUpdate: (details) => setState(() {
                          delta = details.localPosition - startDelta;
                          if(details.globalPosition.dx < 50
                              && _controller.value.row0.length > 10) {
                            _controller.value.translate(10.0);
                          } else if(details.globalPosition.dx > constraints.maxWidth - 50) {
                            _controller.value.translate(-10.0);
                          }
                        }),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 50),
                          height: 60,
                          width: 60,
                          alignment: Alignment.center,
                          child: CircleAvatar(radius: longPressed ? 25 : 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

