import 'package:flutter/material.dart';

class RMCheckbox extends StatefulWidget {
  RMCheckbox({
    Key? key,
    required this.label,
    required this.controller,
    this.enabled,
  }) : super(key: key);

  final CheckboxController controller;
  final bool? enabled;
  String label;

  @override
  _RMCheckboxState createState() => _RMCheckboxState();
}

class _RMCheckboxState extends State<RMCheckbox> {
  bool value = false;

  @override
  void initState() {
    widget.controller.addListener(() {
      setState(() {
        value = widget.controller.value;
      });
    });
    super.initState();
  }

  _onChange(v) {
    if (widget.enabled != null && !widget.enabled!) return;
    widget.controller.setValue(v);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          onChanged: _onChange,
          value: value,
        ),
        GestureDetector(
          child: Text(widget.label),
          onTap: () {
            _onChange(!value);
          },
        ),
      ],
    );
  }
}

class CheckboxController extends ChangeNotifier {
  bool value = false;

  void setValue(v) {
    value = v;
    notifyListeners();
  }
}
