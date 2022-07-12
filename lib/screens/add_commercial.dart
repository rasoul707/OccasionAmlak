import 'package:flutter/material.dart';
import '../helpers/addfile.dart';
import '../helpers/file.dart';
import '../helpers/numberConvertor.dart';
import '../models/commercial.dart';
import '../data/strings.dart';
import '../widgets/selectlist.dart';

class AddCommercial extends StatefulWidget {
  const AddCommercial({
    Key? key,
    required this.controller,
    required this.disabled,
  }) : super(key: key);

  final AddCommercialController controller;
  final bool disabled;

  @override
  _AddCommercialState createState() => _AddCommercialState();
}

class _AddCommercialState extends State<AddCommercial> {
  final FocusNode areaNode = FocusNode();
  final FocusNode floorNode = FocusNode();
  final FocusNode commercialAreaNode = FocusNode();

  final OccSelectListController typeController = OccSelectListController();
  final TextEditingController areaController = TextEditingController();
  final OccSelectListController documentTypeController =
      OccSelectListController();
  final TextEditingController floorController = TextEditingController();
  final TextEditingController commercialAreaController =
      TextEditingController();

  @override
  void initState() {
    typeController.addListener(() {
      widget.controller.setType(typeController.activeItems);
    });
    areaController.addListener(() {
      widget.controller.setArea(areaController.text);
    });
    documentTypeController.addListener(() {
      widget.controller.setDocumentType(documentTypeController.active);
    });
    floorController.addListener(() {
      widget.controller.setFloor(floorController.text);
    });
    commercialAreaController.addListener(() {
      widget.controller.setCommercialArea(commercialAreaController.text);
    });
    widget.controller.checkCondition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: OccSelectList(
              items: commercialTypesItems,
              controller: typeController,
              enabled: !widget.disabled,
              multiple: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              focusNode: areaNode,
              controller: areaController,
              enabled: !widget.disabled,
              textInputAction: TextInputAction.next,
              onEditingComplete: () {
                floorNode.requestFocus();
              },
              textDirection: TextDirection.ltr,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: commercialFormLabels_area,
              ),
              inputFormatters: [NumberInputFormatter()],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: OccSelectList(
              items: documentsListTypes,
              controller: documentTypeController,
              enabled: !widget.disabled,
              multiple: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              focusNode: floorNode,
              controller: floorController,
              enabled: !widget.disabled,
              textInputAction: TextInputAction.next,
              onEditingComplete: () {
                commercialAreaNode.requestFocus();
              },
              textDirection: TextDirection.ltr,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: commercialFormLabels_floor,
              ),
              inputFormatters: [NumberInputFormatter()],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              focusNode: commercialAreaNode,
              controller: commercialAreaController,
              enabled: !widget.disabled,
              textInputAction: TextInputAction.done,
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
              },
              textDirection: TextDirection.ltr,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: commercialFormLabels_commercialArea,
              ),
              inputFormatters: [NumberInputFormatter()],
            ),
          ),
        ],
      ),
    );
  }
}

class AddCommercialController extends AddFileControllerErrorHandler {
  Commercial data = Commercial();

  @override
  void checkCondition() {
    errorHandler(
      condition: (data.type != null &&
          data.type!.isNotEmpty &&
          isOneOf(
            data.type!.elementAt(0),
            commercialTypesItems,
          )),
      error: "نوع ملک را انتخاب کنید",
    );
    errorHandler(
      condition: (isGreaterThan(data.area, 0)),
      error: "متراژ را به درستی وارد کنید",
    );
    errorHandler(
      condition: (isOneOf(data.documentType, documentsListTypes)),
      error: "نوع سند را انتخاب کنید",
    );
    errorHandler(
      condition: (data.floor is int),
      error: "طبقه ملک را وارد کنید",
    );
    errorHandler(
      condition: (isGreaterThan(data.commercialArea, 0)),
      error: "متراژ بر تجاری را به درستی وارد کنید",
    );
    notifyListeners();
  }

  void setType(v) {
    data.type = v;
    checkCondition();
  }

  void setArea(v) {
    data.area = double.tryParse(standardizeNumber(v));
    checkCondition();
  }

  void setDocumentType(v) {
    data.documentType = v;
    checkCondition();
  }

  void setFloor(v) {
    data.floor = int.tryParse(standardizeNumber(v));
    checkCondition();
  }

  void setCommercialArea(v) {
    data.commercialArea = double.tryParse(standardizeNumber(v));
    checkCondition();
  }
}
