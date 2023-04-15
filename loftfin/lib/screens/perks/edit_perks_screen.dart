import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loftfin/models/api_response.dart';
import 'package:loftfin/models/perk.dart';
import 'package:loftfin/networking/api_repository.dart';
import 'package:loftfin/providers/perk_provider.dart';
import 'package:loftfin/services/log_service.dart';
import 'package:loftfin/strings.dart';
import 'package:loftfin/style/app_theme.dart';
import 'package:loftfin/widgets/custom_appbar.dart';
import 'package:loftfin/widgets/custom_button.dart';
import 'package:loftfin/widgets/outline_textdield.dart';
import 'package:provider/provider.dart';

class EditPerksScreen extends StatefulWidget {
  static String routeName = "perks/edit_perk";

  final Perk? perk;

  const EditPerksScreen({
    this.perk,
    Key? key,
  }) : super(key: key);

  @override
  _EditPerksScreenState createState() => _EditPerksScreenState();
}

class _EditPerksScreenState extends State<EditPerksScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  FocusNode? vendorWebsite;
  FocusNode? vendorName;
  FocusNode? perkAmount;
  FocusNode? count;
  FocusNode? startDate;
  FocusNode? endDate;
  FocusNode? order;
  FocusNode? transactionKeywords;

  Uint8List webImage = Uint8List(10);
  File? _file;

  bool isEditing = false;
  bool uploading = false;
  bool uploadError = false;
  Decoration decoration = BoxDecoration(
    color: Colors.white,
    border: Border(
      bottom: BorderSide(color: AppTheme.viewBackground),
    ),
  );

  @override
  void dispose() {
    vendorWebsite!.dispose();
    vendorName!.dispose();
    perkAmount!.dispose();
    count!.dispose();
    startDate!.dispose();
    endDate!.dispose();
    order!.dispose();
    transactionKeywords!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    if (widget.perk != null) {
      context
          .read<PerksProvider>()
          .updateImageUrl(isUrl: true, image: widget.perk!.imageUrl);
    }
    // final arg = ModalRoute.of(context)!.settings.arguments;
    // if (arg != null) {
    //   // widget.perk = arg;
    // }

    vendorWebsite = FocusNode();
    vendorName = FocusNode();
    perkAmount = FocusNode();
    count = FocusNode();
    startDate = FocusNode();
    endDate = FocusNode();
    order = FocusNode();
    transactionKeywords = FocusNode();
    super.initState();
  }

  double padding = 10;
  double imageSize = 80;

  ApiRepository _apiRepository = ApiRepository();

  // List<FieldItem> getFieldItems(List<Map<String, dynamic>> items) {
  //   List<FieldItem> temp = [];
  //   items.forEach((element) {
  //     temp.add(FieldItem.fromMap(element));
  //   });
  //   return temp;
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          // LoftMenu(),
          Expanded(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Scaffold(
                key: _scaffoldKey,
                //drawer: LoftMenu(),
                // bottomNavigationBar: SizedBox(
                //   height: size.height * AppTheme.footerHeight,
                //   child: _footerWidget(),
                // ),
                backgroundColor: Colors.white,
                appBar: _appBar(),
                body: Wrap(
                  children: [
                    // SizedBox(
                    //   height: size.height * 0.030,
                    // ),
                    // Center(
                    //   child: Container(
                    //     height: 100,
                    //     width: 100,
                    //     decoration: BoxDecoration(
                    //       image: DecorationImage(
                    //         image: AssetImage(
                    //           'assets/images/referal_friend.png',
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: size.height * 0.050,
                    // ),
                    // Text(kStringsReferalFriend),
                    // Center(child: Text(kStringsReferalFriend1)),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: InkWell(
                                onTap: () async {
                                  try {
                                    final ImagePicker _picker = ImagePicker();
                                    XFile? image = await _picker.pickImage(
                                        source: ImageSource.gallery);
                                    if (image != null) {
                                      String fileName =
                                          image.name.replaceAll(" ", "");
                                      Uint8List f = await image.readAsBytes();
                                      _file = File('image');
                                      dPrint('success..........  $_file');
                                      setState(() {
                                        uploading = true;
                                      });
                                      ApiResponse res =
                                          await _apiRepository.uploadPerkImage(
                                        f,
                                        fileName,
                                        (String imageName) {
                                          dPrint('Got image name - $imageName');
                                          context
                                              .read<PerksProvider>()
                                              .updateImageUrl(
                                                  isUrl: false,
                                                  image: imageName);
                                        },
                                      );
                                      setState(() {
                                        webImage = f;
                                        uploading = false;
                                      });
                                      if (res.isError) {
                                        setState(() {
                                          uploadError = true;
                                        });
                                      } else {
                                        setState(() {
                                          uploadError = false;
                                        });
                                      }
                                    } else {
                                      dPrint('fail..........');
                                      setState(() {
                                        uploadError = true;
                                      });
                                      // showToast("No file selected");
                                    }
                                  } catch (e) {
                                    dPrint('fail..........$e');
                                    setState(() {
                                      uploadError = true;
                                    });
                                  }
                                },
                                child: uploading
                                    ? CircularProgressIndicator()
                                    : Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Colors
                                                .black12, // Set border color
                                            width: 3.0,
                                          ), // Set border width
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(
                                              10.0,
                                            ),
                                          ), // Set rounded corner radius
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 10,
                                              color: Colors.black26,
                                              offset: Offset(1, 3),
                                            )
                                          ], // Make rounded corner of border
                                        ),
                                        child: (_file != null)
                                            ? SizedBox(
                                                height: imageSize,
                                                width: imageSize,
                                                child: Image.memory(
                                                  webImage,
                                                  fit: BoxFit.contain,
                                                ),
                                              )
                                            : widget.perk != null
                                                ? SizedBox(
                                                    height: imageSize,
                                                    width: imageSize,
                                                    child: Image.network(
                                                      widget.perk!.imageUrl,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  )
                                                : Icon(
                                                    Icons.photo_library_sharp,
                                                    size: 50,
                                                    color: Colors.black54,
                                                  ),
                                      ),
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.all(20.0),
                            //   child: Semantics(
                            //     label: 'image_picker_example_from_gallery',
                            //     child: FloatingActionButton(
                            //       onPressed: () async {
                            //         try {
                            //           final ImagePicker _picker = ImagePicker();
                            //           XFile? image = await _picker.pickImage(
                            //               source: ImageSource.gallery);
                            //           if (image != null) {
                            //             var f = await image.readAsBytes();
                            //             setState(() {
                            //               _file = File([image], 'image');
                            //               dPrint('success..........');
                            //               webImage = f;
                            //             });
                            //           } else {
                            //             dPrint('fail..........');
                            //
                            //             // showToast("No file selected");
                            //           }
                            //         } catch (e) {
                            //           dPrint('fail..........');
                            //
                            //           setState(() {
                            //             _pickImageError = e;
                            //           });
                            //         }
                            //       },
                            //       heroTag: 'image0',
                            //       tooltip: 'Pick Image from gallery',
                            //       child: const Icon(Icons.photo),
                            //     ),
                            //   ),
                            // ),
                            if (uploadError) ...[
                              Text(
                                'Image upload error',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ],
                            Spacer(),
                            CustomButton(
                              isEnabled:
                                  context.watch<PerksProvider>().isUpdating,
                              title: widget.perk != null ? 'Update' : 'Save',
                              width: 110,
                              backgroundColor: AppTheme.themeColor,
                              onClick: () async {
                                final provider = Provider.of<PerksProvider>(
                                    context,
                                    listen: false);
                                if (!provider.checkValidate()) {
                                  return;
                                }

                                EasyLoading.show(
                                  status: widget.perk != null
                                      ? 'Updating Perks'
                                      : 'Creating Perk',
                                );

                                String id = widget.perk != null
                                    ? widget.perk!.id.toString()
                                    : '';
                                bool status;
                                if (id.isEmpty) {
                                  status = await provider.createPerk();
                                } else {
                                  status = await provider.updatePerk(id);
                                }

                                EasyLoading.dismiss();

                                if (status) {
                                  EasyLoading.showSuccess('Success');
                                  await provider.refreshPerkList().whenComplete(
                                      () => Navigator.of(context)
                                          .pushNamed("/perks"));
                                } else {
                                  EasyLoading.showError('Failed');
                                }
                              },
                            ),
                            SizedBox(width: 20),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(
                                context.watch<PerksProvider>().imageError
                                    ? 'Please Select an image!'
                                    : '',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // EditListView(fieldList: getFieldItems(items)),
                    Form(
                      key: _formKey,
                      child: Wrap(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(padding),
                            child: OutlineTextField(
                              title: 'Display Name',
                              isError:
                                  context.watch<PerksProvider>().isNameError,
                              controller:
                                  context.read<PerksProvider>().displayName,
                              keyboardType: TextInputType.text,
                              nextFocusNode: vendorName,
                              defaultValue: widget.perk != null
                                  ? widget.perk!.displayName
                                  : '',
                              type: TextType.text,
                              onChangeAction: onChangeAction,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(padding),
                            child: OutlineTextField(
                              title: 'Vendor Name',
                              isError: context
                                  .watch<PerksProvider>()
                                  .vendorNameError,
                              keyboardType: TextInputType.text,
                              controller:
                                  context.read<PerksProvider>().vendorName,
                              focusNode: vendorName,
                              nextFocusNode: vendorWebsite,
                              defaultValue: widget.perk != null
                                  ? widget.perk!.vendorName
                                  : '',
                              type: TextType.text,
                              onChangeAction: onChangeAction,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(padding),
                            child: OutlineTextField(
                              title: 'Vendor Website',
                              isError:
                                  context.watch<PerksProvider>().isWebsiteError,
                              keyboardType: TextInputType.text,
                              controller:
                                  context.read<PerksProvider>().vendorWebsite,
                              focusNode: vendorWebsite,
                              nextFocusNode: perkAmount,
                              defaultValue: widget.perk != null
                                  ? widget.perk!.vendorWebsite
                                  : '',
                              type: TextType.text,
                              onChangeAction: onChangeAction,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(padding),
                            child: OutlineTextField(
                              title: 'Perk Amount',
                              isError: context
                                  .watch<PerksProvider>()
                                  .perkAmountError,
                              keyboardType: TextInputType.text,
                              controller:
                                  context.read<PerksProvider>().perkAmount,
                              focusNode: perkAmount,
                              nextFocusNode: startDate,
                              defaultValue: widget.perk != null
                                  ? widget.perk!.amount.toString()
                                  : '',
                              type: TextType.text,
                              validator: isNumeric,
                              onChangeAction: onChangeAction,
                            ),
                          ),
                          // Padding(
                          //   padding: EdgeInsets.all(padding),
                          //   child: OutlineTextField(
                          //     title: 'Count',
                          //     isError:
                          //         context.watch<PerksProvider>().countError,
                          //     keyboardType: TextInputType.text,
                          //     controller: context.read<PerksProvider>().count,
                          //     focusNode: count,
                          //     nextFocusNode: startDate,
                          //     defaultValue: widget.perk != null
                          //         ? widget.perk!.count.toString()
                          //         : '',
                          //     type: TextType.text,
                          //     validator: isNumeric,
                          //     onChangeAction: onChangeAction,
                          //   ),
                          // ),
                          Padding(
                            padding: EdgeInsets.all(padding),
                            child: OutlineTextField(
                              title: 'Start Date',
                              isError:
                                  context.watch<PerksProvider>().startDateError,
                              keyboardType: TextInputType.text,
                              controller:
                                  context.read<PerksProvider>().startDate,
                              focusNode: startDate,
                              nextFocusNode: endDate,
                              defaultValue: widget.perk != null
                                  ? widget.perk!.startDate
                                  : '',
                              type: TextType.date,
                              onChangeAction: onChangeAction,
                              validator: dateCheck,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(padding),
                            child: OutlineTextField(
                              title: 'End Date',
                              isError:
                                  context.watch<PerksProvider>().enDateError,
                              keyboardType: TextInputType.text,
                              controller: context.read<PerksProvider>().endDate,
                              focusNode: endDate,
                              nextFocusNode: order,
                              defaultValue: widget.perk != null
                                  ? widget.perk!.endDate
                                  : '',
                              type: TextType.date,
                              onChangeAction: onChangeAction,
                              validator: dateCheck,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(padding),
                            child: OutlineTextField(
                              title: 'Display Order',
                              isError:
                                  context.watch<PerksProvider>().orderError,
                              keyboardType: TextInputType.text,
                              controller: context.read<PerksProvider>().order,
                              focusNode: order,
                              nextFocusNode: transactionKeywords,
                              defaultValue: widget.perk != null
                                  ? widget.perk!.displayOrder.toString()
                                  : '',
                              type: TextType.text,
                              validator: isNumeric,
                              onChangeAction: onChangeAction,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(padding),
                            child: OutlineTextField(
                              isMultiline: true,
                              title: 'Transaction Keywords',
                              isError: context
                                  .watch<PerksProvider>()
                                  .transactionKeywordsError,
                              keyboardType: TextInputType.text,
                              controller: context
                                  .read<PerksProvider>()
                                  .transactionKeywords,
                              focusNode: transactionKeywords,
                              defaultValue: widget.perk != null
                                  ? context
                                      .read<PerksProvider>()
                                      .getTransactionKeywords(
                                          widget.perk!.transactionKeywords)
                                  : '',
                              type: TextType.text,
                              onChangeAction: onChangeAction,
                              info:
                                  'Transaction Keywords should be separated by commas.',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onChangeAction(String value) {
    context.read<PerksProvider>().setUpdating();
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

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

  bool isSameDate(DateTime other) {
    final now = DateTime.now();
    return now.year == other.year &&
        now.month == other.month &&
        now.day == other.day;
  }

  PreferredSizeWidget _appBar() {
    return CustomAppBar(
      title: widget.perk != null ? 'Edit Perks' : 'Create Perk',
      leading: true
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: AppTheme.blue,
              ),
              onPressed: () {
                // Navigator.pop(context);
              },
            )
          : Offstage(),
      trailing: isEditing
          ? TextButton(
              style: TextButton.styleFrom(
                textStyle: AppTheme.textStyleSmall,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                kStringsCancel,
                style: AppTheme.textStyleSmall,
              ),
            )
          : Container(),
    );
  }

// Widget _footerWidget() {
//   return Container(
//     padding: EdgeInsets.all(
//       10,
//     ),
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(10),
//       color: AppTheme.white,
//       boxShadow: <BoxShadow>[
//         BoxShadow(
//           color: Colors.black26,
//           // offset: Offset(2, 4),
//           blurRadius: 3,
//           spreadRadius: 0,
//         ),
//       ],
//     ),
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         CustomButton(
//           title: kStringsSave,
//           width: 100,
//           backgroundColor: AppTheme.themeColor,
//           onClick: () async {
//             final provider =
//                 Provider.of<PerksProvider>(context, listen: false);
//             if (!provider.checkValidate()) {
//               return;
//             }
//
//             EasyLoading.show(
//               status:
//                   widget.perk != null ? 'Updating Perks' : 'Creating Perk',
//             );
//
//             String id = widget.perk != null ? widget.perk!.id.toString() : '';
//             bool status;
//             if (id.isEmpty) {
//               status = await provider.createPerk();
//             } else {
//               status = await provider.updatePerk(id);
//             }
//
//             EasyLoading.dismiss();
//
//             if (status) {
//               EasyLoading.showSuccess('Success');
//             } else {
//               EasyLoading.showError('Failed');
//             }
//           },
//         ),
//       ],
//     ),
//   );
// }
}
