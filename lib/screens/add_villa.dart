import 'package:flutter/material.dart';
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
import '../models/villa.dart';

class AddVilla extends StatefulWidget {
  const AddVilla({Key? key}) : super(key: key);

  @override
  _AddVillaState createState() => _AddVillaState();
}

class _AddVillaState extends State<AddVilla> {
  final TextEditingController typeController = TextEditingController();
  final TextEditingController landAreaController = TextEditingController();
  final TextEditingController buildingAreaController = TextEditingController();
  final TextEditingController constructionYearController =
      TextEditingController();
  final TextEditingController documentTypeController = TextEditingController();
  final TextEditingController roomsCountController = TextEditingController();
  final TextEditingController mastersCountController = TextEditingController();

  final TextEditingController priceController = TextEditingController();

  final TextEditingController cityController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController quarterController = TextEditingController();
  final TextEditingController alleyController = TextEditingController();

  final MapController locationController = MapController();

  final GlobalKey<FlipCardState> buttonFlipKey = GlobalKey<FlipCardState>();
  final GlobalKey<FlipCardState> formFlipKey = GlobalKey<FlipCardState>();

  bool disabled = false;
  bool loading = false;
  final int flipSpeed = 1000;

  final FocusNode typeNode = FocusNode();
  final FocusNode landAreaNode = FocusNode();
  final FocusNode buildingAreaNode = FocusNode();
  final FocusNode constructionYearNode = FocusNode();
  final FocusNode documentTypeNode = FocusNode();
  final FocusNode roomsCountNode = FocusNode();
  final FocusNode mastersCountNode = FocusNode();

  final FocusNode priceNode = FocusNode();
  final FocusNode cityNode = FocusNode();
  final FocusNode districtNode = FocusNode();
  final FocusNode quarterNode = FocusNode();
  final FocusNode alleyNode = FocusNode();

  String type = "";

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
    Villa data = Villa(
      type: type,
      landArea: double.tryParse(landAreaController.text),
      buildingArea: double.tryParse(buildingAreaController.text),
      constructionYear: int.tryParse(constructionYearController.text),
      documentType: documentTypeController.text,
      roomsCount: int.tryParse(roomsCountController.text),
      mastersCount: int.tryParse(mastersCountController.text),
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
        .addVilla(data)
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
                  villaFormTitle,
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
                                "فلت",
                                "دوبلکس",
                                "تریبلکس",
                                "طبقات جداگانه"
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
                          //       landAreaNode.requestFocus();
                          //     },
                          //     focusNode: typeNode,
                          //     // textAlign: TextAlign.left,
                          //     // textDirection: TextDirection.ltr,
                          //     enableSuggestions: true,
                          //     autocorrect: true,
                          //     keyboardType: TextInputType.text,
                          //     decoration: const InputDecoration(
                          //       labelText: villaFormLabels_type,
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
                              controller: landAreaController,
                              enabled: !disabled,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () {
                                buildingAreaNode.requestFocus();
                              },
                              focusNode: landAreaNode,
                              textAlign: TextAlign.left,
                              textDirection: TextDirection.ltr,
                              enableSuggestions: false,
                              autocorrect: false,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: villaFormLabels_landArea,
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
                              controller: buildingAreaController,
                              enabled: !disabled,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () {
                                constructionYearNode.requestFocus();
                              },
                              focusNode: buildingAreaNode,
                              textAlign: TextAlign.left,
                              textDirection: TextDirection.ltr,
                              enableSuggestions: false,
                              autocorrect: false,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: villaFormLabels_buildingArea,
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
                              controller: constructionYearController,
                              enabled: !disabled,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () {
                                documentTypeNode.requestFocus();
                              },
                              focusNode: constructionYearNode,
                              textAlign: TextAlign.left,
                              textDirection: TextDirection.ltr,
                              enableSuggestions: false,
                              autocorrect: false,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: villaFormLabels_constructionYear,
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
                                roomsCountNode.requestFocus();
                              },
                              focusNode: documentTypeNode,
                              // textAlign: TextAlign.left,
                              // textDirection: TextDirection.ltr,
                              enableSuggestions: true,
                              autocorrect: true,
                              keyboardType: TextInputType.text,

                              decoration: const InputDecoration(
                                labelText: villaFormLabels_documentType,
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
                              controller: roomsCountController,
                              enabled: !disabled,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () {
                                mastersCountNode.requestFocus();
                              },
                              focusNode: roomsCountNode,
                              textAlign: TextAlign.left,
                              textDirection: TextDirection.ltr,
                              enableSuggestions: false,
                              autocorrect: false,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: villaFormLabels_roomsCount,
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
                              controller: mastersCountController,
                              enabled: !disabled,
                              textInputAction: TextInputAction.done,
                              onEditingComplete: () {
                                nextSection();
                              },
                              focusNode: mastersCountNode,
                              textAlign: TextAlign.left,
                              textDirection: TextDirection.ltr,
                              enableSuggestions: false,
                              autocorrect: false,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: villaFormLabels_mastersCount,
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
                                labelText: villaFormLabels_price,
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
                                labelText: villaFormLabels_city,
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
                                labelText: villaFormLabels_district,
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
                                labelText: villaFormLabels_quarter,
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
                                labelText: villaFormLabels_alley,
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
                    label: villaFormTitle,
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
