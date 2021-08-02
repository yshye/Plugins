import 'package:flutter/material.dart';
import '../../util/theme_util.dart';

class MaterialButtonCell extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final Widget child;
  final Color textColor;
  final Color borderColor;
  final Color color;
  final double height;
  final double miniWidth;
  final double radius;
  final double sideWidth;
  final double fontSize;
  final BorderRadiusGeometry borderRadius;

  const MaterialButtonCell({
    Key key,
    this.onTap,
    this.label,
    this.textColor,
    this.borderColor,
    this.color,
    this.height = 45,
    this.child,
    this.miniWidth,
    this.radius = 8,
    this.sideWidth = 1,
    this.fontSize = 14,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: height,
      elevation: 0,
      minWidth: miniWidth,
      color: color ?? ThemeUtil.getCardBackgroundColor(context),
      textColor: textColor ?? ThemeUtil.getBodyTextColor(context),
      child: child ??
          Text(
            label ?? '',
            style: TextStyle(fontSize: fontSize),
          ),
      onPressed: onTap,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: borderColor ?? ThemeUtil.getAccentColor(context),
          width: sideWidth,
        ),
        borderRadius: borderRadius ?? BorderRadius.all(Radius.circular(radius)),
      ),
    );
  }
}
