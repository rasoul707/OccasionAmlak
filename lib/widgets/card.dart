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
          style: Theme.of(context).textTheme.labelMedium,
          textAlign: TextAlign.center,
        ),
        Text(
          sub!,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        )
      ];
    } else {
      content = [
        Text(
          head,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        )
      ];
    }

    return SizedBox(
      height: 85,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: content,
        ),
      ),
    );
  }
}
