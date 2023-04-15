// import 'package:flutter/cupertino.dart';
// import 'package:loftfin/models/field_item.dart';
//
// import 'outline_textdield.dart';
//
// class EditListView extends StatefulWidget {
//   final List<FieldItem> fieldList;
//   const EditListView({
//     required this.fieldList,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   _EditListViewState createState() => _EditListViewState();
// }
//
// class _EditListViewState extends State<EditListView> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }
//
//   TextEditingController controller = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
//
//   List<Widget> getListItems() {
//     List<Widget> items = [];
//     widget.fieldList.forEach((element) {
//       items.add(
//         Padding(
//           padding: const EdgeInsets.all(20),
//           child: OutlineTextField(
//             title: element.displayName,
//             isError: false,
//             controller: controller,
//             keyboardType: TextInputType.name,
//             focusNode: null,
//             nextFocusNode: null,
//             defaultValue: '',
//             updateAction: updateAction,
//             fieldName: element.fieldName,
//           ),
//         ),
//       );
//     });
//
//     return items;
//   }
//
//   Map<String, dynamic> paramsDict = <String, dynamic>{};
//
//   void updateAction(String key, String value) {
//     paramsDict[key] = value;
//   }
// }
