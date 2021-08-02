import 'package:flutter/material.dart';

import 'mini_text_field.dart';

class MiniSearchWidget extends StatelessWidget {
  final TextEditingController controller;
  final double width;
  final String hintText;
  final TextStyle hintTextStyle;
  final Color color;
  final bool autoFocus;
  final double height;
  final BorderRadiusGeometry borderRadius;
  final bool showIcon;
  final int maxLength;

  const MiniSearchWidget({
    Key key,
    this.controller,
    this.hintText = '快速搜索',
    this.hintTextStyle,
    this.width = double.infinity,
    this.height = 34,
    this.color,
    this.autoFocus = true,
    this.borderRadius,
    this.showIcon = true,
    this.maxLength = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      alignment: Alignment.center,
      width: width,
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).backgroundColor,
        borderRadius: borderRadius ?? BorderRadius.circular(4.0),
      ),
      child: MiniTextField(
        autoFocus: autoFocus,
        controller: controller,
        maxLength: maxLength,
        contentPadding:
            EdgeInsets.only(top: 0.0, left: -8.0, right: -16.0, bottom: 12.0),
        icon: showIcon
            ? Icon(
                Icons.search,
                color: hintTextStyle?.color,
                size: 25,
              )
            : null,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        hintText: hintText,
        hintTextStyle: hintTextStyle,
      ),
    );
  }
}
