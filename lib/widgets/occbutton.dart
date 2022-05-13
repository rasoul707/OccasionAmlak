import 'package:flutter/material.dart';

import '../data/colors.dart';

class OccButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const OccButton({
    Key? key,
    required this.onPressed,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(50),
      ),
      child: Container(
        decoration: const BoxDecoration(
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
        ),
        height: 50,
        width: double.infinity,
        child: TextButton(
          onPressed: onPressed,
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
