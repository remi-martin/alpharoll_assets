import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';

class ActionListView extends StatefulWidget {
  const ActionListView({Key? key}) : super(key: key);

  @override
  State<ActionListView> createState() => _ActionListViewState();
}

class _ActionListViewState extends State<ActionListView>{

  late final List<int> _list;

  @override
  void initState() {
    _list = List.generate(7, (index) => index);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.chevron_left_rounded, size: 40),
        ),
        title: const Text("Mes personnages"),
        actions: [
          IconButton(
            onPressed: () => debugPrint("filters"),
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const TextField(
                  textAlignVertical: TextAlignVertical(y: 0),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.black),
                    hintText: "Rechercher un personnage..."
                  ),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _list.length,
              itemBuilder: (context, index) {
                return SlidingClassCard(index: index,);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SlidingClassCard extends StatefulWidget {
  const SlidingClassCard({Key? key, this.index = 0}) : super(key: key);

  final int index;

  @override
  State<SlidingClassCard> createState() => _SlidingClassCardState();
}
class _SlidingClassCardState extends State<SlidingClassCard> with SingleTickerProviderStateMixin {
  late final SlidableController _controller;

  @override
  void initState() {
    _controller = SlidableController(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 0, top: 10, bottom: 10, left: 40),
      child: SizedBox(
        height: 120,
        child: Slidable(
          controller: _controller,
          clipBehavior: Clip.none,
          closeOnScroll: false,
          startActionPane: ActionPane(
            motion: const BehindMotion(),
            extentRatio: 0.4,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    debugPrint("duplicate ${widget.index}");
                    _controller.close(duration: const Duration(milliseconds: 200));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(right: 40),
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                    ),
                    child: const Text("Dupliquer", style: TextStyle(
                      color: Colors.white,
                    )),
                  ),
                ),
              ),
            ],
          ),
          endActionPane: ActionPane(
            extentRatio: 0.6,
            motion: const BehindMotion(),
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    debugPrint("edit ${widget.index}");
                    _controller.close(duration: const Duration(milliseconds: 200));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                    ),
                    child: const Text("Editer", style: TextStyle(
                      color: Colors.black,
                    )),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    debugPrint("delete ${widget.index}");
                    _controller.close(duration: const Duration(milliseconds: 200));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                    ),
                    child: const Text("Supprimer", style: TextStyle(
                      color: Colors.white,
                    )),
                  ),
                ),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                color: Colors.grey.shade200,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 80),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("Thor", style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500
                            )),
                            Text("Demi-Orque"),
                            Text("Guerrier"),
                          ],
                        ),
                      ),
                    ),
                    const Text("Niv. 5", style: TextStyle(
                      fontSize: 12,
                    )),
                    const Icon(Icons.chevron_right_rounded, size: 40),
                  ],
                ),
              ),
              Positioned(
                left: -40,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    width: 100,
                    height: 100,
                    padding: const EdgeInsets.all(10),
                    color: Colors.grey.shade300,
                    child: SvgPicture.asset(
                      'assets/class_logo.svg',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

