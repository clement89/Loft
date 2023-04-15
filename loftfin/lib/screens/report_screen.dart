import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loftfin/networking/api_repository.dart';
import 'package:loftfin/providers/feedback_provider.dart';
import 'package:loftfin/style/app_theme.dart';
import 'package:loftfin/widgets/custom_appbar.dart';
import 'package:loftfin/widgets/outline_textdield.dart';
import 'package:provider/provider.dart';

class ReportScreen extends StatefulWidget {
  static String routeName = "/reports";
  final String? routeInfo;
  ReportScreen({Key? key, this.routeInfo}) : super(key: key);

  @override
  _ReportScreen createState() => _ReportScreen();
}

class _ReportScreen extends State<ReportScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode? title;
  FocusNode? message;
  Timer? _debounceFilterData;
  Uint8List webImage = Uint8List(10);
  File? _file;

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
        title: "Reports",
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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: _appBar(),
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            _reportCard(
              reportName: 'Download Reward Reports',
              downloadAction: () async {
                _apiRepository.getReports();
              },
            ),
            // Padding(
            //   padding: EdgeInsets.all(20),
            //   child: CustomButton(
            //     title: "Download Reward Reports",
            //     width: 270,
            //     backgroundColor: AppTheme.themeColor,
            //     onClick: () async {
            //       _apiRepository.getReports();
            //     },
            //   ),
            // ),
            _reportCard(
              reportName: 'Download Loan Reports',
              downloadAction: () async {
                _apiRepository.getLoanReports();
              },
            ),
            _reportCard(
              reportName: 'Download Usage Reports',
              downloadAction: () async {
                _apiRepository.getUsageReports();
              },
            ),
            // Padding(
            //   padding: EdgeInsets.all(20),
            //   child: CustomButton(
            //     title: "Download Usage Reports",
            //     width: 270,
            //     backgroundColor: AppTheme.themeColor,
            //     onClick: () async {
            //       _apiRepository.getUsageReports();
            //     },
            //   ),
            // ),
            _reportCard(
              reportName: 'Feedback Report',
              downloadAction: () async {
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
              startDate: Padding(
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
              endDate: Padding(
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
            ),
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   mainAxisSize: MainAxisSize.min,
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.symmetric(vertical: 10),
            //       child: Align(
            //         alignment: Alignment.center,
            //         child: Text(
            //           'Feedback Report',
            //           style: TextStyle(color: Colors.black),
            //         ),
            //       ),
            //     ),
            //     Wrap(
            //       children: [
            //         Padding(
            //           padding: EdgeInsets.all(padding),
            //           child: OutlineTextField(
            //             title: 'Start Date',
            //             isError:
            //                 context.watch<ReportsProvider>().startDateError,
            //             keyboardType: TextInputType.text,
            //             controller: context.read<ReportsProvider>().startDate,
            //             nextFocusNode: endDate,
            //             defaultValue: '',
            //             type: TextType.date,
            //             validator: dateCheck,
            //           ),
            //         ),
            //         Padding(
            //           padding: EdgeInsets.all(padding),
            //           child: OutlineTextField(
            //             title: 'End Date',
            //             isError: context.watch<ReportsProvider>().enDateError,
            //             keyboardType: TextInputType.text,
            //             controller: context.read<ReportsProvider>().endDate,
            //             focusNode: endDate,
            //             defaultValue: '',
            //             type: TextType.date,
            //             validator: dateCheck,
            //           ),
            //         ),
            //       ],
            //     ),
            //     Padding(
            //       padding: EdgeInsets.all(20),
            //       child: CustomButton(
            //         title: "Download Feedback Reports",
            //         width: 250,
            //         backgroundColor: AppTheme.themeColor,
            //         onClick: () async {
            //           final provider =
            //               Provider.of<ReportsProvider>(context, listen: false);
            //           if (!provider.checkValidate()) {
            //             return;
            //           }
            //
            //           EasyLoading.show(
            //             status: 'Downloading report..',
            //           );
            //
            //           await provider.getFeedbackReport();
            //
            //           EasyLoading.dismiss();
            //           EasyLoading.showSuccess('Success');
            //         },
            //       ),
            //     ),
            //   ],
            // ),

            _reportCard(
              reportName: 'Kard Impression Report',
              downloadAction: () async {
                final provider =
                    Provider.of<ReportsProvider>(context, listen: false);
                if (!provider.kardCheckValidate()) {
                  return;
                }

                EasyLoading.show(
                  status: 'Downloading report..',
                );

                await provider.getKardReport();

                EasyLoading.dismiss();
                EasyLoading.showSuccess('Success');
              },
              startDate: Padding(
                padding: EdgeInsets.all(padding),
                child: OutlineTextField(
                  title: 'Start Date',
                  isError: context.watch<ReportsProvider>().kardStartDateError,
                  keyboardType: TextInputType.text,
                  controller: context.read<ReportsProvider>().kardStartDate,
                  nextFocusNode: endDate,
                  defaultValue: '',
                  type: TextType.date,
                  validator: dateCheck,
                ),
              ),
              endDate: Padding(
                padding: EdgeInsets.all(padding),
                child: OutlineTextField(
                  title: 'End Date',
                  isError: context.watch<ReportsProvider>().kardEndDateError,
                  keyboardType: TextInputType.text,
                  controller: context.read<ReportsProvider>().kardEndDate,
                  focusNode: endDate,
                  defaultValue: '',
                  type: TextType.date,
                  validator: dateCheck,
                ),
              ),
            ),
            _reportCard(
              reportName: 'User Access Report',
              downloadAction: () async {
                final provider =
                    Provider.of<ReportsProvider>(context, listen: false);
                if (!provider.accessCheckValidate()) {
                  return;
                }

                EasyLoading.show(
                  status: 'Downloading report..',
                );

                await provider.getAccessReport();

                EasyLoading.dismiss();
                EasyLoading.showSuccess('Success');
              },
              startDate: Padding(
                padding: EdgeInsets.all(padding),
                child: OutlineTextField(
                  title: 'Start Date',
                  isError:
                      context.watch<ReportsProvider>().accessStartDateError,
                  keyboardType: TextInputType.text,
                  controller: context.read<ReportsProvider>().accessStartDate,
                  nextFocusNode: endDate,
                  defaultValue: '',
                  type: TextType.date,
                  validator: dateCheck,
                ),
              ),
              endDate: Padding(
                padding: EdgeInsets.all(padding),
                child: OutlineTextField(
                  title: 'End Date',
                  isError: context.watch<ReportsProvider>().accessEndDateError,
                  keyboardType: TextInputType.text,
                  controller: context.read<ReportsProvider>().accessEndDate,
                  focusNode: endDate,
                  defaultValue: '',
                  type: TextType.date,
                  validator: dateCheck,
                ),
              ),
            ),

            // Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   mainAxisSize: MainAxisSize.min,
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.symmetric(vertical: 10),
            //       child: Align(
            //         alignment: Alignment.center,
            //         child: Text(
            //           'Kard Impression Report',
            //           style: TextStyle(color: Colors.black),
            //         ),
            //       ),
            //     ),
            //     Wrap(
            //       children: [
            //         Padding(
            //           padding: EdgeInsets.all(padding),
            //           child: OutlineTextField(
            //             title: 'Start Date',
            //             isError:
            //                 context.watch<ReportsProvider>().kardStartDateError,
            //             keyboardType: TextInputType.text,
            //             controller:
            //                 context.read<ReportsProvider>().kardStartDate,
            //             nextFocusNode: endDate,
            //             defaultValue: '',
            //             type: TextType.date,
            //             validator: dateCheck,
            //           ),
            //         ),
            //         Padding(
            //           padding: EdgeInsets.all(padding),
            //           child: OutlineTextField(
            //             title: 'End Date',
            //             isError:
            //                 context.watch<ReportsProvider>().kardEndDateError,
            //             keyboardType: TextInputType.text,
            //             controller: context.read<ReportsProvider>().kardEndDate,
            //             focusNode: endDate,
            //             defaultValue: '',
            //             type: TextType.date,
            //             validator: dateCheck,
            //           ),
            //         ),
            //       ],
            //     ),
            //     Padding(
            //       padding: EdgeInsets.all(20),
            //       child: CustomButton(
            //         title: "Download Kard Impression Reports",
            //         width: 300,
            //         backgroundColor: AppTheme.themeColor,
            //         onClick: () async {
            //           final provider =
            //               Provider.of<ReportsProvider>(context, listen: false);
            //           if (!provider.kardCheckValidate()) {
            //             return;
            //           }
            //
            //           EasyLoading.show(
            //             status: 'Downloading report..',
            //           );
            //
            //           await provider.getKardReport();
            //
            //           EasyLoading.dismiss();
            //           EasyLoading.showSuccess('Success');
            //         },
            //       ),
            //     ),
            //   ],
            // ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

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
        ],
      ),
    );
  }

  Widget _reportCard({
    required String reportName,
    required Function downloadAction,
    Widget? startDate,
    Widget? endDate,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
      child: Row(
        children: [
          Container(
            decoration: decoration,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _tileItem(title: reportName, width: 200),
                  startDate != null ? startDate : SizedBox.shrink(),
                  endDate != null ? endDate : SizedBox.shrink(),
                  Container(
                    width: 1,
                    height: 30,
                    color: Colors.black12,
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
                        await downloadAction();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
