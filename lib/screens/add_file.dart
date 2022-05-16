import 'package:flutter/material.dart';
import 'file_added_result.dart';

import 'add_villa.dart';
import 'add_apartment.dart';
import 'add_land.dart';
import 'add_commercial.dart';
import 'add_hectare.dart';

class AddFile extends StatelessWidget {
  const AddFile(this.index, {Key? key}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    switch (index) {
      case 0:
        return const AddVilla();
      case 1:
        return const AddApartment();
      case 2:
        return const AddLand();
      case 3:
        return const AddCommercial();
      case 4:
        return const AddHectare();
      default:
        return const FileAddedResult(false);
    }
  }
}
