import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:occasionapp/widgets/choose_location.dart';
import '../widgets/occTextField.dart';
import 'file_added_result.dart';

import '../data/colors.dart';
import '../data/strings.dart';
import '../widgets/occButton.dart';

class AddFile extends StatelessWidget {
  AddFile(this.index, {Key? key}) : super(key: key);

  final int index;

  final List<Type> forms = [VillaForm];

  @override
  Widget build(BuildContext context) {
    done(bool success) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => FileAddedResult(success)),
        (Route<dynamic> route) => route.isFirst,
      );
    }

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Center(
          child: VillaForm(),
        ),
      ),
    );
  }
}

//
//
//
//
//
class VillaForm extends StatelessWidget {
  VillaForm({Key? key}) : super(key: key);

  final PageController _pageController = PageController();

  final TextEditingController typeController = TextEditingController();
  final TextEditingController landAreaController = TextEditingController();
  final TextEditingController buildingAreaController = TextEditingController();
  final TextEditingController constructionYearController =
      TextEditingController();
  final TextEditingController documentTypeController = TextEditingController();
  final TextEditingController roomsCountController = TextEditingController();

  final TextEditingController priceController = TextEditingController();

  final TextEditingController cityController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController quarterController = TextEditingController();
  final TextEditingController alleyController = TextEditingController();

  final MapController locationController = MapController();

  @override
  Widget build(BuildContext context) {
    print("hhhh");
    return Column(
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
              if (_pageController.page! > 0.0) {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.linear,
                );
                return false;
              }
              return true;
              // if (isActive != 0) {
              //   _pageChange(0);
              //   return false;
              // }
              // return true;
            },
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: ListView(
                    children: [
                      OccTextField(),
                      OccTextField(),
                      OccTextField(),
                      OccTextField(),
                      OccTextField(),
                      OccTextField(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          // controller: usernameController,
                          // enabled: !disabled,
                          textInputAction: TextInputAction.next,
                          // onEditingComplete: () {
                          //   FocusScope.of(context).requestFocus(passwordNode);
                          // },
                          textAlign: TextAlign.left,
                          textDirection: TextDirection.ltr,
                          enableSuggestions: true,
                          autocorrect: false,
                          style: const TextStyle(color: textColor),
                          decoration: const InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            filled: true,
                            labelText: usernameLabel,
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
                        ),
                      ),
                      ChooseLocation(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 50, right: 50, bottom: 30, top: 15),
          child: OccButton(
            onPressed: () {
              // _pageController.jumpToPage(1);
              _pageController.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.linear,
              );
            },
            label: addContinueButtonLabel,
            // loading: disabled,
          ),
        ),
      ],
    );
  }
}

//
//
//
//
//

Widget apartmentForm(done) {
  return const Text(
    "apartmentForm",
    style: const TextStyle(color: Colors.black),
  );
}

//
//
//
//
//

Widget landForm(done) {
  return const Text(
    "landForm",
    style: TextStyle(color: Colors.black),
  );
}

//
//
//
//
//

Widget commercialForm(done) {
  return const Text(
    "commercialForm",
    style: const TextStyle(color: Colors.black),
  );
}

//
//
//
//
//

Widget hectareForm(done) {
  return const Text(
    "hectareForm",
    style: TextStyle(color: Colors.black),
  );
}
