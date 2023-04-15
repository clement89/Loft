import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loftfin/style/app_theme.dart';

class PageIndicator extends StatelessWidget {
  final int index;
  const PageIndicator({
    required this.index,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildDot(index > 0 ? true : false),
          _buildLine(),
          _buildDot(index > 1 ? true : false),
          // _buildLine(),
          // _buildDot(index > 2 ? true : false),
        ],
      ),
    );
  }

  Widget _buildDot(bool isFilled) {
    return Container(
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        color: isFilled ? AppTheme.themeColor : Colors.transparent,
        border: Border.all(color: AppTheme.themeColor, width: 1),
        borderRadius: BorderRadius.all(
          Radius.circular(
            5,
          ),
        ),
      ),
    );
  }

  Widget _buildLine() {
    return SizedBox(
      width: 20,
      child: Divider(
        thickness: 1,
        color: AppTheme.themeColor.withOpacity(0.3),
      ),
    );
  }
}
