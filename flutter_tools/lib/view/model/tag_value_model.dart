import 'package:flutter/material.dart';

class TagValueModel {
  String tag;
  bool tagHight;
  String value;
  Color valueColor;
  Color tagColor;
  TextInputType inputType;
  bool clip;
  VoidCallback clipTap;
  String tag2;
  String value2;
  Color tagColor2;
  Color valueColor2;
  TextInputType inputType2;
  Widget child;
  bool showLine;
  int maxLines2;
  int maxLines;
  Axis axis;
  double tagWidth;
  double tag2Width;

  TagValueModel({
    this.tag,
    this.tagColor,
    this.tagHight = false,
    this.showLine = false,
    this.value,
    this.valueColor,
    this.clip = false,
    this.clipTap,
    this.tag2,
    this.tagColor2,
    this.value2,
    this.valueColor2,
    this.inputType = TextInputType.text,
    this.inputType2 = TextInputType.text,
    this.child,
    this.maxLines,
    this.maxLines2,
    this.axis,
    this.tag2Width,
    this.tagWidth,
  });
}
