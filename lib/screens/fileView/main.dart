import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_gravatar/flutter_gravatar.dart';
import '../../api/main.dart';
import '../../helpers/file.dart';
import '../../helpers/numberConvertor.dart';
import '../../models/response.dart';
import '../../api/services.dart';
import '../../models/casefile.dart';
import '../../data/colors.dart';
import '../../widgets/equipments_list.dart';
import '../../widgets/snackbar.dart';

class FileViewSingle extends StatefulWidget {
  FileViewSingle(this.id, {Key? key, this.byTotal = false}) : super(key: key);

  String id;
  bool byTotal;

  @override
  State<FileViewSingle> createState() => _FileViewSingleState();
}

class _FileViewSingleState extends State<FileViewSingle> {
  int selectedPhoto = 0;
  CaseFile data = CaseFile(id: "-1");

  Future<void> getData() async {
    API api = await apiService();
    ApiResponse _result = await api
        .getFile(
          int.tryParse(widget.id)!,
        )
        .catchError(serviceError);
    if (_result.ok == true) {
      setState(() {
        data = _result.file!;
      });
    } else {
      Navigator.of(context).pop();
      OccSnackBar.error(context, _result.message ?? _result.code!);
      print(_result.message);
    }
  }

  @override
  void initState() {
    getData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const defaultAvatar = 'assets/images/default_avatar.png';
    const defaultHome = 'assets/images/file_placeholder.png';
    const defaultHomeSquare = 'assets/images/file_placeholder_square.png';

    if (data.id == "-1") {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    String type = data.type!;
    String title = typeConvert(type) + "\n" + data.city!;
    String price = priceFormat(data.price ?? 0);
    String totalPrice = priceFormat(data.totalPrice ?? 0);

    String documentType = "";
    String authorName = data.author!.displayName ?? "";
    String avatarUrl = defaultAvatar;
    if (data.author!.email != null) {
      final gravatar = Gravatar(data.author!.email!);
      avatarUrl = gravatar.imageUrl();
    }

    List<Widget> equ = [];
    List<Widget> detailBox = [];

    switch (type) {
      case 'villa':
        documentType = data.villa!.documentType!;
        equ = [
          Text(
            "امکانات: ",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
          ),
          data.villa!.equipments != null
              ? equipmentsList(context, data.villa!.equipments!)
              : Container(),
          const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
        ];
        detailBox = [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.straighten,
                color: textLightBgColor,
              ),
              const Padding(
                padding: EdgeInsets.only(right: 7),
              ),
              Flexible(
                child: Text(
                  persianNumber(data.villa!.buildingArea) + " متر مربع زیربنا",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  softWrap: true,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: textLightBgColor,
                      ),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.bed_rounded,
                color: textLightBgColor,
              ),
              const Padding(
                padding: EdgeInsets.only(right: 7),
              ),
              Flexible(
                child: Text(
                  persianNumber(data.villa!.mastersCount) + " اتاق خواب مستر",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  softWrap: true,
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
        documentType = data.apartment!.documentType!;
        equ = [
          Text(
            "امکانات: ",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
          ),
          data.apartment!.equipments != null
              ? equipmentsList(context, data.apartment!.equipments!)
              : Container(),
          const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
        ];
        detailBox = [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.straighten,
                color: textLightBgColor,
              ),
              const Padding(
                padding: EdgeInsets.only(right: 7),
              ),
              Flexible(
                child: Text(
                  persianNumber(data.apartment!.area) + " متر مربع",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  softWrap: true,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: textLightBgColor,
                      ),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.bed_rounded,
                color: textLightBgColor,
              ),
              const Padding(
                padding: EdgeInsets.only(right: 7),
              ),
              Flexible(
                child: Text(
                  persianNumber(data.apartment!.mastersCount) +
                      " اتاق خواب مستر",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  softWrap: true,
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
        documentType = data.commercial!.documentType!;
        detailBox = [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.straighten,
                color: textLightBgColor,
              ),
              const Padding(
                padding: EdgeInsets.only(right: 7),
              ),
              Flexible(
                child: Text(
                  persianNumber(data.commercial!.area) + " متر مربع",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  softWrap: true,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: textLightBgColor,
                      ),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.straighten,
                color: textLightBgColor,
              ),
              const Padding(
                padding: EdgeInsets.only(right: 7),
              ),
              Flexible(
                child: Text(
                  persianNumber(data.commercial!.commercialArea) +
                      " متر مربع برتجاری",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  softWrap: true,
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
        documentType = data.hectare!.documentType!;
        detailBox = [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.straighten,
                color: textLightBgColor,
              ),
              const Padding(
                padding: EdgeInsets.only(right: 7),
              ),
              Flexible(
                child: Text(
                  persianNumber(data.hectare!.area) + " متر مربع",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  softWrap: true,
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
        documentType = data.land!.documentType!;
        detailBox = [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.straighten,
                color: textLightBgColor,
              ),
              const Padding(
                padding: EdgeInsets.only(right: 7),
              ),
              Flexible(
                child: Text(
                  persianNumber(data.land!.area) + " متر مربع",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  softWrap: true,
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

    SliverAppBar? appBar;
    if (data.picturesUrl != null && data.picturesUrl!.isNotEmpty) {
      double width = MediaQuery.of(context).size.width;

      double pxImageH = 720;
      double pxImageW = 1241;
      List? image = data.picturesUrl?.elementAt(selectedPhoto).file;

      if (image != null && image.elementAt(1) > 0 && image.elementAt(2) > 0) {
        pxImageW = image.elementAt(1)?.toDouble();
        pxImageH = image.elementAt(2)?.toDouble();
      }
      double imgHeight = pxImageH * width / pxImageW;

      List<Widget> galley = [];

      galley.add(const Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
      ));

      for (var i = 0; i < data.picturesUrl!.length; i++) {
        galley.addAll([
          InkWell(
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: Container(
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: selectedPhoto == i ? Colors.cyan : null,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9.0),
                  child: FadeInImage.assetNetwork(
                    placeholder: defaultHomeSquare,
                    image: data.picturesUrl!
                        .elementAt(i)
                        .thumbnail!
                        .elementAt(0) as String,
                    fit: BoxFit.fill,
                    placeholderFit: BoxFit.fill,
                    fadeInDuration: const Duration(milliseconds: 300),
                    fadeOutDuration: const Duration(milliseconds: 300),
                    imageErrorBuilder: (c, o, s) {
                      return Image.asset(defaultHomeSquare);
                    },
                    placeholderErrorBuilder: (c, o, s) {
                      return Image.asset(defaultHomeSquare);
                    },
                  ),
                ),
              ),
            ),
            onTap: () {
              setState(() {
                selectedPhoto = i;
              });
            },
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
          ),
        ]);
      }
      appBar = SliverAppBar(
        stretch: true,
        elevation: 0,
        backgroundColor: bgColor,
        shadowColor: bgColor,
        foregroundColor: bgColor,
        automaticallyImplyLeading: false,
        toolbarHeight: 100,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Spacer(),
              Ink(
                decoration: const ShapeDecoration(
                  color: Colors.white,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  splashRadius: 25,
                  iconSize: 25.0,
                  padding: EdgeInsets.zero,
                  color: Colors.amber,
                  icon: const Icon(
                    Icons.arrow_forward_ios_rounded,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  tooltip: "برگشت",
                ),
              ),
            ],
          ),
        ),
        titleSpacing: 0,
        onStretchTrigger: () {
          return Future<void>.value();
        },
        expandedHeight: imgHeight + 100,
        flexibleSpace: FlexibleSpaceBar(
          stretchModes: const <StretchMode>[
            // StretchMode.zoomBackground,
            StretchMode.blurBackground,
            StretchMode.fadeTitle,
          ],
          titlePadding: EdgeInsets.zero,
          collapseMode: CollapseMode.parallax,
          background: Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    child: FadeInImage.assetNetwork(
                      placeholder: defaultHome,
                      image: data.picturesUrl!
                          .elementAt(selectedPhoto)
                          .file!
                          .elementAt(0) as String,
                      // image: defaultHome,
                      fit: BoxFit.fitWidth,
                      placeholderFit: BoxFit.fitWidth,
                      // height: imgHeight,
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
                  Positioned(
                    bottom: 20,
                    left: 50,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: lightBGColor,
                      ),
                      child: Center(
                        child: Text(
                          data.id!,
                          style:
                              Theme.of(context).textTheme.subtitle2?.copyWith(
                                    color: textLightBgColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                decoration: const BoxDecoration(
                  color: bgColor,
                ),
                height: 100,
                child: Center(
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(top: 20),
                    children: galley,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: <Widget>[
          appBar ?? const SliverToBoxAdapter(),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: bgColor,
              ),
              height: 20,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: bgColor,
              ),
              height: 30,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    height: 30,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 195,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: lightBGColor,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          child: Center(
                            child: FittedBox(
                              child: Text(
                                title,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    ?.copyWith(
                                      color: textLightBgColor,
                                      fontWeight: FontWeight.w700,
                                      height: 1.5,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              height: 110,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: lightBGColor,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 5,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: detailBox,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                            ),
                            Container(
                              height: 75,
                              width: double.infinity,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      widget.byTotal ? "قیمت کل" : "هر متر",
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
                                        widget.byTotal ? totalPrice : price,
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
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "وضعیت سند: ",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5)),
                      Text(
                        documentType,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            ?.copyWith(fontSize: 20),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 7,
                    ),
                  ),
                  ...equ,
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 7,
                    ),
                  ),
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: lightBGColor,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "فایل و بازدید",
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
                                Text(
                                  authorName,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ],
                            ),
                          ),
                        ),
                        ClipOval(
                          child: Container(
                            child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: Padding(
                                padding: const EdgeInsets.all(
                                  8,
                                ), // Border radius
                                child: ClipOval(
                                  child: FadeInImage.assetNetwork(
                                    placeholder: defaultAvatar,
                                    image: avatarUrl,
                                    fit: BoxFit.fill,
                                    placeholderFit: BoxFit.fill,
                                    fadeInDuration:
                                        const Duration(milliseconds: 300),
                                    fadeOutDuration:
                                        const Duration(milliseconds: 300),
                                    imageErrorBuilder: (c, o, s) {
                                      return Image.asset(defaultAvatar);
                                    },
                                    placeholderErrorBuilder: (c, o, s) {
                                      return Image.asset(defaultAvatar);
                                    },
                                  ),
                                ),
                              ),
                            ),
                            width: 100,
                            height: 100,
                            color: hintColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              height: 20,
            ),
          ),
        ],
      )),
    );
  }
}
