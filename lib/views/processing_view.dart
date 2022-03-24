import 'package:alpha_roll/widgets/animated_processing.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class ProcessingView extends StatefulWidget {
  const ProcessingView({Key? key}) : super(key: key);

  @override
  _ProcessingViewState createState() => _ProcessingViewState();
}
class _ProcessingViewState extends State<ProcessingView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).cardColor,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back, color: Colors.black),
          ),
          title: const Text('Main', style: TextStyle(
              color: Colors.black
          )),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: const [
                Expanded(
                  child: Card(
                    child: SizedBox(
                      height: 200,
                      child: AnimatedProcessingIcon(
                        dimension: 100,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: SizedBox(
                      height: 200,
                      child: AnimatedProcessingIcon(
                        dimension: 100,
                        animation: ProcessingAnimations.reverseScale,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Card(
              child: SizedBox(
                height: 150,
                child: AnimatedProcessingIcon(
                  dimension: 70,
                  animation: ProcessingAnimations.leave,
                  maxLeaveWidth: MediaQuery.of(context).size.width,
                ),
              ),
            ),
            Row(
              children: const [
                Expanded(
                  child: Card(
                    child: SizedBox(
                      height: 200,
                      child: AnimatedProcessingIcon(
                        dimension: 100,
                        animation: ProcessingAnimations.rotate,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: SizedBox(
                      height: 200,
                      child: AnimatedProcessingIcon(
                        dimension: 100,
                        animation: ProcessingAnimations.fade,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Card(
              child: SizedBox(
                height: 150,
                child: AnimatedProcessingIcon(
                  dimension: 70,
                  animation: ProcessingAnimations.pingPong,
                  maxLeaveWidth: MediaQuery.of(context).size.width*2/3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}