import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TooltipListView extends StatefulWidget {
  const TooltipListView({Key? key}) : super(key: key);

  @override
  _TooltipListViewState createState() => _TooltipListViewState();
}
class _TooltipListViewState extends State<TooltipListView> {

  late final List<ItemWithTooltip> _list;
  bool _showTooltip = false;
  Widget? _tooltipMessage;
  int _index = 0;

  @override
  void initState() {
    _list = List.generate(6, (index) => ItemWithTooltip(
      key: GlobalKey<ItemWithTooltipState>(),
      tooltip: Text('I am the tooltip number $index\n buirbi bb iugrb ibruigb uibger ugniurebgi ngirengj nergnreogn rognoe rng oreng orengojreng ojrengo jrengorenonrogn erogn orengo ernge\n guirngui erhguirengu renuig nuer\n urgbiegiu\n\n giroehggh',
        softWrap: true,
      ),
    ));
    super.initState();
  }

  void _unTouch() async {
    for (var e in _list) {
      (e.key! as GlobalKey<ItemWithTooltipState>).currentState!.handleTouch(false);
    }
    if(_showTooltip) {
      await Future.delayed(const Duration(milliseconds: 300));
      setState(() {
        _tooltipMessage = null;
        _showTooltip = false;
      });
    }
  }
  void _getTouchingButton(Offset globalPosition) {
    final result = BoxHitTestResult();

    bool isTouchingButtonKey(ItemWithTooltip widget) {
      RenderBox renderBox = (widget.key! as GlobalKey).currentContext!
          .findRenderObject() as RenderBox;
      Offset offset = renderBox.globalToLocal(globalPosition);
      return renderBox.hitTest(result, position: offset);
    }

    try {
      ItemWithTooltip widget = _list.firstWhere(isTouchingButtonKey);
      for (var e in _list) {
        if(e == widget) {
          (e.key! as GlobalKey<ItemWithTooltipState>).currentState!.handleTouch(true);
          setState(() {
            _tooltipMessage = e.tooltip;
            _showTooltip = true;
            _index = _list.indexOf(e);
          });
        } else {
          (e.key! as GlobalKey<ItemWithTooltipState>).currentState!.handleTouch(false);
        }
      }
    } catch (e) {
      _unTouch();
    }
  }

  double _getTooltipPosition() {
    return _index*(MediaQuery.of(context).size.width*1/4)/(_list.length-1);
  }

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
        body: Stack(
          children: [
            Column(
              children: [
                const Expanded(
                  child: SizedBox(),
                ),
                GestureDetector(
                  onPanStart: (details) {
                    _getTouchingButton(details.globalPosition);
                  },
                  onPanUpdate: (details) {
                    _getTouchingButton(details.globalPosition);
                  },
                  onPanEnd: (panEndDetails) {
                    _unTouch();
                  },
                  onPanCancel: () {
                    _unTouch();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: _list,
                    ),
                  ),
                ),
              ],
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 100),
              bottom: kToolbarHeight+20,
              left: _getTooltipPosition(),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _showTooltip ? 1 : 0,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width*3/4,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: _tooltipMessage,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemWithTooltip extends StatefulWidget {
  const ItemWithTooltip({Key? key, this.tooltip, this.child}) : super(key: key);

  final Widget? tooltip;
  final Widget? child;

  @override
  ItemWithTooltipState createState() => ItemWithTooltipState();
}
class ItemWithTooltipState extends State<ItemWithTooltip> {
  bool _isCurrentlyTouching = false;

  void handleTouch(bool isTouching) {
    setState(() {
      _isCurrentlyTouching = isTouching;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: EdgeInsets.only(
            bottom: _isCurrentlyTouching ? 10.0 : 0),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 150),
          scale: _isCurrentlyTouching ? 1.2 : 1,
          child: CircleAvatar(
            backgroundColor: Colors.grey.shade300,
          ),
        ),
      ),
    );
  }
}

