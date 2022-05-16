import 'package:flutter/material.dart';
import '../data/colors.dart';

class OccSelectList extends StatelessWidget {
  const OccSelectList({
    Key? key,
    required this.items,
    required this.active,
    required this.setActive,
    this.enabled,
    this.multiple,
  }) : super(key: key);

  final List<String> items;
  final dynamic active;
  final void Function(dynamic) setActive;
  final bool? enabled;
  final bool? multiple;

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
      if (multiple is bool && multiple!) {
        if (active.contains(label)) {
          active.remove(label);
        } else {
          active.add(label);
        }
        setActive(active);
      } else {
        if (active == label) {
          setActive("");
        } else {
          setActive(label);
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
          // color: textFieldBgColor,
          decoration: isActive ? activeDecor : normalDecor,
        ),
        onTap: () => _onTap(label),
      );
    }

    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: (enabled is bool && enabled == false)
            ? const NeverScrollableScrollPhysics()
            : null,
        children: items.map((e) => item(e, active.contains(e))).toList(),
      ),
    );
  }
}
