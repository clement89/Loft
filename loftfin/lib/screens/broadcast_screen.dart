import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loftfin/models/api_response.dart';
import 'package:loftfin/networking/api_repository.dart';
import 'package:loftfin/services/log_service.dart';
import 'package:loftfin/style/app_theme.dart';
import 'package:loftfin/widgets/custom_appbar.dart';
import 'package:loftfin/widgets/custom_button.dart';

import '../widgets/outline_textdield.dart';

class BroadcastScreen extends StatefulWidget {
  static String routeName = "/broadcast";
  final String? routeInfo;
  BroadcastScreen({Key? key, this.routeInfo}) : super(key: key);

  @override
  _BroadcastScreen createState() => _BroadcastScreen();
}

class _BroadcastScreen extends State<BroadcastScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController titleTEC = TextEditingController();
  TextEditingController messageTEC = TextEditingController();
  bool titleError = false;
  bool messageError = false;
  FocusNode? title;
  FocusNode? message;
  Timer? _debounceFilterData;
  Uint8List webImage = Uint8List(10);
  File? _file;
  String? fileName = "";
  bool isRefreshing = false;
  double imageSize = 80;

  ApiRepository _apiRepository = ApiRepository();

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
    title = FocusNode();
    message = FocusNode();
  }

  // @override
  // void dispose() {
  //   // title!.dispose();
  //   // message!.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
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
        title: "Notifications",
        trailing: Offstage());
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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: _appBar(),
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container(
            //   alignment: Alignment.centerLeft,
            //   padding: const EdgeInsets.all(20.0),
            //   child: InkWell(
            //     onTap: () async {
            //       try {
            //         final ImagePicker _picker = ImagePicker();
            //         XFile? image =
            //             await _picker.pickImage(source: ImageSource.gallery);
            //         if (image != null) {
            //           String fileName = image.name.replaceAll(" ", "");
            //           Uint8List f = await image.readAsBytes();
            //           setState(
            //             () {
            //               _file = File('image');
            //               dPrint('success..........  $_file');
            //               _apiRepository.uploadPerkImage(
            //                 f,
            //                 fileName,
            //                 (String imageName) {
            //                   dPrint('Got image name - $imageName');
            //                   this.setState(() {
            //                     fileName = imageName;
            //                   });
            //                 },
            //               );
            //               webImage = f;
            //             },
            //           );
            //         } else {
            //           dPrint('fail..........');
            //           // showToast("No file selected");
            //         }
            //       } catch (e) {
            //         dPrint('fail..........$e');

            //         setState(() {});
            //       }
            //     },
            //     child: Container(
            //       alignment: Alignment.center,
            //       width: imageSize,
            //       height: imageSize,
            //       decoration: BoxDecoration(
            //         color: Colors.white,
            //         border: Border.all(
            //           color: Colors.black12, // Set border color
            //           width: 3.0,
            //         ), // Set border width
            //         borderRadius: BorderRadius.all(
            //           Radius.circular(
            //             10.0,
            //           ),
            //         ), // Set rounded corner radius
            //         boxShadow: [
            //           BoxShadow(
            //             blurRadius: 10,
            //             color: Colors.black26,
            //             offset: Offset(1, 3),
            //           )
            //         ], // Make rounded corner of border
            //       ),
            //       child: (_file != null)
            //           ? SizedBox(
            //               height: imageSize,
            //               width: imageSize,
            //               child: Image.memory(
            //                 webImage,
            //                 fit: BoxFit.contain,
            //               ),
            //             )
            //           : Icon(
            //               Icons.photo_library_sharp,
            //               size: 50,
            //               color: Colors.black54,
            //             ),
            //     ),
            //   ),
            // ),
            Form(
              key: _formKey,
              child: Wrap(
                alignment: WrapAlignment.start,
                direction: Axis.vertical,
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: OutlineTextField(
                      title: 'Title',
                      isError: titleError,
                      keyboardType: TextInputType.text,
                      controller: titleTEC,
                      focusNode: title,
                      nextFocusNode: message,
                      defaultValue: '',
                      type: TextType.text,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: OutlineTextField(
                      isMultiline: true,
                      title: 'Message',
                      isError: messageError,
                      keyboardType: TextInputType.text,
                      controller: messageTEC,
                      focusNode: message,
                      defaultValue: '',
                      type: TextType.text,
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.all(20),
                  //   child: OutlineTextField(
                  //     title: 'Schedule Date',
                  //     isError: false,
                  //     keyboardType: TextInputType.text,
                  //     controller: context.read<BroadcastProvider>().scheduleDate,
                  //     focusNode: startDate,
                  //     defaultValue: '',
                  //     type: TextType.date,
                  //     // onChangeAction: onChangeAction,
                  //     // validator: dateCheck,
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: size.height * AppTheme.footerHeight,
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
            title: "Broadcast Push",
            width: 220,
            backgroundColor: AppTheme.themeColor,
            onClick: () async {
              if (titleTEC.text.length < 1) {
                titleError = true;
              }

              if (messageTEC.text.length < 1) {
                messageError = true;
              }
              this.setState(() {});
              if (!messageError && !titleError) {
                EasyLoading.show(status: "Broadcasting");
                ApiResponse res = await _apiRepository.broadcastPush(
                  titleTEC.text,
                  messageTEC.text,
                  '',
                );
                EasyLoading.dismiss();
                if (res.isError) {
                  EasyLoading.showError('Failed');
                } else {
                  EasyLoading.showSuccess('Success');
                }
              }
            },
          ),
          SizedBox(width: 30),
          CustomButton(
            title: "Broadcast Email",
            width: 220,
            backgroundColor: AppTheme.themeColor,
            onClick: () async {
              if (titleTEC.text.length < 1) {
                titleError = true;
              }

              if (messageTEC.text.length < 1) {
                messageError = true;
              }
              this.setState(() {});
              if (!messageError && !titleError) {
                EasyLoading.show(status: "Broadcasting Email...");

                dPrint('ss --- ${messageTEC.text}');
                ApiResponse res = await _apiRepository.broadcastEmail(
                  titleTEC.text,
                  messageTEC.text,
                  '',
                );
                EasyLoading.dismiss();
                if (res.isError) {
                  EasyLoading.showError('Failed');
                } else {
                  EasyLoading.showSuccess('Success');
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
