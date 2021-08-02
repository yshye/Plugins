import 'package:flutter/material.dart';

class TabModel {
  String label;
  int flex;
  TextStyle textStyle;
  VoidCallback onTop;
  double width;
  EdgeInsetsGeometry padding;
  AlignmentGeometry alignment;
  Widget child;
  bool showLeft;
  bool showRight;
  bool showButtom;

  TabModel({
    this.label,
    this.flex,
    this.textStyle,
    this.onTop,
    this.width = 80,
    this.child,
    this.padding = const EdgeInsets.all(3),
    this.alignment,
    this.showLeft = false,
    this.showRight = false,
    this.showButtom = false,
  });
}
