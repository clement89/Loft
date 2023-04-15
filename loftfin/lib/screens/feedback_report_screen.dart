import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loftfin/networking/api_repository.dart';
import 'package:loftfin/providers/feedback_provider.dart';
import 'package:loftfin/style/app_theme.dart';
import 'package:loftfin/widgets/custom_appbar.dart';
import 'package:loftfin/widgets/custom_button.dart';
import 'package:loftfin/widgets/outline_textdield.dart';
import 'package:provider/provider.dart';

class FeedbackReportScreen extends StatefulWidget {
  static String routeName = "/feedback_reports";
  final String? routeInfo;
  FeedbackReportScreen({Key? key, this.routeInfo}) : super(key: key);

  @override
  _ReportScreen createState() => _ReportScreen();
}

class _ReportScreen extends State<FeedbackReportScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode? title;
  FocusNode? message;
  Uint8List webImage = Uint8List(10);
  // File? _file;

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
        title: "Feedback Report",
        trailing: Offstage());
  }

  double padding = 10;
  FocusNode endDate = FocusNode();
  bool dateCheck(String s) {
    return true;
    // if (s == null) {
    //   return false;
    // }
    // final startDt = DateTime.parse(s);
    // final now = DateTime.now();

    // if (startDt.compareTo(now) >= 0 || isSameDate(startDt)) {
    //   return true;
    // } else {
    //   return false;
    // }
  }

  Widget _body() {
    return Scaffold(
      appBar: _appBar(),
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 90),
            Wrap(
              children: [
                Padding(
                  padding: EdgeInsets.all(padding),
                  child: OutlineTextField(
                    title: 'Start Date',
                    isError: context.watch<ReportsProvider>().startDateError,
                    keyboardType: TextInputType.text,
                    controller: context.read<ReportsProvider>().startDate,
                    nextFocusNode: endDate,
                    defaultValue: '',
                    type: TextType.date,
                    validator: dateCheck,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(padding),
                  child: OutlineTextField(
                    title: 'End Date',
                    isError: context.watch<ReportsProvider>().enDateError,
                    keyboardType: TextInputType.text,
                    controller: context.read<ReportsProvider>().endDate,
                    focusNode: endDate,
                    defaultValue: '',
                    type: TextType.date,
                    validator: dateCheck,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: CustomButton(
                title: "Download Reports",
                width: 220,
                backgroundColor: AppTheme.themeColor,
                onClick: () async {
                  final provider =
                      Provider.of<ReportsProvider>(context, listen: false);
                  if (!provider.checkValidate()) {
                    return;
                  }

                  EasyLoading.show(
                    status: 'Downloading report..',
                  );

                  await provider.getFeedbackReport();

                  EasyLoading.dismiss();
                  EasyLoading.showSuccess('Success');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
