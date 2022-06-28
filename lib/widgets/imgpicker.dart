import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';

import '../data/colors.dart';
import 'button.dart';

class PicturePicker extends StatefulWidget {
  const PicturePicker({
    Key? key,
    required this.controller,
    this.enabled,
  }) : super(key: key);

  final PicturePickerController controller;
  final bool? enabled;

  @override
  _PicturePickerState createState() => _PicturePickerState();
}

class _PicturePickerState extends State<PicturePicker>
    with TickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();
  late AnimationController animationControllerBottomSheet =
      BottomSheet.createAnimationController(this);

  picker(bool camera) async {
    List<XFile>? pictures = [];
    if (camera) {
      final XFile? picture =
          await _picker.pickImage(source: ImageSource.camera);
      if (picture is XFile) {
        pictures.add(picture);
      }
    } else {
      pictures = await _picker.pickMultiImage();
    }

    if (pictures != null && pictures.isNotEmpty) {
      widget.controller.addPictures(pictures);
    }
  }

  onTap() async {
    FocusScope.of(context).unfocus();
    if (picCount > 0 && picCount == uploadedCount) return;
    setState(() {
      isOpen = true;
    });
    const shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30.0),
        topRight: Radius.circular(30.0),
      ),
    );
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: shape,
      backgroundColor: Colors.white,
      transitionAnimationController: animationControllerBottomSheet,
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          maxChildSize: 0.85,
          minChildSize: 0.45,
          initialChildSize: 0.45,
          builder: (_, c) {
            return PicturePanel(
              controller: widget.controller,
              picker: picker,
              listController: c,
            );
          },
        );
      },
    ).whenComplete(() {
      setState(() {
        isOpen = false;
      });
    });
  }

  int isUploading = -1;
  int uploadedCount = 0;
  int picCount = 0;
  bool isOpen = false;

  @override
  void initState() {

    widget.controller.addListener(() {
      setState(() {
        isUploading = widget.controller.isUploading;
        uploadedCount = widget.controller.uploaded.length;
        picCount = widget.controller.pictures.length;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isOpen && picCount > 0 && picCount == uploadedCount) {
      Navigator.pop(context);
    }

    String _title = "انتخاب تصاویر";
    IconData _icon = Icons.photo_library;
    if (picCount == 0) {
      _icon = Icons.photo_library;
      _title = "انتخاب تصاویر";
    } else {
      if (isUploading > -1) {
        _icon = Icons.cloud_upload_outlined;
        _title = "در حال آپلود (" +
            (uploadedCount * 100 / picCount).toStringAsFixed(2) +
            "%)";
      } else {
        if (uploadedCount == picCount) {
          _icon = Icons.cloud_done_outlined;
          _title = "تکمیل آپلود";
        } else {
          _icon = Icons.photo_library;
          _title = picCount.toString() + " تصویر انتخاب شد";
        }
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
        ),
        height: 50,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _icon,
                color: textFieldBgColor,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Text(
                  _title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: textFieldBgColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PicturePickerController extends ChangeNotifier {
  List<XFile> pictures = [];
  int? thumb;

  int isUploading = -1;
  List<int> uploaded = [];

  void setThumb(v) {
    thumb = v;
    notifyListeners();
  }

  void addPictures(List<XFile> v) {
    pictures.addAll(v);
    thumb ??= 0;
    notifyListeners();
  }

  void removePictureAt(int v) {
    pictures.removeAt(v);
    if (v == thumb) {
      if (pictures.isEmpty) {
        thumb = null;
      } else {
        thumb = 0;
      }
    }
    notifyListeners();
  }

  void setUploading(int v) {
    isUploading = v;
    notifyListeners();
  }

  void addUploaded(int v) {
    uploaded.add(v);
    notifyListeners();
  }

  void removeAllUploaded() {
    uploaded = [];
    notifyListeners();
  }
}

//
//

class PicturePanel extends StatefulWidget {
  const PicturePanel({
    Key? key,
    required this.controller,
    required this.picker,
    required this.listController,
  }) : super(key: key);

  final PicturePickerController controller;
  final void Function(bool) picker;
  final ScrollController listController;

  @override
  _PicturePanelState createState() => _PicturePanelState();
}

class _PicturePanelState extends State<PicturePanel> {
  List<XFile> picturesState = [];
  int? thumbState;
  int isUploading = -1;
  List<int> uploaded = [];

  setDataState() {
    setState(() {
      picturesState = widget.controller.pictures;
      thumbState = widget.controller.thumb;
      isUploading = widget.controller.isUploading;
      uploaded = widget.controller.uploaded;
    });
  }

  @override
  void initState() {
    widget.controller.addListener(setDataState);

    if (widget.controller.pictures.isNotEmpty) {
      setDataState();
    }
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(setDataState);
    super.dispose();
  }

  Widget noPictureChosen = const Center(
    child: Text("شما هنوز تصویری برای این فایل انتخاب نکرده اید"),
  );

  Widget picturePreview(index) {
    return Container(
      color: const Color.fromARGB(255, 0, 0, 0),
      child: Image.file(
        File(picturesState[index].path),
        fit: BoxFit.contain,
      ),
    );
  }

  Widget pictureContainer(index) {
    bool isStar = thumbState != null && thumbState == index;
    var _disabled = (isUploading > -1) ||
        (picturesState.isNotEmpty && uploaded.length == picturesState.length);
    List<Widget> children = [
      Positioned.fill(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: SafeArea(child: picturePreview(index)),
              ),
            );
          },
          child: Image.file(
            File(picturesState[index].path),
            fit: BoxFit.cover,
          ),
        ),
      ),
    ];

    if (!_disabled) {
      children.add(Positioned(
        child: GestureDetector(
          onTap: () {
            widget.controller.removePictureAt(index);
          },
          child: const Icon(
            Icons.close,
            color: Colors.red,
          ),
        ),
        top: 4,
        right: 4,
      ));
      children.add(Positioned(
        child: GestureDetector(
          onTap: () {
            widget.controller.setThumb(index);
          },
          child: Icon(
            isStar ? Icons.star : Icons.star_border,
            color: isStar
                ? const Color.fromARGB(255, 241, 181, 0)
                : const Color.fromARGB(255, 124, 124, 124),
          ),
        ),
        bottom: 4,
        left: 4,
      ));
    } else {
      if (isUploading == index) {
        children.add(const Positioned(
          child: Icon(
            Icons.cloud_upload_outlined,
            color: Colors.yellow,
          ),
          top: 4,
          right: 4,
        ));
      } else if (uploaded.contains(index)) {
        children.add(const Positioned(
          child: Icon(
            Icons.cloud_done_outlined,
            color: Colors.green,
          ),
          top: 4,
          right: 4,
        ));
      }
      if (isStar) {
        children.add(const Positioned(
          child: Icon(Icons.star, color: Color.fromARGB(255, 241, 181, 0)),
          bottom: 4,
          left: 4,
        ));
      }
    }
    return Container(
      color: const Color.fromARGB(255, 0, 0, 0),
      child: Stack(children: children),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _title = "تصاویر";
    if (picturesState.isEmpty) {
      _title = "تصاویر";
    } else {
      if (isUploading > -1) {
        _title = "در حال آپلود (" +
            (uploaded.length * 100 / picturesState.length).toStringAsFixed(2) +
            "%)";
      } else {
        if (uploaded.length == picturesState.length) {
          _title = "همه تصاویر آپلود شدند";
        } else {
          _title = "تصاویر (" + picturesState.length.toString() + ")";
        }
      }
    }
    var _disabled = (isUploading > -1) ||
        (picturesState.isNotEmpty && uploaded.length == picturesState.length);

    Widget picturesList = Column(
      children: [
        Expanded(
          child: GridView.builder(
            controller: widget.listController,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            shrinkWrap: true,
            itemCount: picturesState.length,
            itemBuilder: (context, index) {
              return pictureContainer(index);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: OccButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  label: (_disabled ? "بازگشت" : "تایید"),
                  // enabled: !disabled,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                _title,
                style: Theme.of(context).textTheme.titleMedium!,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: OccButton(
                      onPressed: () {
                        widget.picker(true);
                      },
                      label: "از دوربین",
                      enabled: !_disabled,
                      type: _disabled ? "cancel" : null,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                  Expanded(
                    child: OccButton(
                      onPressed: () {
                        widget.picker(false);
                      },
                      label: "از گالری",
                      enabled: !_disabled,
                      type: _disabled ? "cancel" : null,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 15)),
            Expanded(
              child: picturesState.isNotEmpty ? picturesList : noPictureChosen,
            ),
          ],
        ),
      ),
    );
  }
}
