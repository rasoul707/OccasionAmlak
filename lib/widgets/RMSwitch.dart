import 'package:flutter/material.dart';

class RMSwitch extends StatelessWidget {
  RMSwitch({
    Key? key,
    required this.value,
    required this.onChange,
    this.label,
  }) : super(key: key);

  final bool value;
  final void Function(bool) onChange;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Switch(
          value: value,
          onChanged: onChange,
        ),
        label == null ? const Text("") : Text(label!),
      ],
    );
  }
}
