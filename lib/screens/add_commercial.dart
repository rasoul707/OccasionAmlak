import 'package:flutter/material.dart';
import '../models/commercial.dart';
import '../widgets/occselectlist.dart';
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

class AddCommercial extends StatefulWidget {
  const AddCommercial({Key? key}) : super(key: key);

  @override
  _AddCommercialState createState() => _AddCommercialState();
}

class _AddCommercialState extends State<AddCommercial> {
  final TextEditingController typeController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController documentTypeController = TextEditingController();
  final TextEditingController floorController = TextEditingController();
  final TextEditingController commercialAreaController =
      TextEditingController();

  final TextEditingController priceController = TextEditingController();

  final TextEditingController cityController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController quarterController = TextEditingController();
  final TextEditingController alleyController = TextEditingController();

  final MapController locationController = MapController();

  final GlobalKey<FlipCardState> buttonFlipKey = GlobalKey<FlipCardState>();
  final GlobalKey<FlipCardState> formFlipKey = GlobalKey<FlipCardState>();

  final FocusNode typeNode = FocusNode();
  final FocusNode areaNode = FocusNode();
  final FocusNode documentTypeNode = FocusNode();
  final FocusNode floorNode = FocusNode();
  final FocusNode commercialAreaNode = FocusNode();

  final FocusNode priceNode = FocusNode();
  final FocusNode cityNode = FocusNode();
  final FocusNode districtNode = FocusNode();
  final FocusNode quarterNode = FocusNode();
  final FocusNode alleyNode = FocusNode();

  String type = "";

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
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => FileAddedResult(success)),
      (Route<dynamic> route) => route.isFirst,
    );
  }

  submit() async {
    setLoading(true);
    setDisabled(true);
    Commercial data = Commercial(
      type: type,
      area: double.tryParse(areaController.text),
      documentType: documentTypeController.text,
      floor: int.tryParse(floorController.text),
      commercialArea: double.tryParse(commercialAreaController.text),
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

    String? token = await getAuthToken();
    dynamic res = await API(Dio(BaseOptions(headers: {"Authorization": token})))
        .addCommercial(data)
        .catchError((Object obj) {
      if (obj.runtimeType == DioError) {
        final res = (obj as DioError).response;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            res!.data['code'],
            style: const TextStyle(fontFamily: 'Vazir', color: whiteTextColor),
          ),
          backgroundColor: errorColor,
          duration: const Duration(seconds: 1),
        ));
      }
      return false;
    });

    setLoading(false);
    setDisabled(false);
    if (res == false) return done(false);
    print(res);
    return done(true);
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
                  commercialFormTitle,
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
                                "اداری",
                                "تجاری",
                                "مغازه",
                                "صنعتی",
                                "دامداری و کشاورزی"
                              ],
                              active: type,
                              setActive: (t) {
                                setState(() {
                                  type = t;
                                });
                              },
                              enabled: !disabled,
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(vertical: 10),
                          //   child: TextFormField(
                          //     controller: typeController,
                          //     enabled: !disabled,
                          //     textInputAction: TextInputAction.next,
                          //     onEditingComplete: () {
                          //       FocusScope.of(context).requestFocus(areaNode);
                          //     },
                          //     focusNode: typeNode,
                          //     // textAlign: TextAlign.left,
                          //     // textDirection: TextDirection.ltr,
                          //     enableSuggestions: true,
                          //     autocorrect: true,
                          //     keyboardType: TextInputType.text,

                          //     decoration: const InputDecoration(
                          //       labelText: commercialFormLabels_type,
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
                                FocusScope.of(context)
                                    .requestFocus(documentTypeNode);
                              },
                              focusNode: areaNode,
                              textAlign: TextAlign.left,
                              textDirection: TextDirection.ltr,
                              enableSuggestions: false,
                              autocorrect: false,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: commercialFormLabels_area,
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
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () {
                                FocusScope.of(context).requestFocus(floorNode);
                              },
                              focusNode: documentTypeNode,
                              // textAlign: TextAlign.left,
                              // textDirection: TextDirection.ltr,
                              enableSuggestions: true,
                              autocorrect: true,
                              keyboardType: TextInputType.text,

                              decoration: const InputDecoration(
                                labelText: commercialFormLabels_documentType,
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
                              controller: floorController,
                              enabled: !disabled,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () {
                                FocusScope.of(context)
                                    .requestFocus(commercialAreaNode);
                              },
                              focusNode: floorNode,
                              textAlign: TextAlign.left,
                              textDirection: TextDirection.ltr,
                              enableSuggestions: false,
                              autocorrect: false,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: commercialFormLabels_floor,
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
                              controller: commercialAreaController,
                              enabled: !disabled,
                              textInputAction: TextInputAction.done,
                              onEditingComplete: () {
                                nextSection();
                              },
                              focusNode: commercialAreaNode,
                              textAlign: TextAlign.left,
                              textDirection: TextDirection.ltr,
                              enableSuggestions: false,
                              autocorrect: false,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: commercialFormLabels_commercialArea,
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
                                labelText: commercialFormLabels_price,
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
                                labelText: commercialFormLabels_city,
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
                                labelText: commercialFormLabels_district,
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
                                labelText: commercialFormLabels_quarter,
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
                              controller: alleyController,
                              enabled: !disabled,
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
                                labelText: commercialFormLabels_alley,
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
                    label: commercialFormTitle,
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
