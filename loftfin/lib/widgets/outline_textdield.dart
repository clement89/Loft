import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:loftfin/services/log_service.dart';
import 'package:loftfin/strings.dart';
import 'package:loftfin/style/app_theme.dart';

enum TextType {
  text,
  date,
}

class OutlineTextField extends StatefulWidget {
  final String title;
  final bool isError;
  final bool isOptional;
  final double height;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  // final List<TextInputFormatter>? inputFormatter;
  final int? maxLength;
  final Function? validator;
  final String? defaultValue;
  final bool observeChange;
  final String? preFixText;
  final TextType type;
  final Function(String)? onChangeAction;
  final bool isMultiline;
  final String? info;
  // final Function(String, String) updateAction;
  // final String fieldName;
  OutlineTextField({
    required this.title,
    required this.isError,
    required this.controller,
    required this.keyboardType,
    this.isOptional = false,
    this.height = 50,
    this.focusNode,
    this.nextFocusNode,
    // this.inputFormatter,
    this.maxLength,
    this.validator,
    this.defaultValue,
    this.observeChange = false,
    this.preFixText,
    this.type = TextType.text,
    this.onChangeAction,
    this.isMultiline = false,
    this.info,
    // required this.updateAction,
    // required this.fieldName,
    Key? key,
  }) : super(key: key);

  @override
  _OutlineTextFieldState createState() => _OutlineTextFieldState();
}

class _OutlineTextFieldState extends State<OutlineTextField> {
  bool _isError = false;
  bool _validationError = false;

  @override
  void initState() {
    if (widget.defaultValue != null) {
      dPrint('default - ${widget.defaultValue}');
      Future.delayed(const Duration(milliseconds: 500), () {
        widget.controller.text = widget.defaultValue!;
      });
    }

    // if (widget.type == TextType.date) {
    //   widget.focusNode!.addListener(_onFocusChange);
    // }

    super.initState();
  }

  @override
  void dispose() {
    // widget.focusNode!.removeListener(_onFocusChange);
    widget.controller.dispose();
    super.dispose();
  }

  bool isCalendarShowing = false;
  // void _onFocusChange() async {
  //   FocusScope.of(context).requestFocus(widget.nextFocusNode);
  //   if (isCalendarShowing) {
  //     return;
  //   }
  //   print('_onFocusChange...');

