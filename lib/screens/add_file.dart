import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';

import '../helpers/addfile.dart';
import '../models/file.dart';
import '../api/services.dart';
import '../data/strings.dart';

import '../widgets/button.dart';
import '../widgets/locationchooser.dart';
import '../widgets/snackbar.dart';

import 'add_villa.dart';
import 'add_apartment.dart';
import 'add_land.dart';
import 'add_commercial.dart';
import 'add_hectare.dart';
import 'file_added_result.dart';
//
//

const List<String> formTypes = [
  'villa',
  'apartment',
  'land',
  'commercial',
  'hectare'
];

const List<String> formTitleTypes = [
  villaFormTitle,
  apartmentFormTitle,
  landFormTitle,
  commercialFormTitle,
  hectareFormTitle
];

//
//

class AddFile extends StatefulWidget {
  const AddFile(this.index, {Key? key}) : super(key: key);

  final int index;

  @override
  _AddFileState createState() => _AddFileState();
}

class _AddFileState extends State<AddFile> {
  //
  bool disabled = false;
  bool loading = false;
  static const flipSpeed = 1000;

  final GlobalKey<FlipCardState> buttonFlipKey = GlobalKey<FlipCardState>();
  final GlobalKey<FlipCardState> formFlipKey = GlobalKey<FlipCardState>();

  // => general data
  final TextEditingController priceController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController quarterController = TextEditingController();
  final TextEditingController alleyController = TextEditingController();
  final MapController locationController = MapController();

  final FocusNode priceNode = FocusNode();
  final FocusNode cityNode = FocusNode();
  final FocusNode districtNode = FocusNode();
  final FocusNode quarterNode = FocusNode();
  final FocusNode alleyNode = FocusNode();

  // =>
  AddVillaController addVillaController = AddVillaController();
  AddApartmentController addApartmentController = AddApartmentController();
  AddCommercialController addCommercialController = AddCommercialController();
  AddHectareController addHectareController = AddHectareController();
  AddLandController addLandController = AddLandController();

  AddFileController _controller = AddFileController();

  @override
  void initState() {
    priceController.addListener(() {
      _controller.setPrice(priceController.text);
    });
    cityController.addListener(() {
      _controller.setCity(cityController.text);
    });
    districtController.addListener(() {
      _controller.setDistrict(districtController.text);
    });
    _controller.checkCondition();
    super.initState();
  }

  setLoading(bool cond) {
    setState(() {
      loading = cond;
    });
  }

  setDisabled(bool cond) {
    setState(() {
      disabled = cond;
    });
  }

