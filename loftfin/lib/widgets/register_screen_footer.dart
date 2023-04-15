import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:loftfin/screens/webview_screen.dart';
import 'package:loftfin/services/log_service.dart';
import 'package:loftfin/style/app_theme.dart';

import '../strings.dart';
import 'custom_button.dart';

class RegisterScreenFooter extends StatelessWidget {
  final Function nextButtonAction;
  const RegisterScreenFooter({
    required this.nextButtonAction,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.all(
        size.width * 0.077,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            offset: Offset(4, 0),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                kStringsLoftTerms,
                style: AppTheme.textStyleSmall.copyWith(
                  color: AppTheme.black,
                ),
              ),
              RichText(
                text: TextSpan(
                  style: AppTheme.textStyleSmall.copyWith(
                    color: AppTheme.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: kStringsTerms,
                      style: AppTheme.textStyleSmall.copyWith(
                        color: AppTheme.textButtonColor,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          dPrint('terms tapped');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WebViewScreen(
                                  url: 'https://www.loftfin.com/terms',
                                  title: ''),
                            ),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            width: 20,
          ),
          CustomButton(
            title: kStringsNext,
            width: size.width * 0.3,
            backgroundColor: AppTheme.themeColor,
            onClick: () {
              FocusScope.of(context).unfocus();
              nextButtonAction();
            },
          ),
        ],
      ),
    );
  }
}
