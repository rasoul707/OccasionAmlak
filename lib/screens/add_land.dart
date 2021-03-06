import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../helpers/addfile.dart';
import '../helpers/file.dart';
import '../helpers/numberConvertor.dart';
import '../models/land.dart';
import '../data/strings.dart';
import '../widgets/selectlist.dart';

class AddLand extends StatefulWidget {
  const AddLand({
    Key? key,
    required this.controller,
    required this.disabled,
  }) : super(key: key);

  final AddLandController controller;
  final bool disabled;

  @override
  _AddLandState createState() => _AddLandState();
}

class _AddLandState extends State<AddLand> {
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
                labelText: landFormLabels_area,
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

class AddLandController extends AddFileControllerErrorHandler {
  Land data = Land();
  //
  @override
  void checkCondition() {
    errorHandler(
      condition: (isOneOf(data.usageStatus, usageStatusLandHectare)),
      error: "?????????? ???????????? ???? ???????????? ????????",
    );
    errorHandler(
      condition: (isOneOf(data.tissueStatus, tissueStatusLandHectare)),
      error: "?????????? ???????? ???? ???????????? ????????",
    );
    errorHandler(
      condition: (isGreaterThan(data.area, 0)),
      error: "?????????? ???? ???? ?????????? ???????? ????????",
    );
    errorHandler(
      condition: (isOneOf(data.documentType, documentsListTypes)),
      error: "?????? ?????? ???? ???????????? ????????",
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
