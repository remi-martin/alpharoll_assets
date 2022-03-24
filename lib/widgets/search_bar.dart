import 'package:flutter/material.dart';

class SliverSearchBar extends StatefulWidget {
  const SliverSearchBar({Key? key}) : super(key: key);

  @override
  _SliverSearchBarState createState() => _SliverSearchBarState();
}
class _SliverSearchBarState extends State<SliverSearchBar> {

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      background: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            height: kToolbarHeight-10.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.grey.shade200,
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: SizedBox(
                      width: 60,
                      child: InkWell(
                        onTap: () {
                          _pageController.animateToPage(
                            (_pageController.page!.toInt()+1) % 2,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        },
                        child: PageView(
                          controller: _pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            Container(
                              alignment: Alignment.center,
                              color: Colors.orange,
                              child: const Icon(Icons.text_fields, color: Colors.white),
                            ),
                            Container(
                              alignment: Alignment.center,
                              color: Colors.green,
                              child: const Icon(Icons.tag, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: kToolbarHeight,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              scrollDirection: Axis.horizontal,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Chip(
                    padding: const EdgeInsets.all(0.0),
                    label: Row(
                      children: const [
                        Text("Character "),
                        Icon(Icons.close, size: 14),
                      ],
                    ),
                    backgroundColor: Colors.amberAccent.withOpacity(0.7),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Chip(
                    label: Row(
                      children: const [
                        Text("Entity "),
                        Icon(Icons.close, size: 14),
                      ],
                    ),
                    backgroundColor: Colors.greenAccent.withOpacity(0.7),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child:
                  Chip(
                    label: Row(
                      children: const [
                        Text("Frame "),
                        Icon(Icons.close, size: 14),
                      ],
                    ),
                    backgroundColor: Colors.blueAccent.withOpacity(0.7),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Chip(
                    label: Row(
                      children: const [
                        Text("Rule "),
                        Icon(Icons.close, size: 14),
                      ],
                    ),
                    backgroundColor: Colors.pinkAccent.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}