  //   isCalendarShowing = true;
  //   final format = DateFormat("yyyy-MM-dd");
  //   DateTime? date;
  //   date = await showDatePicker(
  //     context: context,
  //     firstDate: DateTime(1900),
  //     initialDate: DateTime.now(),
  //     lastDate: DateTime(2100),
  //   );
  //   isCalendarShowing = false;
  //   if (date != null) {
  //     if (widget.onChangeAction != null) {
  //       widget.onChangeAction!(format.format(date));
  //     }
  //     widget.controller.text = format.format(date);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    if (widget.isError) {
      if (widget.controller.text == '') {
        _isError = true;
        _validationError = false;
      } else {
        if (widget.validator != null) {
          if (widget.validator!(widget.controller.text)) {
            _isError = false;
            _validationError = false;
          } else {
            _isError = true;
            _validationError = true;
          }
        } else {
          _isError = false;
          _validationError = false;
        }
      }
    }

    return SizedBox(
      width: widget.isMultiline ? 300 : 250,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                widget.title,
                style: AppTheme.textStyleSmall.copyWith(
                  color: _isError ? AppTheme.red : AppTheme.black,
                ),
              ),
              Spacer(),
              _isError
                  ? Icon(
                      Icons.error,
                      color: AppTheme.red,
                    )
                  : Container(),
              widget.isOptional
                  ? Text(
                      kStringsOptional,
                      style: AppTheme.textStyleSmall.copyWith(
                        color: AppTheme.textButtonColor,
                      ),
                    )
                  : Container(),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: widget.isMultiline ? 120 : widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              border: Border.all(
                width: 1,
                color: Colors.black26,
              ),
            ),
            child: TextFormField(
              maxLines: widget.isMultiline ? 12 : 1,
              onChanged: (value) {
                if (_isError) {
                  setState(() {
                    _isError = !_isError;
                  });
                }

                // if (widget.observeChange) {}
                if (widget.onChangeAction != null) {
                  widget.onChangeAction!(value);
                }
              },
              // autovalidateMode: AutovalidateMode.onUserInteraction,
              // validator: (value) {
              //   return widget.validator != null
              //       ? widget.validator!(value)
              //       : null;
              // },
              // inputFormatters: widget.inputFormatter ?? [],
              // maxLines: 1,
              onTap: () async {
                // Below line stops keyboard from appearing
                if (widget.type == TextType.date) {
                  FocusScope.of(context).requestFocus(FocusNode());

                  final format = DateFormat("yyyy-MM-dd");
                  DateTime date;
                  date = (await showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    initialDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  ))!;
                  if (widget.onChangeAction != null) {
                    widget.onChangeAction!(format.format(date));
                  }
                  widget.controller.text = format.format(date);
                  // widget.updateAction(widget.fieldName, format.format(date));
                }
              },

              // maxLength: widget.maxLength ?? 40,
              textAlign: TextAlign.left,
              controller: widget.controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(10),
                hintText: ' ',
                hintStyle: TextStyle(
                  fontFamily: 'Acumin Pro',
                  fontSize: 14,
                  color: const Color(0xffffffff),
                ),
                // counterText: '',
                // hintText: title,
                // hintStyle: TextStyle(
                //   fontSize: 15.0,
                //   color: Colors.black54,
                //   fontWeight: FontWeight.w400,
                // ),
                // prefixIcon: widget.preFixText != null
                //     ? Padding(
                //         padding:
                //             EdgeInsets.all(15), // add padding to adjust icon
                //         child: Text('+1'),
                //       )
                //     : null,
              ),
              // keyboardType: widget.keyboardType,
              focusNode: widget.focusNode,
              // onFieldSubmitted: (v) {
              //   widget.nextFocusNode ??
              //       FocusScope.of(context).requestFocus(widget.nextFocusNode);
              // },
              textInputAction: TextInputAction.next,
            ),
          ),
          _isError
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    (_validationError
                            ? kStringsPleaseEnterValid
                            : kStringsPleaseEnter) +
                        widget.title,
                    style: AppTheme.textStyleSmall.copyWith(
                      color: AppTheme.red,
                    ),
                  ),
                )
              : Container(),
          widget.info != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(widget.info!),
                )
              : SizedBox.shrink(),
        ],
      ),
    );

    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Text(
    //       title,
    //       style: TextStyle(
    //         color: AppTheme.textColor,
    //       ),
    //     ),
    //     SizedBox(height: 10),
    //     TextFormField(
    //       autovalidateMode: AutovalidateMode.always,
    //       /* autovalidate is set to true */
    //       // controller: stateController,
    //       // inputFormatters: [
    //       //   FilteringTextInputFormatter.deny(RegExp(r"\s\s")),
    //       //   FilteringTextInputFormatter.deny(RegExp(
    //       //       r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')),
    //       // ],
    //       keyboardType: TextInputType.text,
    //       maxLength: 160,
    //       onChanged: (val) {},
    //       maxLines: 1,
    //       validator: (value) {
    //         // int res = validateAddress(value);
    //         // if (res == 1) {
    //         //   return "Please enter state";
    //         // } else {
    //         //   return null;
    //         // }
    //       },
    //       // focusNode: stateFocus,
    //       autofocus: false,
    //       decoration: InputDecoration(
    //         errorMaxLines: 1,
    //         counterText: "",
    //         filled: true,
    //         fillColor: Colors.white,
    //         focusedBorder: OutlineInputBorder(
    //           borderRadius: BorderRadius.all(Radius.circular(4)),
    //           borderSide: BorderSide(
    //             width: 1,
    //             color: Colors.black54,
    //           ),
    //         ),
    //         enabledBorder: OutlineInputBorder(
    //           borderRadius: BorderRadius.all(Radius.circular(4)),
    //           borderSide: BorderSide(
    //             width: 1,
    //             color: Colors.black26,
    //           ),
    //         ),
    //         errorBorder: OutlineInputBorder(
    //             borderRadius: BorderRadius.all(Radius.circular(4)),
    //             borderSide: BorderSide(
    //               width: 1,
    //               color: Colors.red,
    //             )),
    //         focusedErrorBorder: OutlineInputBorder(
    //           borderRadius: BorderRadius.all(Radius.circular(4)),
    //           borderSide: BorderSide(
    //             width: 1,
    //             color: Colors.red,
    //           ),
    //         ),
    //         hintText: title,
    //       ),
    //     ),
    //   ],
    // );
  }
}
