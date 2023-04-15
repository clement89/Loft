import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loftfin/style/app_theme.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final Widget? trailing;

  const CustomAppBar({
    required this.title,
    this.leading,
    this.trailing,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(4),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 3,
            spreadRadius: 0,
          ),
        ],
        color: AppTheme.blue,
        image: DecorationImage(
          image: AssetImage(
            'assets/images/header_background.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  leading ?? SizedBox(width: 15),
                  trailing ?? SizedBox(width: 15),
                ],
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Center(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: AppTheme.textStyleHeading,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(100);
}
