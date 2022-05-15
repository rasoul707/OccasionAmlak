import 'package:flutter/material.dart';
import '../data/colors.dart';

class OccTextField extends StatelessWidget {
  const OccTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        // controller: usernameController,
        // enabled: !disabled,
        // onEditingComplete: () {
        //   FocusScope.of(context).requestFocus(passwordNode);
        // },
        textInputAction: TextInputAction.next,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
        enableSuggestions: true,
        autocorrect: false,
        style: const TextStyle(color: textColor),
        decoration: const InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          filled: true,
          // labelText: villaFormLabels.jjj,
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
          contentPadding: EdgeInsets.symmetric(horizontal: 25),
        ),
      ),
    );
  }
}
