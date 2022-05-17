import 'package:flutter/material.dart';
import '../api/services.dart';
import '../models/hectare.dart';
import '../models/land.dart';
import '../widgets/occselectlist.dart';
import '../widgets/occsnackbar.dart';
import 'file_added_result.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:flip_card/flip_card.dart';

import 'package:dio/dio.dart';

import '../api/main.dart';
import '../helpers/user.dart';

import '../data/colors.dart';
import '../data/strings.dart';
import '../widgets/occButton.dart';
import '../widgets/choose_location.dart';
import '../models/villa.dart';

class AddHectare extends StatefulWidget {
  const AddHectare({Key? key}) : super(key: key);

  @override
  _AddHectareState createState() => _AddHectareState();
}

class _AddHectareState extends State<AddHectare> {
  final TextEditingController usageStatusController = TextEditingController();
  final TextEditingController tissueStatusController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController documentTypeController = TextEditingController();

  final TextEditingController priceController = TextEditingController();

  final TextEditingController cityController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController quarterController = TextEditingController();
  final TextEditingController alleyController = TextEditingController();

  final MapController locationController = MapController();

  final GlobalKey<FlipCardState> buttonFlipKey = GlobalKey<FlipCardState>();
  final GlobalKey<FlipCardState> formFlipKey = GlobalKey<FlipCardState>();

  final FocusNode usageStatusNode = FocusNode();
  final FocusNode tissueStatusNode = FocusNode();
  final FocusNode areaNode = FocusNode();
  final FocusNode documentTypeNode = FocusNode();

  final FocusNode priceNode = FocusNode();
  final FocusNode cityNode = FocusNode();
  final FocusNode districtNode = FocusNode();
  final FocusNode quarterNode = FocusNode();
  final FocusNode alleyNode = FocusNode();

  String usageStatus = "";
  String tissueStatus = "";

  bool disabled = false;
  bool loading = false;
  final int flipSpeed = 1000;

  nextSection() {
    formFlipKey.currentState!.toggleCard();
    buttonFlipKey.currentState!.toggleCard();
    setDisabled(true);
    Future.delayed(Duration(milliseconds: flipSpeed), () => setDisabled(false));
  }

  previousSection() {
    formFlipKey.currentState!.toggleCard();
    buttonFlipKey.currentState!.toggleCard();
    setDisabled(true);
    Future.delayed(Duration(milliseconds: flipSpeed), () => setDisabled(false));
  }

  setLoading(bool dsb) {
    setState(() {
      loading = dsb;
    });
  }

  setDisabled(bool dsb) {
    setState(() {
      disabled = dsb;
    });
  }

