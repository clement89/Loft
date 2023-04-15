import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loftfin/models/waitliast_rule.dart';
import 'package:loftfin/providers/settings_provider.dart';
import 'package:provider/provider.dart';

import 'outline_textdield.dart';

class WaitListWidget extends StatefulWidget {
  final WaitList? waitList;
  const WaitListWidget({
    this.waitList,
    Key? key,
  }) : super(key: key);

  @override
  _WaitListWidgetState createState() => _WaitListWidgetState();
}

class _WaitListWidgetState extends State<WaitListWidget> {
  FocusNode? end;
  FocusNode? perkCount;
  final TextEditingController startController = TextEditingController();
  final TextEditingController endController = TextEditingController();
  final TextEditingController countController = TextEditingController();
  bool isSubmitted = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blue.withOpacity(0.1),
              // boxShadow: <BoxShadow>[
              //   BoxShadow(
              //     color: Colors.blue.shade50,
              //     blurRadius: 3,
              //     spreadRadius: 0,
              //   ),
              // ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: OutlineTextField(
                        title: 'Rank From',
                        isError: (isSubmitted && startController.text.isEmpty)
                            ? true
                            : false,
                        keyboardType: TextInputType.name,
                        controller: startController,
                        nextFocusNode: end,
                        defaultValue: widget.waitList != null
                            ? widget.waitList!.start
                            : '',
                        type: TextType.text,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: OutlineTextField(
                        title: 'Rank To',
                        isError: (isSubmitted && endController.text.isEmpty)
                            ? true
                            : false,
                        keyboardType: TextInputType.name,
                        controller: endController,
                        focusNode: end,
                        nextFocusNode: perkCount,
                        defaultValue:
                            widget.waitList != null ? widget.waitList!.end : '',
                        type: TextType.text,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: OutlineTextField(
                        title: 'Perk Count',
                        isError: (isSubmitted && countController.text.isEmpty)
                            ? true
                            : false,
                        keyboardType: TextInputType.name,
                        controller: countController,
                        focusNode: perkCount,
                        defaultValue: widget.waitList != null
                            ? widget.waitList!.perkCount
                            : '',
                        type: TextType.text,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20, bottom: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // TextButton.icon(
                      //   onPressed: () {},
                      //   icon: Icon(
                      //     Icons.done,
                      //     color: Colors.green,
                      //   ),
                      //   label: Text(
                      //     'Save',
                      //     style: TextStyle(color: Colors.black),
                      //   ),
                      // ),
                      // SizedBox(width: 10),
                      TextButton.icon(
                        onPressed: () {
                          context.read<SettingsProvider>().removeFromWaitList(
                                widget.waitList!,
                              );
                        },
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        label: Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
