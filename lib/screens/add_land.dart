import 'package:flutter/material.dart';
import '../helpers/addfile.dart';
import '../models/land.dart';
import '../data/strings.dart';
import '../widgets/selectlist.dart';

const usageStatusItems = [
  "مسکونی",
  "زراعی و کشاورزی",
  "جنگل جلگه ای",
  "اداری و تجاری",
];

const tissueStatusItems = ["داخل بافت", "الحاق به بافت", "خارج بافت"];

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
  final FocusNode documentTypeNode = FocusNode();

  final OccSelectListController usageStatusController =
      OccSelectListController();
  final OccSelectListController tissueStatusController =
      OccSelectListController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController documentTypeController = TextEditingController();

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
      widget.controller.setDocumentType(documentTypeController.text);
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
              items: usageStatusItems,
              enabled: !widget.disabled,
              controller: usageStatusController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: OccSelectList(
              items: tissueStatusItems,
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
                documentTypeNode.requestFocus();
              },
              textDirection: TextDirection.ltr,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: landFormLabels_area,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              focusNode: documentTypeNode,
              controller: documentTypeController,
              enabled: !widget.disabled,
              textInputAction: TextInputAction.done,
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
              },
              enableSuggestions: true,
              autocorrect: true,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: landFormLabels_documentType,
              ),
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
      condition: (isOneOf(data.usageStatus, usageStatusItems)),
      error: "وضعیت کاربری را انتخاب کنید",
    );
    errorHandler(
      condition: (isOneOf(data.tissueStatus, tissueStatusItems)),
      error: "وضعیت بافت را انتخاب کنید",
    );
    errorHandler(
      condition: (isGreaterThan(data.area, 0)),
      error: "متراژ را به درستی وارد کنید",
    );
    errorHandler(
      condition: (isRealString(data.documentType)),
      error: "نوع سند را وارد کنید",
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
    data.area = double.tryParse(v);
    checkCondition();
  }

  void setDocumentType(v) {
    data.documentType = v;
    checkCondition();
  }
}
