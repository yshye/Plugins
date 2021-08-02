import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 自定义对话框
class CustomizeDialog extends Dialog {
  final Widget child;
  final bool barrierDismissible;

  const CustomizeDialog({
    Key key,
    this.child,
    this.barrierDismissible = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      color: Colors.black45,
      child: GestureDetector(
        onTap: this.barrierDismissible ? () => Navigator.pop(context) : null,
        child: Container(
          color: Colors.black45,
          child: child,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
