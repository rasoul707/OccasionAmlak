import 'package:flutter/material.dart';
import '../helpers/addfile.dart';
import '../helpers/file.dart';
import '../helpers/numberConvertor.dart';
import '../models/villa.dart';
import '../data/strings.dart';
import '../widgets/selectlist.dart';

const typesItems = ["فلت", "دوبلکس", "تریبلکس", "طبقات جداگانه"];

class AddVilla extends StatefulWidget {
  const AddVilla({
    Key? key,
    required this.controller,
    required this.disabled,
  }) : super(key: key);

  final AddVillaController controller;
  final bool disabled;

  @override
  _AddVillaState createState() => _AddVillaState();
}

class _AddVillaState extends State<AddVilla> {
  //

  final FocusNode landAreaNode = FocusNode();
  final FocusNode buildingAreaNode = FocusNode();
  final FocusNode constructionYearNode = FocusNode();
  final FocusNode roomsCountNode = FocusNode();
  final FocusNode mastersCountNode = FocusNode();

  final OccSelectListController typeController = OccSelectListController();
  final TextEditingController landAreaController = TextEditingController();
  final TextEditingController buildingAreaController = TextEditingController();
  final TextEditingController constructionYearController =
      TextEditingController();
  final TextEditingController roomsCountController = TextEditingController();
  final TextEditingController mastersCountController = TextEditingController();
  final OccSelectListController documentTypeController =
      OccSelectListController();
  final OccSelectListController equipmentsController =
      OccSelectListController();

  @override
  void initState() {
    typeController.addListener(() {
      widget.controller.setType(typeController.active);
    });
    landAreaController.addListener(() {
      widget.controller.setLandArea(landAreaController.text);
    });
    buildingAreaController.addListener(() {
      widget.controller.setBuildingArea(buildingAreaController.text);
    });
    constructionYearController.addListener(() {
      widget.controller.setConstructionYear(constructionYearController.text);
    });
    documentTypeController.addListener(() {
      widget.controller.setDocumentType(documentTypeController.active);
    });
    roomsCountController.addListener(() {
      widget.controller.setRoomsCount(roomsCountController.text);
    });
    mastersCountController.addListener(() {
      widget.controller.setMastersCount(mastersCountController.text);
    });
    equipmentsController.addListener(() {
      widget.controller.setEquipments(equipmentsController.activeItems);
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
              items: typesItems,
              controller: typeController,
              enabled: !widget.disabled,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              focusNode: landAreaNode,
              controller: landAreaController,
              enabled: !widget.disabled,
              textInputAction: TextInputAction.next,
              onEditingComplete: () {
                buildingAreaNode.requestFocus();
              },
              textDirection: TextDirection.ltr,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: villaFormLabels_landArea,
              ),
              inputFormatters: [NumberInputFormatter()],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              focusNode: buildingAreaNode,
              controller: buildingAreaController,
              enabled: !widget.disabled,
              textInputAction: TextInputAction.next,
              onEditingComplete: () {
                constructionYearNode.requestFocus();
              },
              textDirection: TextDirection.ltr,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: villaFormLabels_buildingArea,
              ),
              inputFormatters: [NumberInputFormatter()],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              focusNode: constructionYearNode,
              controller: constructionYearController,
              enabled: !widget.disabled,
              textInputAction: TextInputAction.next,
              onEditingComplete: () {
                roomsCountNode.requestFocus();
              },
              textDirection: TextDirection.ltr,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: villaFormLabels_constructionYear,
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
              focusNode: roomsCountNode,
              controller: roomsCountController,
              enabled: !widget.disabled,
              textInputAction: TextInputAction.next,
              onEditingComplete: () {
                mastersCountNode.requestFocus();
              },
              textDirection: TextDirection.ltr,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: villaFormLabels_roomsCount,
              ),
              inputFormatters: [NumberInputFormatter()],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              focusNode: mastersCountNode,
              controller: mastersCountController,
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
                labelText: villaFormLabels_mastersCount,
              ),
              inputFormatters: [NumberInputFormatter()],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: OccSelectList(
              items: villaEquipmentsList,
              controller: equipmentsController,
              enabled: !widget.disabled,
              multiple: true,
            ),
          ),
        ],
      ),
    );
  }
}

class AddVillaController extends AddFileControllerErrorHandler {
  Villa data = Villa();

  @override
  void checkCondition() {
    errorHandler(
      condition: (isOneOf(data.type, typesItems)),
      error: "نوع ویلا را انتخاب کنید",
    );
    errorHandler(
      condition: (isGreaterThan(data.landArea, 0)),
      error: "متراژ زمین را به درستی وارد کنید",
    );
    errorHandler(
      condition: (isGreaterThan(data.buildingArea, 0)),
      error: "متراژ بنا را به درستی وارد کنید",
    );
    errorHandler(
      condition: (isGreaterThan(data.constructionYear, 0)),
      error: "سال ساخت را به درستی وارد کنید",
    );
    errorHandler(
      condition: (isOneOf(data.documentType, documentsListTypes)),
      error: "نوع سند را انتخاب کنید",
    );
    errorHandler(
      condition: (data.roomsCount is int),
      error: "تعداد خواب را وارد کنید",
    );
    errorHandler(
      condition: (data.mastersCount is int),
      error: "تعداد مستر را وارد کنید",
    );

    notifyListeners();
  }

  void setType(v) {
    data.type = v;
    checkCondition();
  }

  void setLandArea(v) {
    data.landArea = double.tryParse(standardizeNumber(v));
    checkCondition();
  }

  void setBuildingArea(v) {
    data.buildingArea = double.tryParse(standardizeNumber(v));
    checkCondition();
  }

  void setConstructionYear(v) {
    data.constructionYear = int.tryParse(standardizeNumber(v));
    checkCondition();
  }

  void setDocumentType(v) {
    data.documentType = v;
    checkCondition();
  }

  void setRoomsCount(v) {
    data.roomsCount = int.tryParse(standardizeNumber(v));
    checkCondition();
  }

  void setMastersCount(v) {
    data.mastersCount = int.tryParse(standardizeNumber(v));
    checkCondition();
  }

  void setEquipments(v) {
    data.equipments = v;
    checkCondition();
  }
}
