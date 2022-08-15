import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../data/colors.dart';
import '../helpers/file.dart';
import '../helpers/numberConvertor.dart';
import '../models/casefile.dart';
import '../screens/fileView/main.dart';

class RMFileViewItem extends StatelessWidget {
  RMFileViewItem({
    Key? key,
    required this.file,
    this.byTotal = false,
  }) : super(key: key);

  final CaseFile file;
  final bool byTotal;

  openFile(context, String id) {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        child: FileViewSingle(id, byTotal: byTotal),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl = file.thumbUrl!.file!.elementAt(0);
    String type = file.type!;
    String title = typeConvert(type) + " " + file.city!;
    String price = priceFormat(file.price ?? 0);
    String totalPrice = priceFormat(file.totalPrice ?? 0);

    List<Widget> detailsBox = [];

    switch (type) {
      case 'villa':
        title = "فروش " +
            persianNumber(file.villa!.buildingArea) +
            " متر ویلا " +
            file.city!;
        detailsBox = [
          Row(
            children: [
              const Icon(
                Icons.aspect_ratio,
                color: textLightBgColor,
              ),
              const Padding(
                padding: EdgeInsets.only(right: 7),
              ),
              FittedBox(
                child: Text(
                  persianNumber(file.villa!.buildingArea),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: textLightBgColor,
                      ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Icon(
                Icons.bed_rounded,
                color: textLightBgColor,
              ),
              const Padding(
                padding: EdgeInsets.only(right: 7),
              ),
              FittedBox(
                child: Text(
                  persianNumber(file.villa!.mastersCount),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: textLightBgColor,
                      ),
                ),
              ),
            ],
          ),
        ];
        break;
      //
      //
      //
      case 'apartment':
        title = "فروش " +
            persianNumber(file.apartment!.area) +
            " متر آپارتمان " +
            file.city!;
        detailsBox = [
          Row(
            children: [
              const Icon(
                Icons.aspect_ratio,
                color: textLightBgColor,
              ),
              const Padding(
                padding: EdgeInsets.only(right: 7),
              ),
              FittedBox(
                child: Text(
                  persianNumber(file.apartment!.area),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: textLightBgColor,
                      ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Icon(
                Icons.bed_rounded,
                color: textLightBgColor,
              ),
              const Padding(
                padding: EdgeInsets.only(right: 7),
              ),
              FittedBox(
                child: Text(
                  persianNumber(file.apartment!.mastersCount),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: textLightBgColor,
                      ),
                ),
              ),
            ],
          ),
        ];
        break;

      //
      //
      //
      case 'commercial':
        title = "فروش " +
            persianNumber(file.commercial!.area) +
            " متر تجاری " +
            file.city!;
        detailsBox = [
          Row(
            children: [
              const Icon(
                Icons.aspect_ratio,
                color: textLightBgColor,
              ),
              const Padding(
                padding: EdgeInsets.only(right: 7),
              ),
              FittedBox(
                child: Text(
                  persianNumber(file.commercial!.area),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: textLightBgColor,
                      ),
                ),
              ),
            ],
          ),
        ];
        break;
      //
      //
      //
      case 'hectare':
        title = "فروش " +
            persianNumber(file.hectare!.area) +
            " متر هکتاری " +
            file.city!;
        detailsBox = [
          Row(
            children: [
              const Icon(
                Icons.aspect_ratio,
                color: textLightBgColor,
              ),
              const Padding(
                padding: EdgeInsets.only(right: 7),
              ),
              FittedBox(
                child: Text(
                  persianNumber(file.hectare!.area),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: textLightBgColor,
                      ),
                ),
              ),
            ],
          ),
        ];
        //
        //
        //
        break;
      case 'land':
        title = "فروش " +
            persianNumber(file.land!.area) +
            " متر زمین " +
            file.city!;
        detailsBox = [
          Row(
            children: [
              const Icon(
                Icons.aspect_ratio,
                color: textLightBgColor,
              ),
              const Padding(
                padding: EdgeInsets.only(right: 7),
              ),
              FittedBox(
                child: Text(
                  persianNumber(file.land!.area),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: textLightBgColor,
                      ),
                ),
              ),
            ],
          ),
        ];
        break;
    }

    const defaultHome = 'assets/images/file_placeholder.png';
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () {
          openFile(context, file.id!);
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(30),
                  ),
                  child: FadeInImage.assetNetwork(
                    placeholder: defaultHome,
                    image: imageUrl,
                    fit: BoxFit.fitWidth,
                    placeholderFit: BoxFit.fitWidth,
                    fadeInDuration: const Duration(milliseconds: 300),
                    fadeOutDuration: const Duration(milliseconds: 300),
                    imageErrorBuilder: (c, o, s) {
                      return Image.asset(defaultHome);
                    },
                    placeholderErrorBuilder: (c, o, s) {
                      return Image.asset(defaultHome);
                    },
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              Row(
                mainAxisSize: MainAxisSize.max,
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 85,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      color: lightBGColor,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: detailsBox,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                  Expanded(
                    child: Container(
                      height: 75,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        color: lightBGColor,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              byTotal ? "قیمت کل" : "هر متر",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: true,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    height: 0.9,
                                    color: textLightBgColor,
                                  ),
                            ),
                            FittedBox(
                              child: Text(
                                byTotal ? totalPrice : price,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                softWrap: true,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      height: 1,
                                      color: textLightBgColor,
                                    ),
                              ),
                            ),
                            Text(
                              "تومان",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: true,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    height: 0.9,
                                    color: textLightBgColor,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
