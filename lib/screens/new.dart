import 'package:flutter/material.dart';
import 'add_file.dart';

import '../data/colors.dart';
import '../data/strings.dart';

import '../widgets/occCard.dart';

class NewFile extends StatelessWidget {
  const NewFile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double ccc = (MediaQuery.of(context).size.width - 116) / 170;
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: ccc,
              ),
              shrinkWrap: true,
              itemCount: fileTypes.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddFile(index)),
                    )
                  },
                  child: OccCard(head: fileTypes[index]),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
