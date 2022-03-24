import 'package:alpha_roll/views/action_list_view.dart';
import 'package:alpha_roll/views/animated_page_scroll_view.dart';
import 'package:alpha_roll/views/circular_bottom_navigation_view.dart';
import 'package:alpha_roll/views/processing_view.dart';
import 'package:alpha_roll/views/tooltip_list_view.dart';
import 'package:alpha_roll/widgets/long_press_dial.dart';
import 'package:alpha_roll/widgets/search_bar.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'widgets/animated_processing.dart';
import 'views/camera_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alpha Roll Assets',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainView(),
    );
  }
}

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}
class _MainViewState extends State<MainView> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).cardColor,
          title: const Text('Main', style: TextStyle(
              color: Colors.black
          )),
          actions: [
            IconButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CameraView())
              ),
              icon: const Icon(Icons.camera_alt, color: Colors.deepOrange,),
            ),
          ],
        ),
        body: LongPressDial(
          actions: [
            ActionCircle(
              color: Colors.white,
              hoveredColor: Colors.red,
              child: const Icon(Icons.edit),
              borderRadius: BorderRadius.circular(30.0)
            ),
            ActionCircle(
                color: Colors.white,
                hoveredColor: Colors.green,
                child: const Icon(Icons.share),
                borderRadius: BorderRadius.circular(30.0)
            ),
            ActionCircle(
                color: Colors.white,
                hoveredColor: Colors.blue,
                child: const Icon(Icons.download),
                borderRadius: BorderRadius.circular(30.0)
            ),
            ActionCircle(
                color: Colors.white,
                hoveredColor: Colors.orange,
                child: const Icon(Icons.drive_file_move),
                borderRadius: BorderRadius.circular(30.0)
            ),
          ],
          child: CustomRefreshIndicator(
            offsetToArmed: kToolbarHeight,
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: Theme.of(context).cardColor,
                    toolbarHeight: 0.0,
                    collapsedHeight: 0.0,
                    expandedHeight: kToolbarHeight*2+20,
                    flexibleSpace: const SliverSearchBar(),
                  ),
                  SliverList(delegate: SliverChildListDelegate([
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ProcessingView())
                      ),
                      child: const Card(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text('Processing View', textAlign: TextAlign.center,),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const TooltipListView())
                      ),
                      child: const Card(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text('Tooltip View', textAlign: TextAlign.center,),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const CircularBottomNavigationView())
                      ),
                      child: const Card(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text('Map View', textAlign: TextAlign.center,),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ActionListView())
                      ),
                      child: const Card(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text('Action List View', textAlign: TextAlign.center,),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const AnimatedPageView())
                      ),
                      child: const Card(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text('Animated Page View', textAlign: TextAlign.center,),
                        ),
                      ),
                    ),
                  ])),
                ],
              ),
            ),
            builder: (BuildContext context, Widget child, IndicatorController controller) {
              return AnimatedBuilder(
                animation: controller,
                builder: (BuildContext context, _) {
                  return Stack(
                    children: [
                      Container(
                        height: kToolbarHeight*3,
                        alignment: Alignment.topCenter,
                        color: Theme.of(context).cardColor,
                        child: SizedBox(
                          height: kToolbarHeight*2,
                          child: Center(
                            child: AnimatedProcessingIcon(
                              dimension: 60,
                              animation: ProcessingAnimations.leave,
                              maxLeaveWidth: MediaQuery.of(context).size.width,
                              isActive: controller.isLoading,
                            ),
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(0, controller.value*kToolbarHeight*2),
                        child: child,
                      ),
                    ],
                  );
                },
              );
            },
            onRefresh: () => Future.delayed(const Duration(seconds: 3)),
          ),
        ),
      ),
    );
  }
}

