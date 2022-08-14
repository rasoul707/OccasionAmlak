import 'package:flutter/material.dart';
import '../../helpers/numberConvertor.dart';
import '../../models/casefile.dart';
import '../../api/main.dart';
import '../../api/services.dart';
import '../../models/response.dart';
import '../../widgets/RMFileViewItem.dart';
import '../../widgets/RMAppBar.dart';
import '../../data/colors.dart';
import '../../widgets/selectlist.dart';
import '../../widgets/snackbar.dart';

const sortingItems = ['جدیدترین', 'قدیمی ترین', 'ارزان ترین', 'گران ترین'];
const sortingItemsVal = ['-time', 'time', 'price', '-price'];

class SearchList extends StatefulWidget {
  SearchList({
    Key? key,
    this.district,
    this.area,
    this.buildingArea,
    this.type,
    this.price,
    this.canBarter,
  }) : super(key: key);

  String? district;
  double? area;
  double? buildingArea;
  List<String>? type;
  List<String>? price;
  bool? canBarter;

  @override
  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  bool disabled = false;
  final OccSelectListController fileTypeController = OccSelectListController();
  bool loading = true;
  List<CaseFile> fileItems = [];
  String sorting = '-time';

  @override
  void initState() {
    searchFiles();
    super.initState();
  }

  Future<void> searchFiles() async {
    API api = await apiService();
    ApiResponse _result = await api
        .searchFile(
          widget.type!.join(","),
          widget.price!.join(","),
          widget.district.toString(),
          widget.area.toString(),
          widget.buildingArea.toString(),
          widget.canBarter == true ? 1 : 0,
        )
        .catchError(serviceError);

    if (_result.ok!) {
      if (_result.files == null || _result.files!.isEmpty) {
        Navigator.of(context).pop();
        OccSnackBar.error(context, 'چیزی یافت نشد :(');
      } else {
        setState(() {
          loading = false;
          fileItems = _result.files!;
        });
      }
    } else {
      Navigator.of(context).pop();
      OccSnackBar.error(context, _result.message ?? _result.code!);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    fileItems.sort((a, b) {
      if (sorting == 'price') {
        return a.price!.compareTo(b.price!);
      }
      if (sorting == '-price') {
        return b.price!.compareTo(a.price!);
      }
      if (sorting == 'time') {
        return a.modified!.compareTo(b.modified!);
      }
      return b.modified!.compareTo(a.modified!);
    });

    List<Widget> items = fileItems.map((e) {
      return RMFileViewItem(file: e);
    }).toList();

    return Scaffold(
      appBar: RMAppBar(
        title: persianNumber(fileItems.length) + " مورد یافت شد",
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 10),
          ),
          Ink(
            decoration: const ShapeDecoration(
              color: extraColor,
              shape: CircleBorder(),
            ),
            child: IconButton(
              splashRadius: 25,
              iconSize: 25.0,
              padding: EdgeInsets.zero,
              color: Colors.white,
              icon: const Icon(
                Icons.filter_list_alt,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              tooltip: "جستجو",
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(200),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "مرتب سازی براساس:",
                    textAlign: TextAlign.right,
                  ),
                  DropdownButton(
                    value: sorting,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: sortingItems.map((String item) {
                      int index = sortingItems.indexOf(item);
                      return DropdownMenuItem(
                        value: sortingItemsVal[index],
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        sorting = newValue!;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: ListView(
                children: [
                  ...items,
                  const Padding(padding: EdgeInsets.only(bottom: 20))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
