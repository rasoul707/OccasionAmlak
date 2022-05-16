import 'package:flutter/material.dart';
import '../models/hectare.dart';
import '../models/land.dart';
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
  // widget.index

  bool disabled = false;

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

  nextSection() {
    formFlipKey.currentState!.toggleCard();
    buttonFlipKey.currentState!.toggleCard();
  }

  previousSection() {
    formFlipKey.currentState!.toggleCard();
    buttonFlipKey.currentState!.toggleCard();
  }

  setLoading(bool dsb) {
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
    Hectare data = Hectare(
      usageStatus: usageStatusController.text,
      tissueStatus: tissueStatusController.text,
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

    String? token = await getAuthToken();
    dynamic res = await API(Dio(BaseOptions(headers: {"Authorization": token})))
        .addHectare(data)
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
                    front: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: TextFormField(
                              controller: usageStatusController,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () {
                                // FocusScope.of(context).requestFocus(passwordNode);
                              },
                              // textAlign: TextAlign.left,
                              // textDirection: TextDirection.ltr,
                              enableSuggestions: true,
                              autocorrect: true,
                              keyboardType: TextInputType.text,

                              decoration: const InputDecoration(
                                labelText: hectareFormLabels_usageStatus,
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
                              controller: tissueStatusController,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () {
                                // FocusScope.of(context).requestFocus(passwordNode);
                              },
                              // textAlign: TextAlign.left,
                              // textDirection: TextDirection.ltr,
                              enableSuggestions: true,
                              autocorrect: true,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                labelText: hectareFormLabels_tissueStatus,
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
                              controller: areaController,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () {
                                // FocusScope.of(context).requestFocus(passwordNode);
                              },
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
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () {
                                // FocusScope.of(context).requestFocus(passwordNode);
                              },
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
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () {
                                // FocusScope.of(context).requestFocus(passwordNode);
                              },
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
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () {
                                // FocusScope.of(context).requestFocus(passwordNode);
                              },
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
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () {
                                // FocusScope.of(context).requestFocus(passwordNode);
                              },
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
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () {
                                // FocusScope.of(context).requestFocus(passwordNode);
                              },
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
                              controller: alleyController,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () {
                                // FocusScope.of(context).requestFocus(passwordNode);
                              },
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
                  ),
                  back: OccButton(
                    onPressed: () {
                      submit();
                    },
                    label: hectareFormTitle,
                    loading: disabled,
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
