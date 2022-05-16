import 'package:flutter/material.dart';
import '../data/colors.dart';

class OccSelectList extends StatelessWidget {
  const OccSelectList({
    Key? key,
    required this.items,
    required this.active,
    required this.setActive,
    this.enabled,
  }) : super(key: key);

  final List<String> items;
  final List<String> active;
  final void Function(List<String>) setActive;
  final bool? enabled;

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
        onTap: () {
          print(label);
          final m = active;
          if (m.contains(label)) {
            m.remove(label);
          } else {
            m.add(label);
          }
          setActive(m);
        },
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
