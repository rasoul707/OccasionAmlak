import 'package:flutter/material.dart';
import '../../helpers/numberConvertor.dart';

class RMRangeSlider extends StatefulWidget {
  const RMRangeSlider({
    Key? key,
    required this.start,
    required this.end,
    required this.min,
    required this.max,
    required this.step,
    required this.controller,
    this.label,
    this.show = true,
  }) : super(key: key);

  final double start;
  final double end;

  final int min;
  final int max;
  final int step;
  final RMRangeSliderController controller;
  final String? label;
  final bool show;

  @override
  State<RMRangeSlider> createState() => _RMRangeSliderState();
}

class _RMRangeSliderState extends State<RMRangeSlider> {
  RangeValues _currentRangeValues = const RangeValues(0, 1);

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      setState(() {
        _currentRangeValues = widget.controller.range;
      });
    });
    widget.controller.setValue(RangeValues(widget.start, widget.end));
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.show) return Container();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.label != null
            ? Padding(
                padding: const EdgeInsets.only(right: 25),
                child: Text(
                  widget.label!,
                ),
              )
            : Container(),
        RangeSlider(
          values: _currentRangeValues,
          min: widget.min.toDouble(),
          max: widget.max.toDouble(),
          divisions: (widget.max - widget.min) ~/ widget.step,
          labels: RangeLabels(
            priceFormat(_currentRangeValues.start.round()),
            priceFormat(_currentRangeValues.end.round()),
          ),
          onChanged: (RangeValues values) {
            widget.controller.setValue(values);
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Text(priceFormat(widget.min)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(priceFormat(widget.max)),
            ),
          ],
        ),
      ],
    );
  }
}

class RMRangeSliderController extends ChangeNotifier {
  RangeValues range = const RangeValues(0, 1);
  List<String> value = [];

  void setValue(RangeValues v) {
    range = v;
    value = [v.start.toString(), v.end.toString()];
    notifyListeners();
  }
}