  done(bool success) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FileAddedResult(success)),
    );
  }

  submit() async {
    setLoading(true);
    setDisabled(true);
    Hectare data = Hectare(
      usageStatus: usageStatus,
      tissueStatus: tissueStatus,
      area: double.tryParse(areaController.text),
      documentType: documentTypeController.text,
      //
      //
      price: int.tryParse(priceController.text),
      city: cityController.text,
      district: districtController.text,
      quarter: quarterController.text,
      alley: alleyController.text,
      location: [
        locationController.center.latitude,
        locationController.center.longitude,
      ],
    );

        // error action
    ErrorAction _err = ErrorAction(
      response: (r) {
        OccSnackBar.error(context, r.data['code']);
      },
      connection: () {
        OccSnackBar.error(context, "دستگاه به اینترنت متصل نیست!");
      },
      cancel: () {
        OccSnackBar.error(context, "کنسل شد!");
      },
    );

    dynamic _result = await Services.addHectare(data, _err);

    // okay
    if (_result is int && _result > 0) {
      print(_result);
      return done(true);
    } else {
      done(false);
    }

    // finish
    setLoading(false);
    setDisabled(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 30, bottom: 15),
                child: Text(
                  hectareFormTitle,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ),
              Expanded(
                child: WillPopScope(
                  onWillPop: () async {
                    if (!formFlipKey.currentState!.isFront && !disabled) {
                      previousSection();
                      return false;
                    }
                    if (disabled) return false;
                    return true;
                  },
                  child: FlipCard(
                    direction: FlipDirection.HORIZONTAL,
                    flipOnTouch: false,
                    key: formFlipKey,
                    speed: flipSpeed,
                    front: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: OccSelectList(
                              items: const [
                                "مسکونی",
                                "زراعی و کشاورزی",
                                "جنگل جلگه ای",
                                "اداری و تجاری",
                              ],
                              active: usageStatus,
                              setActive: (t) {
                                setState(() {
                                  usageStatus = t;
                                });
                              },
                              enabled: !disabled,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: OccSelectList(
                              items: const [
                                "داخل بافت",
                                "الحاق به بافت",
                                "خارج بافت"
                              ],
                              active: tissueStatus,
                              setActive: (t) {
                                setState(() {
                                  tissueStatus = t;
                                });
                              },
                              enabled: !disabled,
                            ),
                          ),

                          // Padding(
                          //   padding: const EdgeInsets.symmetric(vertical: 10),
                          //   child: TextFormField(
                          //     controller: usageStatusController,
                          //     enabled: !disabled,
                          //     textInputAction: TextInputAction.next,
                          //     onEditingComplete: () {
                          //       tissueStatusNode.requestFocus();
                          //     },
                          //     focusNode: usageStatusNode,
                          //     // textAlign: TextAlign.left,
                          //     // textDirection: TextDirection.ltr,
                          //     enableSuggestions: true,
                          //     autocorrect: true,
                          //     keyboardType: TextInputType.text,

                          //     decoration: const InputDecoration(
                          //       labelText: hectareFormLabels_usageStatus,
                          //       floatingLabelBehavior:
                          //           FloatingLabelBehavior.always,
                          //       filled: true,
                          //       border: OutlineInputBorder(
                          //         borderSide: BorderSide.none,
                          //         borderRadius: BorderRadius.all(
                          //           Radius.circular(50),
                          //         ),
                          //       ),
                          //       fillColor: textFieldBgColor,
                          //       focusColor: textColor,
                          //       labelStyle: TextStyle(
                          //         color: textColor,
                          //       ),
                          //       contentPadding:
                          //           EdgeInsets.symmetric(horizontal: 25),
                          //     ),
                          //     style: const TextStyle(color: textColor),
                          //   ),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(vertical: 10),
                          //   child: TextFormField(
                          //     controller: tissueStatusController,
                          //     enabled: !disabled,
                          //     textInputAction: TextInputAction.next,
                          //     onEditingComplete: () {
                          //       areaNode.requestFocus();
                          //     },
                          //     focusNode: tissueStatusNode,
                          //     // textAlign: TextAlign.left,
                          //     // textDirection: TextDirection.ltr,
                          //     enableSuggestions: true,
                          //     autocorrect: true,
                          //     keyboardType: TextInputType.text,
                          //     decoration: const InputDecoration(
                          //       labelText: hectareFormLabels_tissueStatus,
                          //       floatingLabelBehavior:
                          //           FloatingLabelBehavior.always,
                          //       filled: true,
                          //       border: OutlineInputBorder(
                          //         borderSide: BorderSide.none,
                          //         borderRadius: BorderRadius.all(
                          //           Radius.circular(50),
                          //         ),
                          //       ),
                          //       fillColor: textFieldBgColor,
                          //       focusColor: textColor,
                          //       labelStyle: TextStyle(
                          //         color: textColor,
                          //       ),
                          //       contentPadding:
                          //           EdgeInsets.symmetric(horizontal: 25),
                          //     ),
                          //     style: const TextStyle(color: textColor),
                          //   ),
                          // ),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: TextFormField(
                              controller: areaController,
                              enabled: !disabled,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () {
                                documentTypeNode.requestFocus();
                              },
                              focusNode: areaNode,
                              textAlign: TextAlign.left,
                              textDirection: TextDirection.ltr,
                              enableSuggestions: false,
                              autocorrect: false,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: hectareFormLabels_area,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(50),
                                  ),
                                ),
                                fillColor: textFieldBgColor,
                                focusColor: textColor,
                                labelStyle: TextStyle(
                                  color: textColor,
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 25),
                              ),
                              style: const TextStyle(color: textColor),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: TextFormField(
                              controller: documentTypeController,
                              enabled: !disabled,
                              textInputAction: TextInputAction.done,
                              onEditingComplete: () {
                                nextSection();
                              },
                              focusNode: documentTypeNode,
                              // textAlign: TextAlign.left,
                              // textDirection: TextDirection.ltr,
                              enableSuggestions: true,
                              autocorrect: true,
                              keyboardType: TextInputType.text,

                              decoration: const InputDecoration(
                                labelText: hectareFormLabels_documentType,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(50),
                                  ),
                                ),
                                fillColor: textFieldBgColor,
                                focusColor: textColor,
                                labelStyle: TextStyle(
                                  color: textColor,
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 25),
                              ),
                              style: const TextStyle(color: textColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    back: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: TextFormField(
                              controller: priceController,
                              enabled: !disabled,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () {
                                cityNode.requestFocus();
                              },
                              focusNode: priceNode,
                              textAlign: TextAlign.left,
                              textDirection: TextDirection.ltr,
                              enableSuggestions: false,
                              autocorrect: false,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: hectareFormLabels_price,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(50),
                                  ),
                                ),
                                fillColor: textFieldBgColor,
                                focusColor: textColor,
                                labelStyle: TextStyle(
                                  color: textColor,
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 25),
                              ),
                              style: const TextStyle(color: textColor),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: TextFormField(
                              controller: cityController,
                              enabled: !disabled,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () {
                                districtNode.requestFocus();
                              },
                              focusNode: cityNode,
                              // textAlign: TextAlign.left,
                              // textDirection: TextDirection.ltr,
                              enableSuggestions: true,
                              autocorrect: true,
                              keyboardType: TextInputType.text,

                              decoration: const InputDecoration(
                                labelText: hectareFormLabels_city,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(50),
                                  ),
                                ),
                                fillColor: textFieldBgColor,
                                focusColor: textColor,
                                labelStyle: TextStyle(
                                  color: textColor,
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 25),
                              ),
                              style: const TextStyle(color: textColor),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: TextFormField(
                              controller: districtController,
                              enabled: !disabled,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () {
                                quarterNode.requestFocus();
                              },
                              focusNode: districtNode,
                              // textAlign: TextAlign.left,
                              // textDirection: TextDirection.ltr,
                              enableSuggestions: true,
                              autocorrect: true,
                              keyboardType: TextInputType.text,

                              decoration: const InputDecoration(
                                labelText: hectareFormLabels_district,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(50),
                                  ),
                                ),
                                fillColor: textFieldBgColor,
                                focusColor: textColor,
                                labelStyle: TextStyle(
                                  color: textColor,
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 25),
                              ),
                              style: const TextStyle(color: textColor),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: TextFormField(
                              controller: quarterController,
                              enabled: !disabled,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () {
                                alleyNode.requestFocus();
                              },
                              focusNode: quarterNode,
                              // textAlign: TextAlign.left,
                              // textDirection: TextDirection.ltr,
                              enableSuggestions: true,
                              autocorrect: true,
                              keyboardType: TextInputType.text,

                              decoration: const InputDecoration(
                                labelText: hectareFormLabels_quarter,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(50),
                                  ),
                                ),
                                fillColor: textFieldBgColor,
                                focusColor: textColor,
                                labelStyle: TextStyle(
                                  color: textColor,
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 25),
                              ),
                              style: const TextStyle(color: textColor),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: TextFormField(
                              controller: alleyController, enabled: !disabled,
                              textInputAction: TextInputAction.done,
                              onEditingComplete: () {
                                alleyNode.unfocus();
                              },
                              focusNode: alleyNode,
                              // textAlign: TextAlign.left,
                              // textDirection: TextDirection.ltr,
                              enableSuggestions: true,
                              autocorrect: true,
                              keyboardType: TextInputType.text,

                              decoration: const InputDecoration(
                                labelText: hectareFormLabels_alley,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(50),
                                  ),
                                ),
                                fillColor: textFieldBgColor,
                                focusColor: textColor,
                                labelStyle: TextStyle(
                                  color: textColor,
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 25),
                              ),
                              style: const TextStyle(color: textColor),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: ChooseLocation(
                              controller: locationController,
                              enabled: !disabled,
                            ),
                          ),
                        ],
                      ),
                    ),
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
                child: FlipCard(
                  direction: FlipDirection.VERTICAL,
                  flipOnTouch: false,
                  key: buttonFlipKey,
                  speed: flipSpeed,
                  front: OccButton(
                    onPressed: () {
                      nextSection();
                    },
                    label: addContinueButtonLabel,
                    enabled: !disabled,
                  ),
                  back: OccButton(
                    onPressed: () {
                      submit();
                    },
                    label: hectareFormTitle,
                    enabled: !disabled,
                    loading: loading,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
