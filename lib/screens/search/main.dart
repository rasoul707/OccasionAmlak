import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../widgets/RMCheckbox.dart';
import '../../widgets/RMRangeSlider.dart';
import '../../widgets/RMAppBar.dart';

import '../../widgets/button.dart';
import '../../widgets/selectlist.dart';
import 'list.dart';

class SearchContent extends StatefulWidget {
  const SearchContent({Key? key}) : super(key: key);

  @override
  _SearchContentState createState() => _SearchContentState();
}

class _SearchContentState extends State<SearchContent> {
  //
  final OccSelectListController fileTypeController = OccSelectListController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController buildingAreaController = TextEditingController();
  final RMRangeSliderController priceController = RMRangeSliderController();
  final CheckboxController canBarterController = CheckboxController();

  @override
  void initState() {
    super.initState();
  }

  int maxPrice = 100000000;

  String typeConvert2Slug(String? name) {
    if (name == 'ویلا') {
      return "villa";
    } else if (name == 'آپارتمان') {
      return "apartment";
    } else if (name == 'اداری تجاری') {
      return "commercial";
    } else if (name == 'زمین') {
      return "land";
    } else if (name == 'هکتاری') {
      return "hectare";
    } else {
      return "";
    }
  }

  searchFiles() {
    String? district = districtController.text;
    double? area = double.tryParse(areaController.text);
    double? buildingArea = double.tryParse(buildingAreaController.text);
    List<String> type =
        fileTypeController.activeItems.map((e) => typeConvert2Slug(e)).toList();
    List<String> price = priceController.value;

    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        child: SearchList(
          district: district,
          area: area,
          buildingArea: buildingArea,
          type: type,
          price: price,
        ),
      ),
    ).then((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RMAppBar(
        title: "جستجوی فایل",
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: ListView(
                children: [
                  RMRangeSlider(
                    20000000,
                    maxPrice - 20000000.toDouble(),
                    0,
                    maxPrice,
                    40,
                    controller: priceController,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, bottom: 10),
                    child: RMCheckbox(
                      label: 'قابل تهاتر',
                      controller: canBarterController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: OccSelectList(
                      items: const [
                        "ویلا",
                        "آپارتمان",
                        "زمین",
                        "اداری تجاری",
                        "هکتاری",
                      ],
                      controller: fileTypeController,
                      multiple: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: districtController,
                      textInputAction: TextInputAction.next,
                      textDirection: TextDirection.rtl,
                      enableSuggestions: true,
                      autocorrect: true,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "منطقه",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: areaController,
                      textInputAction: TextInputAction.next,
                      textDirection: TextDirection.ltr,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "متراژ زمین",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: buildingAreaController,
                      textInputAction: TextInputAction.done,
                      onEditingComplete: () {
                        searchFiles();
                      },
                      textDirection: TextDirection.ltr,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "متراژ بنا",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 50,
              right: 50,
              bottom: 30,
              top: 15,
            ),
            child: OccButton(
              onPressed: searchFiles,
              label: "جستجو",
            ),
          ),
        ],
      ),
    );
  }
}
