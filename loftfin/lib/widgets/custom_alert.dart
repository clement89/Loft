import 'package:flutter/material.dart';
import 'package:loftfin/style/app_theme.dart';

import 'custom_button.dart';

void showAlertOld({
  required BuildContext context,
  required String title,
  required String message,
  Widget? action,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          action ??
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
        ],
      );
    },
  );
}

void showAlert({
  required BuildContext context,
  required String title,
  required String message,
  required String buttonTitle,
  required double buttonWidth,
  Function? action,
  String? secondaryButtonTitle,
}) {
  showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: AppTheme.darkBlue.withOpacity(0.9),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return Center(
          child: Container(
            width: 300,
            // height: MediaQuery.of(context).size.height * 0.4,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTheme.appBarTitle,
                ),
                SizedBox(height: 30),
                Text(
                  message,
                  style: AppTheme.textStyleSmall,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomButton(
                      title: buttonTitle,
                      width: buttonWidth,
                      backgroundColor: AppTheme.themeColor,
                      onClick: () {
                        Navigator.of(context).pop();

                        if (action != null) {
                          action();
                        }
                      },
                    ),
                    secondaryButtonTitle != null
                        ? CustomButton(
                            title: secondaryButtonTitle,
                            width: buttonWidth,
                            backgroundColor: AppTheme.themeColor,
                            onClick: () {
                              Navigator.of(context).pop();
                            },
                          )
                        : Offstage(),
                  ],
                ),
              ],
            ),
          ),
        );
      });
}
