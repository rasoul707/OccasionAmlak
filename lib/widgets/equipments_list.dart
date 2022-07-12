import 'package:flutter/material.dart';

Widget equipmentsList(context, List<String> items) {
  return Wrap(
    spacing: 15,
    runSpacing: 15,
    children: items.map((e) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
          ),
          const Padding(
            padding: EdgeInsets.only(right: 5),
          ),
          Text(e),
        ],
      );
    }).toList(),
  );
}
