import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loftfin/style/app_theme.dart';
import 'package:loftfin/widgets/page_indicator.dart';

import '../strings.dart';

class RegisterScreenHeader extends StatelessWidget {
  final int pageIndex;
  final String title;

  final String? subTitle;
  final bool showPagination;
  final bool clearBackground;

  const RegisterScreenHeader({
    required this.pageIndex,
    required this.title,
    this.subTitle,
    this.showPagination = true,
    this.clearBackground = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
      height: showPagination ? size.height * 0.24 : size.height * 0.16,
      width: size.width,
      decoration: BoxDecoration(
        color: AppTheme.blue,
      ),
      child: Stack(
        children: [
          clearBackground
              ? SizedBox(height: 0)
              : Positioned(
                  left: 0,
                  right: 0,
                  top: 50,
                  child: SizedBox(
                    child: Image.asset(
                      'assets/images/header_clouds.png',
                    ),
                  ),
                ),
          Column(
            children: [
              SizedBox(
                height: size.height * 0.07,
              ),
              Stack(
                children: [
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: AppTheme.textStyleHeading,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      clearBackground
                          ? SizedBox(width: 0)
                          : IconButton(
                              icon: const Icon(Icons.arrow_back_ios_outlined),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: AppTheme.textStyleSmall.copyWith(
                            color: AppTheme.darkBlue,
                          ),
                        ),
                        onPressed: () {
                          print('okk');

                          Navigator.of(context).pop();
                        },
                        child: Text(
                          kStringsCancel,
                          style: AppTheme.textStyleSmall.copyWith(
                            color: AppTheme.darkBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              showPagination
                  ? Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Text(
                          subTitle ?? '',
                          style: AppTheme.textStyleSmall,
                        ),
                        SizedBox(
                          height: size.height * 0.015,
                        ),
                        PageIndicator(index: pageIndex)
                      ],
                    )
                  : SizedBox(height: 0),
            ],
          ),
        ],
      ),
    );
  }
}
