import 'package:flutter/material.dart';

/// 圆角背景控件
class BorderWidget extends StatelessWidget {
  final Color backColor;
  final String label;
  final double fontSize;
  final Color textColor;
  final BorderRadiusGeometry borderRadius;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final double width;
  final double height;
  final double shapeWidth;
  final int maxLines;

  BorderWidget(
      {this.backColor,
      this.width,
      this.height,
      @required this.label,
      this.maxLines = 1,
      this.fontSize = 10,
      this.textColor = Colors.white,
      this.borderRadius = const BorderRadius.all(Radius.circular(5.0)),
      this.margin = const EdgeInsets.only(),
      this.fontWeight = FontWeight.bold,
      this.padding =
          const EdgeInsets.only(top: 3, bottom: 2, left: 5, right: 5),
      this.shapeWidth = 0.5});

  @override
  Widget build(BuildContext context) {
    Color _backColor = this.backColor ??
        ((textColor != Colors.white && backColor == null)
            ? this.textColor.withAlpha(80)
            : Colors.green);
    return GestureDetector(
      child: Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: this.textColor, width: shapeWidth),
          borderRadius: borderRadius,
        ),
        child: Container(
          width: width,
          height: height,
          margin: margin,
          padding: padding,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: _backColor,
              borderRadius: borderRadius,
              shape: BoxShape.rectangle),
          child: Text(
            label ?? '',
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: this.textColor,
                fontSize: fontSize,
                fontWeight: fontWeight,
                height: 1),
          ),
        ),
      ),
    );
  }
}
