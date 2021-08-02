import 'package:flutter/material.dart';

/// 单选控件
Widget buildRadioCell(
    {String label,
    ValueChanged<bool> onSelected,
    Color labelColor = Colors.black87,
    bool selected = false,
    Color selectColor = Colors.blue,
    TextStyle labelTextStyle}) {
  return FilterChip(
    checkmarkColor: Colors.transparent,
    disabledColor: Colors.transparent,
    selectedColor: Colors.transparent,
    selectedShadowColor: Colors.transparent,
    shadowColor: Colors.transparent,
    backgroundColor: Colors.transparent,
    label: Text(label ?? ''),
    labelStyle: labelTextStyle ?? TextStyle(fontSize: 14, color: labelColor),
    avatar: Icon(
        selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
        color: selected ? selectColor : Colors.black87,
        size: 14),
    padding: EdgeInsets.all(0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
    onSelected: (selected) {
      if (onSelected != null) onSelected(selected);
    },
  );
}
