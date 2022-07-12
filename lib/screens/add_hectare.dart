import 'package:flutter/material.dart';
import '../helpers/addfile.dart';
import '../helpers/file.dart';
import '../helpers/numberConvertor.dart';
import '../models/hectare.dart';
import '../data/strings.dart';
import '../widgets/selectlist.dart';

class AddHectare extends StatefulWidget {
  const AddHectare({
    Key? key,
    required this.controller,
    required this.disabled,
  }) : super(key: key);

  final AddHectareController controller;
  final bool disabled;

  @override
  _AddHectareState createState() => _AddHectareState();
}

class _AddHectareState extends State<AddHectare> {
//

  final FocusNode areaNode = FocusNode();

  final OccSelectListController usageStatusController =
      OccSelectListController();
  final OccSelectListController tissueStatusController =
      OccSelectListController();
  final TextEditingController areaController = TextEditingController();
  final OccSelectListController documentTypeController =
      OccSelectListController();

  @override
  void initState() {
    usageStatusController.addListener(() {
      widget.controller.setUsageStatus(usageStatusController.active);
    });
    tissueStatusController.addListener(() {
      widget.controller.setTissueStatus(tissueStatusController.active);
    });
    areaController.addListener(() {
      widget.controller.setArea(areaController.text);
    });
    documentTypeController.addListener(() {
      widget.controller.setDocumentType(documentTypeController.active);
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
              items: usageStatusLandHectare,
              enabled: !widget.disabled,
              controller: usageStatusController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: OccSelectList(
              items: tissueStatusLandHectare,
              enabled: !widget.disabled,
              controller: tissueStatusController,
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
                FocusScope.of(context).unfocus();
              },
              textDirection: TextDirection.ltr,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: hectareFormLabels_area,
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
        ],
      ),
    );
  }
}

class AddHectareController extends AddFileControllerErrorHandler {
  Hectare data = Hectare();
  //
  @override
  void checkCondition() {
    errorHandler(
      condition: (isOneOf(data.usageStatus, usageStatusLandHectare)),
      error: "وضعیت کاربری را انتخاب کنید",
    );
    errorHandler(
      condition: (isOneOf(data.tissueStatus, tissueStatusLandHectare)),
      error: "وضعیت بافت را انتخاب کنید",
    );
    errorHandler(
      condition: (isGreaterThan(data.area, 0)),
      error: "متراژ را به درستی وارد کنید",
    );
    errorHandler(
      condition: (isOneOf(data.documentType, documentsListTypes)),
      error: "نوع سند را انتخاب کنید",
    );
    notifyListeners();
  }

  void setUsageStatus(v) {
    data.usageStatus = v;
    checkCondition();
  }

  void setTissueStatus(v) {
    data.tissueStatus = v;
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
}
