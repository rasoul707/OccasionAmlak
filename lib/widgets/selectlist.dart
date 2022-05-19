import 'package:flutter/material.dart';
import '../data/colors.dart';

class OccSelectList extends StatefulWidget {
  const OccSelectList({
    Key? key,
    required this.items,
    required this.controller,
    this.enabled,
    this.multiple,
  }) : super(key: key);

  final List<String> items;
  final OccSelectListController controller;
  final bool? enabled;
  final bool? multiple;

  @override
  _OccSelectListState createState() => _OccSelectListState();
}

class _OccSelectListState extends State<OccSelectList> {
  List<String> activeItems = [];

  @override
  void initState() {
    widget.controller.addListener(() {
      setState(() {
        activeItems = widget.controller.activeItems;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //

    var activeDecor = const BoxDecoration(
      gradient: LinearGradient(
        colors: brandColorGradient,
        begin: FractionalOffset(1.0, 0.0),
        end: FractionalOffset(0.0, 0.0),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(40),
      ),
    );

    var normalDecor = const BoxDecoration(
      color: textFieldBgColor,
      borderRadius: BorderRadius.all(
        Radius.circular(40),
      ),
    );

    void _onTap(String label) {
      var _active = widget.controller.active;
      var _activeItems = widget.controller.activeItems;
      if (widget.multiple is bool && widget.multiple!) {
        if (_activeItems.contains(label)) {
          _activeItems.remove(label);
        } else {
          _activeItems.add(label);
        }
        widget.controller.setValue(_activeItems);
      } else {
        if (_active == label) {
          widget.controller.setValue('');
        } else {
          widget.controller.setValue(label);
        }
      }
    }

    Widget item(String label, bool isActive) {
      return GestureDetector(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Center(
              child: Text(
                label,
                style: const TextStyle(color: textColor),
              ),
            ),
          ),
          decoration: isActive ? activeDecor : normalDecor,
        ),
        onTap: () => _onTap(label),
      );
    }

    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: (widget.enabled is bool && widget.enabled == false)
            ? const NeverScrollableScrollPhysics()
            : null,
        children:
            widget.items.map((e) => item(e, activeItems.contains(e))).toList(),
      ),
    );
  }
}

class OccSelectListController extends ChangeNotifier {
  List<String> activeItems = [];
  String active = '';

  void setValue(v) {
    if (v is List<String>) {
      activeItems = v;
    } else {
      active = v;
      activeItems = [v];
    }
    notifyListeners();
  }
}
