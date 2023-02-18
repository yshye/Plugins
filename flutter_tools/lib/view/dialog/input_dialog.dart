import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../util/string_util.dart';
import '../cell/tag_edit_cell.dart';
import '../toast.dart';
import 'base_dialog.dart';

class InputDialog extends StatefulWidget {
  InputDialog({
    Key key,
    @required this.title,
    this.onPressed,
    this.cancelCallback,
    this.content,
    this.hintText,
    this.message,
    this.inputType,
    this.maxLength,
    this.button1Text,
    this.button2Text,
    this.hasRequired = false,
    this.maxLines,
    this.titleTextStyle,
    this.minLength,
  }) : super(key: key);

  final String title;
  final TextStyle titleTextStyle;
  final Function(String) cancelCallback;
  final Function(String) onPressed;
  final String content;
  final String hintText;
  final String message;
  final int maxLength;
  final TextInputType inputType;
  final String button1Text;
  final String button2Text;
  final int maxLines;
  final int minLength;

  /// 必填
  final bool hasRequired;

  @override
  _InputDialog createState() => _InputDialog();
}

class _InputDialog extends State<InputDialog> {
  TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.content);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget messageWidget = StringUtil.isEmpty(widget.message)
        ? Container()
        : Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      child: Text(
        widget.message,
        textAlign: TextAlign.left,
        style: TextStyle(
            height: 1.2, color: Colors.pinkAccent, fontSize: 14),
      ),
    );
    return BaseDialog(
      title: widget.title,
      titleStyle: widget.titleTextStyle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          messageWidget,
          Container(
            height: 34.0 * (widget.maxLines ?? 1),
            alignment: Alignment.center,
            margin: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
            decoration: BoxDecoration(
              color: Color(0xFFF6F6F6),
              borderRadius: BorderRadius.circular(2.0),
            ),
            child: TextField(
              key: const Key('price_input'),
              autofocus: true,
              controller: _controller,
              maxLines: widget.maxLines ?? 1,
              maxLength: widget.maxLength,
              textInputAction: TextInputAction.done,
              keyboardType: widget.inputType ?? TextInputType.text,
              inputFormatters: _getInputFormatter(
                  widget.inputType ?? TextInputType.text, widget.maxLength),
              decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  border: InputBorder.none,
                  hintText: widget.hintText ?? '输入${widget.title}',
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  counterText: ''
                //hintStyle: TextStyles.textGrayC14,
              ),
            ),
          ),
        ],
      ),
      onlyOneButton: false,
      button1Text: widget.button1Text,
      onClick1: () {
        if (widget.cancelCallback != null)
          widget.cancelCallback(_controller.text);
        else
          Navigator.pop(context);
        // NavigatorUtil.pop(context);
      },
      button2Text: widget.button2Text,
      onClick2: () {
        if (widget.hasRequired && _controller.text
            .trim()
            .isEmpty) {
          ToastUtil.showError(widget.hintText ?? '输入${widget.title}');
          return;
        }
        if (widget.minLength != null) {
          if (_controller.text
              .trim()
              .length < widget.minLength) {
            ToastUtil.showError('${widget.title}不可少于${widget.minLength}个字!');
            return;
          }
        }
        Navigator.pop(context);
        widget.onPressed(_controller.text);
      },
    );
  }
}

void showInputDialog(BuildContext context,
    ValueChanged<String> okCallback, {
      ValueChanged<String> cancelCallback,
      String hintText,
      @required String title,
      TextStyle titleTextStyle,
      String message,
      int maxLength,
      String okText,
      String cancelText,
      bool required = true,
      String content,
      TextInputType inputType,
      int maxLines,
      int minLength,
    }) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) =>
        InputDialog(
          title: title,
          hintText: hintText,
          onPressed: okCallback,
          message: message,
          cancelCallback: cancelCallback,
          maxLength: maxLength,
          button1Text: cancelText,
          button2Text: okText,
          hasRequired: required,
          content: content,
          maxLines: maxLines,
          titleTextStyle: titleTextStyle,
          minLength: minLength,
        ),
  );
}

_getInputFormatter(TextInputType keyboardType, int maxLength) {
  if (keyboardType == TextInputType.numberWithOptions(decimal: true)) {
    return [UsNumberTextInputFormatter()];
  }
  if (keyboardType == TextInputType.number) {
    return [
      UsNumberTextInputFormatter(decimal: false),
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(maxLength),
    ];
  }
  if (keyboardType == TextInputType.phone) {
    return [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(maxLength)
    ];
  }
  return null;
}
