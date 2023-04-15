import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loftfin/models/api_response.dart';
import 'package:loftfin/models/perk.dart';
import 'package:loftfin/networking/api_repository.dart';
import 'package:loftfin/providers/menu_provider.dart';
import 'package:loftfin/providers/perk_provider.dart';
import 'package:loftfin/services/log_service.dart';
import 'package:loftfin/style/app_theme.dart';
import 'package:loftfin/widgets/custom_alert.dart';
import 'package:loftfin/widgets/custom_appbar.dart';
import 'package:loftfin/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerkListScreen extends StatefulWidget {
  static String routeName = "/perk_list";

  PerkListScreen({Key? key}) : super(key: key);

  @override
  _DashBoardScreen createState() => _DashBoardScreen();
}

class _DashBoardScreen extends State<PerkListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Perk> _originalList = [];
  List<Perk> _filteredList = [];
  List<PlatformFile>? _paths;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool unknownSearch = false;

  Timer? _debounceFilterData;

  ApiRepository _apiRepository = ApiRepository();
  bool isRefreshing = false;
  final BoxDecoration decoration = BoxDecoration(
    borderRadius: BorderRadius.circular(5),
    color: AppTheme.white,
    boxShadow: <BoxShadow>[
      BoxShadow(
        color: Colors.black26,
        // blurRadius: 3,
        // spreadRadius: 0,
      ),
    ],
  );

  final BoxDecoration headerDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(5),
    color: Color(0XFFEEF2FF),
    border: Border.all(color: Colors.black12),
    boxShadow: <BoxShadow>[
      BoxShadow(
        color: Colors.black26,
        // blurRadius: 3,
        // spreadRadius: 0,
      ),
    ],
  );
  @override
  void initState() {
    super.initState();
  }

  void _openFileExplorer(String id) async {
    final SharedPreferences prefs = await _prefs;
    FileType _pickingType = FileType.custom;
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: false,
        allowedExtensions: [
          'csv',
        ],
      ))
          ?.files;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    if (_paths != null) {
      dPrint(_paths![0].name);
      EasyLoading.show(status: "Uploading");
      ApiResponse res = await _apiRepository.uploadLocation(
          _paths![0].bytes, _paths![0].name, id);
      EasyLoading.dismiss();
      if (res.isError) {
        EasyLoading.showError('Failed');
      } else {
        EasyLoading.showSuccess('Uploaded');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _originalList = context.read<PerksProvider>().perkList;
    setState(() {});
    return _body();
  }

  PreferredSizeWidget _appBar() {
    return CustomAppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppTheme.blue,
          ),
          onPressed: () {},
        ),
        title: 'Perks',
        trailing: Offstage());
  }

  void _runSearch(String enteredKeyword) {
    unknownSearch = false;
    if (_debounceFilterData?.isActive ?? false) _debounceFilterData!.cancel();
    List<Perk> results = [];
    _debounceFilterData = Timer(const Duration(milliseconds: 300), () {
      if (enteredKeyword.isEmpty) {
        results = _originalList;
      } else {
        // results = context.read<PerksProvider>().perkList.where((element) {
        //   return element.displayName
        //       .toLowerCase()
        //       .contains(enteredKeyword.toLowerCase());
        // }).toList();

        // _originalList.forEach((e) {
        //   if (e.displayName
        //           .toLowerCase()
        //           .contains(enteredKeyword.toLowerCase()) ||
        //       e.vendorName
        //           .toLowerCase()
        //           .contains(enteredKeyword.toLowerCase())) {
        //     results.add(e);
        //   }
        // });

        _originalList.forEach((element) {
          String temp = "\$";
          String finalTemp = "";

          element.toMap().values.forEach((e) {
            temp = temp + e.toString();
            finalTemp = temp;
          });

          if (finalTemp.toLowerCase().contains(enteredKeyword.toLowerCase())) {
            results.add(element);
          }
        });

        // setState(() {
        //   results = _filteredList;
        //   _filteredList = [];
        //   results = [];
        // });
      }

      setState(() {
        _filteredList = results;
        results = [];
      });
      if (_filteredList.isEmpty && enteredKeyword.isNotEmpty) {
        unknownSearch = true;
      }
    });
  }

  Widget _headerItem({
    String? title,
    double? width = 100,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(width: 1.0, color: Colors.black12),
        ),
      ),
      width: width!,
      height: 40,
      child: Center(
        child: Text(
          title!,
          style: AppTheme.textStyleSmall,
        ),
      ),
    );
  }

  Widget _body() {
    return Scaffold(
      appBar: _appBar(),
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    decoration: headerDecoration,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _headerItem(title: 'Image', width: 120),
                        _headerItem(title: 'Order', width: 120),
                        _headerItem(title: 'Display Name', width: 150),
                        _headerItem(title: 'Vendor', width: 120),
                        _headerItem(title: 'Amount', width: 100),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  decoration: headerDecoration,
                  width: 200,
                  child: TextField(
                    onChanged: (value) => _runSearch(value),
                    decoration: const InputDecoration(
                      isDense: true,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black87),
                      ),

                      labelText: 'Search Perks',
                      labelStyle: TextStyle(color: Colors.black45),
                      //focusColor: Colors.black,
                      contentPadding: const EdgeInsets.all(4),

                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
              ],
            ),
            FutureBuilder<bool>(
              future: context.read<PerksProvider>().getAllPerks(),
              builder: (_, AsyncSnapshot<bool> snapshot) {
                print(snapshot.connectionState);
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    return unknownSearch
                        ? Center(child: Text('No Result Found!'))
                        : SizedBox(
                            height: 380,
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: _filteredList.isEmpty
                                  ? context
                                      .read<PerksProvider>()
                                      .perkList
                                      .length
                                  : _filteredList.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (_filteredList.isEmpty) {
                                  return perksCard(context,
                                      data: context
                                          .read<PerksProvider>()
                                          .perkList[index]);
                                }
                                return perksCard(context,
                                    data: _filteredList[index]);
                              },
                            ),
                          );

                  case ConnectionState.waiting:
                    return SizedBox(
                      height: 100,
                      child: Center(
                        child: CupertinoActivityIndicator(),
                      ),
                    );
                  default:
                    return SizedBox(
                      height: 100,
                      child: Center(
                        child: CupertinoActivityIndicator(),
                      ),
                    );
                }
              },
            ),
            SizedBox(
              height: 100,
            )
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 100,
        child: _footerWidget(),
      ),
    );
  }

  Widget _footerWidget() {
    return Container(
      padding: EdgeInsets.all(
        10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        color: AppTheme.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black26,
            // offset: Offset(2, 4),
            blurRadius: 3,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomButton(
            title: 'Create New Perk',
            width: 180,
            backgroundColor: AppTheme.themeColor,
            onClick: () async {
              context.read<PerksProvider>().resetFields();
              context.read<MenuProvider>().updateRoutes("/perks/edit_perk");
              Navigator.pushNamed(context, "/perks/edit_perk");
            },
          ),
        ],
      ),
    );
  }

  // Widget _loadPerkList() {
  //   return Container(
  //     child: Column(
  //       children: [
  //         _perkList(),
  //         SizedBox(height: 100),
  //       ],
  //     ),
  //   );
  // }

  // List<Widget> perks() {
  //   List<Widget> temp = [];
  //   context.read<PerksProvider>().perkList.forEach((element) {
  //     temp.add(perksCard(context, data: element));
  //   });
  //   return temp;
  // }

  // Widget _perkList() {
  //   return Padding(
  //     padding: EdgeInsets.only(right: 20),
  //     child: SingleChildScrollView(
  //       child: Column(
  //         children: perks(),
  //       ),
  //     ),
  //   );
  // }

  // Widget _perkList() {
  //   var mediaQueryWidth = MediaQuery.of(context).size.width;
  //   var mediaQueryHeight = MediaQuery.of(context).size.height;
  //   return Padding(
  //     padding: const EdgeInsets.all(15.0),
  //     child: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: GridView.builder(
  //         itemCount: context.read<PerksProvider>().perkList.length,
  //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //             childAspectRatio: mediaQueryWidth / (mediaQueryHeight / 1.9),
  //             crossAxisCount: 2),
  //         itemBuilder: (context, index) {
  //           return Padding(
  //             padding: const EdgeInsets.only(left: 10, top: 10),
  //             child: perksCard(context,
  //                 data: context.read<PerksProvider>().perkList[index]),
  //           );
  //         },
  //         padding: const EdgeInsets.all(8),
  //         shrinkWrap: true,
  //       ),
  //     ),
  //   );
  // }

  Widget _tileItem({
    String? title,
    double? width = 100,
  }) {
    return Container(
      width: width!,
      height: 40,
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Text(
                title!,
                textAlign: TextAlign.center,
                style: AppTheme.textStyleSmall,
              ),
            ),
          ),
          Container(
            width: 1,
            height: 30,
            color: Colors.black12,
          )
        ],
      ),
    );
  }

  Widget perksCard(BuildContext context, {required Perk data}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
      child: GestureDetector(
        onTap: () {
          dPrint('list bank');
          Navigator.pushNamed(context, "/perks/edit_perk", arguments: data);
        },
        child: Row(
          children: [
            Container(
              decoration: decoration,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 65,
                    width: 120,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            width: 99,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  data.imageUrl,
                                  // 'https://picsum.photos/200',
                                ),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 30,
                          color: Colors.black12,
                        )
                      ],
                    ),
                  ),
                  _tileItem(title: data.displayOrder.toString(), width: 120),
                  _tileItem(title: data.displayName, width: 150),
                  _tileItem(title: data.vendorName, width: 120),
                  _tileItem(title: data.amount.toString(), width: 100),
                  SizedBox(
                    width: 80,
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: IconButton(
                              icon: Icon(
                                Icons.delete_outline_sharp,
                                color: Colors.redAccent,
                                size: 20,
                              ),
                              onPressed: () {
                                showAlert(
                                    context: context,
                                    title: 'Alert',
                                    message: 'Do you want to delete this Perk?',
                                    buttonTitle: 'Yes',
                                    buttonWidth: 75,
                                    secondaryButtonTitle: 'No',
                                    action: () async {
                                      EasyLoading.show(status: 'Deleting Perk');

                                      await context
                                          .read<PerksProvider>()
                                          .deletePerk(data.id.toString());

                                      EasyLoading.dismiss();

                                      await context
                                          .read<PerksProvider>()
                                          .getAllPerks();
                                      setState(() {});
                                    });
                              },
                            ),
                          ),
                        ),
                        // Spacer(),
                        Container(
                          width: 1,
                          height: 30,
                          color: Colors.black12,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.blueAccent,
                        size: 20,
                      ),
                      onPressed: () {
                        context
                            .read<MenuProvider>()
                            .updateRoutes("/perks/edit_perk");
                        Navigator.pushNamed(context, "/perks/edit_perk",
                            arguments: data);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: IconButton(
                      icon: Icon(
                        Icons.sim_card_download_rounded,
                        color: Colors.green,
                        size: 20,
                      ),
                      onPressed: () async {
                        _apiRepository.getLocation(data.id.toString());
                      },
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: IconButton(
                      icon: Icon(
                        Icons.upload_file_rounded,
                        color: Colors.amber,
                        size: 20,
                      ),
                      onPressed: () {
                        _openFileExplorer(data.id.toString());
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 20),
      child: GestureDetector(
        onTap: () {
          dPrint('list bank');
          Navigator.pushNamed(context, "/perks/edit_perk", arguments: data
              // MaterialPageRoute(
              //   builder: (context) => EditPerksScreen(
              //     perk: data,
              //   ),
              // ),
              );
        },
        child: Container(
          width: 400,
          decoration: decoration,
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 55,
                    width: 55,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            data.imageUrl,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4),
                      child: Text(
                        data.displayName,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        data.vendorName,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline_sharp,
                      color: Colors.black87,
                      size: 20,
                    ),
                    onPressed: () {
                      showAlert(
                          context: context,
                          title: 'Alert',
                          message: 'Do you want to delete this Perk?',
                          buttonTitle: 'Ok',
                          buttonWidth: 75,
                          action: () async {
                            EasyLoading.show(status: 'Deleting Perk');

                            await context
                                .read<PerksProvider>()
                                .deletePerk(data.id.toString());

                            EasyLoading.dismiss();

                            await context.read<PerksProvider>().getAllPerks();
                            setState(() {});
                          });
                    },
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Colors.black26,
                    size: 12,
                  )
                ],
              ),
              //Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
