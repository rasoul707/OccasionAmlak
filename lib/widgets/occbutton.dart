import 'package:flutter/material.dart';

import '../data/colors.dart';

class OccButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final String? type;
  final bool? disabled;

  const OccButton(
      {Key? key,
      required this.onPressed,
      required this.label,
      this.type,
      this.disabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    BoxDecoration _decour = const BoxDecoration(
      gradient: LinearGradient(
        colors: brandColorGradient,
        begin: FractionalOffset(1.0, 0.0),
        end: FractionalOffset(0.0, 0.0),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(50),
      ),
    );

    if (type is String && type == 'cancel') {
      _decour = const BoxDecoration(
        color: extraColor,
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
      );
    }

    if (disabled is bool && disabled == true) {
      _decour = const BoxDecoration(
        color: extraColor,
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
      );
    }

    return ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(50),
      ),
      child: Container(
        decoration: _decour,
        height: 50,
        width: double.infinity,
        child: TextButton(
          onPressed: onPressed,
          child: Text(
            label,
            style: const TextStyle(
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
