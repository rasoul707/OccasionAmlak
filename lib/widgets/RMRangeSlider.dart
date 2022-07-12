import 'package:flutter/material.dart';
import '../../helpers/numberConvertor.dart';

class RMRangeSlider extends StatefulWidget {
  const RMRangeSlider(
    this.i,
    this.f,
    this.min,
    this.max,
    this.dev, {
    Key? key,
    required this.controller,
  }) : super(key: key);

  final double i;
  final double f;

  final int min;
  final int max;
  final int dev;
  final RMRangeSliderController controller;

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
    widget.controller.setValue(RangeValues(widget.i, widget.f));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 25),
          child: Text(
            "محدوده قیمت (هر متر مربع)",
          ),
        ),
        RangeSlider(
          values: _currentRangeValues,
          min: widget.min.toDouble(),
          max: widget.max.toDouble(),
          divisions: widget.dev,
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
