import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loftfin/style/app_theme.dart';

class CustomButton extends StatelessWidget {
  final double width;
  final String title;
  final Color backgroundColor;
  final Function onClick;
  final Color txtColor;
  final bool isEnabled;

  const CustomButton({
    required this.title,
    required this.width,
    required this.backgroundColor,
    required this.onClick,
    this.txtColor = Colors.white,
    this.isEnabled = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = 45;

    return Center(
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(height / 2),
        child: InkWell(
          onTap: () {
            if (isEnabled) {
              onClick();
            }
          },
          child: Container(
            // padding: isSmallButton
            //     ? EdgeInsets.all(size.height * 0.01)
            //     : EdgeInsets.all(size.height * 0.0125),
            height: height, //MediaQuery.of(context).size.width * .08,
            width: width, //MediaQuery.of(context).size.width * .3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(height / 2),
              color: isEnabled ? backgroundColor : Colors.black38,
            ),
            child: Center(
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: txtColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final double width;
  final String title;
  final Color backgroundColor;
  final Function onClick;
  final Color txtColor;
  final bool isEnabled;

  const CustomIconButton({
    required this.title,
    required this.width,
    required this.backgroundColor,
    required this.onClick,
    this.txtColor = Colors.white,
    this.isEnabled = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = 35;

    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(height / 2),
      child: InkWell(
        onTap: () {
          if (isEnabled) {
            onClick();
          }
        },
        child: Container(
          // padding: isSmallButton
          //     ? EdgeInsets.all(size.height * 0.01)
          //     : EdgeInsets.all(size.height * 0.0125),
          height: height, //MediaQuery.of(context).size.width * .08,
          width: width, //MediaQuery.of(context).size.width * .3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(height / 2),
            color: isEnabled ? backgroundColor : Colors.black38,
          ),
          child: Center(
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: txtColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextButton extends StatelessWidget {
  final String title;
  final Function onClick;

  const CustomTextButton({
    required this.title,
    required this.onClick,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        textStyle: AppTheme.buttonTextStyle,
      ),
      onPressed: () {
        onClick();
      },
      child: Text(
        title,
        style: AppTheme.buttonTextStyle,
      ),
    );
  }
}
