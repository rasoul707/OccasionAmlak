import 'package:flutter/material.dart';
import '../helpers/addfile.dart';
import '../helpers/file.dart';
import '../helpers/numberConvertor.dart';
import '../models/apartment.dart';
import '../data/strings.dart';
import '../widgets/selectlist.dart';

class AddApartment extends StatefulWidget {
  const AddApartment({
    Key? key,
    required this.controller,
    required this.disabled,
  }) : super(key: key);

  final AddApartmentController controller;
  final bool disabled;

  @override
  _AddApartmentState createState() => _AddApartmentState();
}

class _AddApartmentState extends State<AddApartment> {
  //

  final FocusNode floorsCountNode = FocusNode();
  final FocusNode unitsCountNode = FocusNode();
  final FocusNode floorNode = FocusNode();
  final FocusNode areaNode = FocusNode();
  final FocusNode roomsCountNode = FocusNode();
  final FocusNode mastersCountNode = FocusNode();

  final TextEditingController floorsCountController = TextEditingController();
  final TextEditingController unitsCountController = TextEditingController();
  final TextEditingController floorController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final OccSelectListController documentTypeController =
      OccSelectListController();
  final TextEditingController roomsCountController = TextEditingController();
  final TextEditingController mastersCountController = TextEditingController();
  final OccSelectListController equipmentsController =
      OccSelectListController();

  @override
  void initState() {
    floorsCountController.addListener(() {
      widget.controller.setFloorsCount(floorsCountController.text);
    });
    unitsCountController.addListener(() {
      widget.controller.setUnitsCount(unitsCountController.text);
    });
    floorController.addListener(() {
      widget.controller.setFloor(floorController.text);
    });
    areaController.addListener(() {
      widget.controller.setArea(areaController.text);
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
            child: TextFormField(
              focusNode: floorsCountNode,
              controller: floorsCountController,
              enabled: !widget.disabled,
              textInputAction: TextInputAction.next,
              onEditingComplete: () {
                unitsCountNode.requestFocus();
              },
              textDirection: TextDirection.ltr,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: apartmentFormLabels_floorsCount,
              ),
              inputFormatters: [NumberInputFormatter()],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              focusNode: unitsCountNode,
              controller: unitsCountController,
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
                labelText: apartmentFormLabels_unitsCount,
              ),
              inputFormatters: [NumberInputFormatter()],
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
                areaNode.requestFocus();
              },
              textDirection: TextDirection.ltr,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: apartmentFormLabels_floor,
              ),
              inputFormatters: [NumberInputFormatter()],
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
                roomsCountNode.requestFocus();
              },
              textDirection: TextDirection.ltr,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: apartmentFormLabels_area,
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
                labelText: apartmentFormLabels_roomsCount,
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
                labelText: apartmentFormLabels_mastersCount,
              ),
              inputFormatters: [NumberInputFormatter()],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: OccSelectList(
              items: apartmentEquipmentsList,
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

class AddApartmentController extends AddFileControllerErrorHandler {
  Apartment data = Apartment();

  @override
  void checkCondition() {
    errorHandler(
      condition: (isGreaterThan(data.floorsCount, 0)),
      error: "تعداد طبقات را به درستی وارد کنید",
    );
    errorHandler(
      condition: (isGreaterThan(data.unitsCount, 0)),
      error: "تعداد واحدها را به درستی وارد کنید",
    );
    errorHandler(
      condition: (isGreaterThan(data.floor, 0)),
      error: "طبقه را به درستی وارد کنید",
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
      condition: (data.roomsCount is int),
      error: "تعداد خواب را وارد کنید",
    );
    errorHandler(
      condition: (data.mastersCount is int),
      error: "تعداد مستر را وارد کنید",
    );

    notifyListeners();
  }

  void setFloorsCount(v) {
    data.floorsCount = int.tryParse(standardizeNumber(v));
    checkCondition();
  }

  void setUnitsCount(v) {
    data.unitsCount = int.tryParse(standardizeNumber(v));
    checkCondition();
  }

  void setFloor(v) {
    data.floor = int.tryParse(standardizeNumber(v));
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
