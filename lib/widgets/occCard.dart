import 'package:flutter/material.dart';
import '../data/colors.dart';

class OccCard extends StatelessWidget {
  final String head;
  final String? sub;

  const OccCard({
    Key? key,
    required this.head,
    this.sub,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //
    List<Text> content = [];

    if (sub is String) {
      content = [
        Text(
          head,
          style: const TextStyle(
            color: textColor,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          sub!,
          style: const TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        )
      ];
    } else {
      content = [
        Text(
          head,
          style: const TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        )
      ];
    }

    return SizedBox(
      height: 85,
      child: Card(
        // margin: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: content,
        ),
        color: textFieldBgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }
}
