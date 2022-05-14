import 'package:flutter/material.dart';

import '../data/colors.dart';
import '../data/strings.dart';
import '../widgets/occButton.dart';
import '../widgets/occCard.dart';

class NewFile extends StatefulWidget {
  const NewFile({Key? key}) : super(key: key);

  @override
  _NewFileState createState() => _NewFileState();
}

class _NewFileState extends State<NewFile> {
  @override
  void initState() {
    super.initState();
  }

  //

  Widget chooseType() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio:
            ((MediaQuery.of(context).size.width - 4 * 4 - 2 * 50) / 2) / 85,
      ),
      shrinkWrap: true,
      itemCount: fileTypes.length,
      itemBuilder: (context, index) {
        return OccCard(head: fileTypes[index]);
      },
    );
  }

  Widget showResult(bool success) {
    String imgSrc = "error";
    String title = fileAddedErrorTitle;
    String subTitle = fileAddedErrorSubTitle;

    if (success) {
      imgSrc = "success";
      title = fileAddedSuccessTitle;
      subTitle = fileAddedSuccessSubTitle;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Spacer(),
        Image(
          image: AssetImage("assets/images/" + imgSrc + ".png"),
          width: 235,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 24,
              color: textColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            subTitle,
            style: const TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 14,
              color: textColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: OccButton(
            onPressed: () {},
            label: back2Home,
            type: 'cancel',
          ),
        ),
        const Spacer(),
      ],
    );
  }

  //

  Widget addVilla() {
    return Column(
      children: [
        Text("ثبت ویلا"),
      ],
    );
  }

  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: chooseType(),
          ),
        ),
      ),
    );
  }
}
