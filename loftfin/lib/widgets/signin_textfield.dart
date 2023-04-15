import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loftfin/strings.dart';
import 'package:loftfin/style/app_theme.dart';

class SignInTextField extends StatefulWidget {
  final String title;
  final bool isError;
  final bool isOptional;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatter;
  final int? maxLength;
  final Function? validator;
  final String? defaultValue;
  SignInTextField({
    required this.title,
    required this.isError,
    required this.controller,
    required this.keyboardType,
    this.isOptional = false,
    this.focusNode,
    this.inputFormatter,
    this.maxLength,
    this.validator,
    this.defaultValue,
    Key? key,
  }) : super(key: key);

  @override
  _SignInTextFieldState createState() => _SignInTextFieldState();
}

class _SignInTextFieldState extends State<SignInTextField> {
  bool _isError = false;
  bool _validationError = false;
  @override
  void initState() {
    if (widget.defaultValue != null) {
      widget.controller.text = widget.defaultValue!;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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

    return Column(
      children: [
        Row(
          children: [
            Spacer(),
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
          height: 80,
          child: Center(
            child: TextFormField(
              onChanged: (value) {
                if (_isError) {
                  setState(() {
                    _isError = !_isError;
                  });
                }
              },
              inputFormatters: widget.inputFormatter ?? [],
              maxLines: 1,
              cursorColor: AppTheme.darkBlue,
              maxLength: widget.maxLength ?? 40,
              textAlign: TextAlign.center,
              controller: widget.controller,
              keyboardType: widget.keyboardType,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: AppTheme.darkBlue,
                fontSize: size.height * 0.04,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(10),
                counterText: '',
                hintText: widget.title,
                hintStyle: TextStyle(
                  fontSize: size.height * 0.04,
                  color: AppTheme.darkBlue.withOpacity(0.5),
                  fontWeight: FontWeight.w200,
                ),
              ),
              focusNode: widget.focusNode,
              onFieldSubmitted: (v) {},
              textInputAction: TextInputAction.next,
            ),
          ),
        ),
        _isError
            ? Align(
                alignment: Alignment.center,
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
      ],
    );
  }
}