  done(bool success) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FileAddedResult(success)),
    );
  }

  List<String> errorHandler() {
    switch (widget.index) {
      case 0:
        return addVillaController.errors;
      case 1:
        return addApartmentController.errors;
      case 2:
        return addLandController.errors;
      case 3:
        return addCommercialController.errors;
      case 4:
        return addHectareController.errors;
    }
    return [];
  }

  nextSection() async {
    var _e = errorHandler();
    if (_e.isNotEmpty) {
      OccSnackBar.error(context, _e.map((e) => "◀ " + e).toList().join("\n"));
      return;
    }
    formFlipKey.currentState!.toggleCard();
    buttonFlipKey.currentState!.toggleCard();
    setDisabled(true);
    await Future.delayed(const Duration(milliseconds: flipSpeed));
    setDisabled(false);
  }

  previousSection() async {
    formFlipKey.currentState!.toggleCard();
    buttonFlipKey.currentState!.toggleCard();
    setDisabled(true);
    await Future.delayed(const Duration(milliseconds: flipSpeed));
    setDisabled(false);
  }

  submit() async {
    var _e = _controller.errors;
    if (_e.isNotEmpty) {
      OccSnackBar.error(context, _e.map((e) => "◀ " + e).toList().join("\n"));
      return;
    }
    // setLoading(true);
    // setDisabled(true);

    // data collect
    File data = File(
      price: int.tryParse(priceController.text),
      city: cityController.text,
      district: districtController.text,
      quarter: quarterController.text,
      alley: alleyController.text,
      location: [
        locationController.center.latitude,
        locationController.center.longitude,
        locationController.zoom,
      ],
      pictures: [],
      thumb: 5,
      //
      type: formTypes[widget.index],
    );
    switch (widget.index) {
      case 0:
        data.villa = addVillaController.data;
        break;
      case 1:
        data.apartment = addApartmentController.data;
        break;
      case 2:
        data.land = addLandController.data;
        break;
      case 3:
        data.commercial = addCommercialController.data;
        break;
      case 4:
        data.hectare = addHectareController.data;
        break;
    }

    print(data.toJson());

    // error action
    ErrorAction _err = ErrorAction(
      response: (r) {
        OccSnackBar.error(context, r.data['code']);
      },
      connection: () {
        OccSnackBar.error(context, internetConnectionErrorLabel);
      },
      cancel: () {
        OccSnackBar.error(context, canceledFormLabel);
      },
    );

    // call api
    int _result = await Services.addFile(data, _err);
    print(_result);

    // okay
    if (_result > 0) {
      done(true);
    } else {
      done(false);
    }

    // finish
    //
  }

  @override
  Widget build(BuildContext context) {
    //
    // => specialData
    Widget specialData = Container();
    switch (widget.index) {
      case 0:
        specialData = AddVilla(
          controller: addVillaController,
          disabled: disabled,
        );
        break;
      case 1:
        specialData = AddApartment(
          controller: addApartmentController,
          disabled: disabled,
        );
        break;
      case 2:
        specialData = AddLand(
          controller: addLandController,
          disabled: disabled,
        );
        break;
      case 3:
        specialData = AddCommercial(
          controller: addCommercialController,
          disabled: disabled,
        );
        break;
      case 4:
        specialData = AddHectare(
          controller: addHectareController,
          disabled: disabled,
        );
        break;
    }

    // => generalData
    final generalData = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              focusNode: priceNode,
              controller: priceController,
              enabled: !disabled,
              textInputAction: TextInputAction.next,
              onEditingComplete: () {
                cityNode.requestFocus();
              },
              textDirection: TextDirection.ltr,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: addFileFormLabels_price),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              focusNode: cityNode,
              controller: cityController,
              enabled: !disabled,
              textInputAction: TextInputAction.next,
              onEditingComplete: () {
                districtNode.requestFocus();
              },
              enableSuggestions: true,
              autocorrect: true,
              keyboardType: TextInputType.text,
              decoration:
                  const InputDecoration(labelText: addFileFormLabels_city),
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
              enableSuggestions: true,
              autocorrect: true,
              keyboardType: TextInputType.text,
              decoration:
                  const InputDecoration(labelText: addFileFormLabels_district),
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
              enableSuggestions: true,
              autocorrect: true,
              keyboardType: TextInputType.text,
              decoration:
                  const InputDecoration(labelText: addFileFormLabels_quarter),
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
              enableSuggestions: true,
              autocorrect: true,
              keyboardType: TextInputType.text,
              decoration:
                  const InputDecoration(labelText: addFileFormLabels_alley),
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
    );

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: WillPopScope(
            onWillPop: () async {
              if (!formFlipKey.currentState!.isFront && !disabled) {
                previousSection();
                return false;
              }
              if (disabled) return false;
              return true;
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 15),
                  child: Text(
                    formTitleTypes[widget.index],
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Expanded(
                  child: FlipCard(
                    direction: FlipDirection.HORIZONTAL,
                    flipOnTouch: false,
                    key: formFlipKey,
                    speed: flipSpeed,
                    front: specialData,
                    back: generalData,
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
                      onPressed: nextSection,
                      label: addContinueButtonLabel,
                      enabled: !disabled,
                    ),
                    back: OccButton(
                      onPressed: submit,
                      label: formTitleTypes[widget.index],
                      enabled: !disabled,
                      loading: loading,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddFileController extends AddFileControllerErrorHandler {
  File data = File();

  @override
  void checkCondition() {
    errorHandler(
      condition: (isGreaterThan(data.price, 0)),
      error: "قیمت را وارد کنید",
    );
    errorHandler(
      condition: (isRealString(data.city)),
      error: "شهر را وارد کنید",
    );
    errorHandler(
      condition: (isRealString(data.district)),
      error: "منطقه را وارد کنید",
    );

    notifyListeners();
  }

  void setPrice(v) {
    data.price = int.tryParse(v);
    checkCondition();
  }

  void setCity(v) {
    data.city = v;
    checkCondition();
  }

  void setDistrict(v) {
    data.district = v;
    checkCondition();
  }
}
