import 'package:flutter/material.dart';
import '../data/colors.dart';

class RMAppBar extends StatelessWidget implements PreferredSizeWidget {
  RMAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.actionsColor,
    this.actionsBackground,
    this.height,
  }) : super(key: key);

  String title;
  List<Widget>? actions;
  Widget? flexibleSpace;
  PreferredSize? bottom;
  Color? actionsBackground;
  Color? actionsColor;
  double? height;

  @override
  Size get preferredSize => Size.fromHeight(height ?? 160);

  @override
  Widget build(BuildContext context) {
    actions ??= [];
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: null,
        backgroundColor: bgColor,
        titleSpacing: 0,
        toolbarHeight: 100,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //
              Flexible(
                child: Text(
                  title,
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  softWrap: true,
                ),
              ),
              //
              Row(
                children: [
                  ...actions!,
                  const Padding(
                    padding: EdgeInsets.only(right: 10),
                  ),
                  Ink(
                    decoration: ShapeDecoration(
                      color: actionsBackground ?? extraColor,
                      shape: const CircleBorder(),
                    ),
                    child: IconButton(
                      splashRadius: 25,
                      iconSize: 25.0,
                      padding: EdgeInsets.zero,
                      color: actionsColor ?? Colors.white,
                      icon: const Icon(
                        Icons.arrow_forward_ios_rounded,
                      ),
                      onPressed: () {
                        Navigator.of(context).popUntil(
                          (route) => route.isFirst,
                        );
                      },
                      tooltip: "برگشت",
                    ),
                  ),
                ],
              ),
              //
            ],
          ),
        ),
        bottom: bottom,
        flexibleSpace: flexibleSpace,
      ),
    );
  }
}
