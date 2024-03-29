import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../model/tag_cell_type.dart';
import '../model/tag_edit_model.dart';

class EditCell extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final double minHeight;
  final bool showCounter;
  final EditValueModel data;
  final String allowSource;

  const EditCell({
    Key key,
    this.padding = const EdgeInsets.all(1),
    this.minHeight = 35,
    this.data,
    this.showCounter = true,
    this.allowSource,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            padding: padding,
            color: data.color,
            child: data.tag2 == null
                ? _buildOneItem(
                    context,
                    showCounter: showCounter,
                    hintText: data.hintText,
                    valueColor: data.valueColor,
                    fontSize: data.fontSize,
                    tagWidth: data.tagWidth,
                    isEdit: data.isEdit,
                    required: data.required,
                    tag: data.tag,
                    tagColor: data.tagColor,
                    suffix: data.suffix,
                    controller: data.controller,
                    inputType: data.inputType,
                    child: data.child,
                    valueMaxLines: data.maxLines,
                    minHeight: minHeight,
                    maxLength: data.maxLength,
                    maxNum: data.maxNum,
                    placesLength: data.placesLength,
                    onlyNumValue: data.onlyNumValue,
                    style: data.style,
                    direction: data.direction,
                    allowSource: allowSource,
                  )
                : _buildTwoItem(
                    context,
                    fontSize: data.fontSize,
                    suffix: data.suffix,
                    suffix2: data.suffix2,
                    valueMaxLines: data.maxLines,
                    valueColor: data.valueColor,
                    valueColor2: data.valueColor2,
                    tagWidth: data.tagWidth,
                    tagWidth2: data.tagWidth2,
                    isEdit: data.isEdit,
                    isEdit2: data.isEdit2,
                    required: data.required,
                    required2: data.required2,
                    tag: data.tag,
                    tag2: data.tag2,
                    tagColor: data.tagColor,
                    tagColor2: data.tagColor2,
                    controller: data.controller,
                    controller2: data.controller2,
                    inputType: data.inputType,
                    inputType2: data.inputType2,
                    hintText: data.hintText,
                    hintText2: data.hintText2,
                    minHeight: minHeight,
                    maxLength: data.maxLength,
                    maxLength2: data.maxLength2,
                    maxNum: data.maxNum,
                    maxNum2: data.maxNum2,
                    placesLength2: data.placesLength2,
                    placesLength: data.placesLength,
                    onlyNumValue2: data.onlyNumValue2,
                    onlyNumValue: data.onlyNumValue,
                  ),
          ),
          data.showLine
              ? Divider(height: 0.5, color: Colors.grey[50])
              : Container(height: 0),
        ],
      ),
    );
  }

  _buildTwoItem(
    BuildContext context, {
    String tag,
    double tagWidth = 90,
    String tag2,
    double tagWidth2 = 90,
    double minHeight = 35,
    String suffix,
    String suffix2,
    Color tagColor = Colors.grey,
    Color tagColor2 = Colors.grey,
    Color valueColor = Colors.black,
    Color valueColor2 = Colors.black,
    FocusNode focusNode,
    FocusNode focusNode2,
    bool required = false,
    bool required2 = false,
    int valueMaxLines = 1,
    int maxLength,
    int maxLength2,
    bool isEdit = true,
    bool isEdit2 = true,
    TextEditingController controller,
    TextEditingController controller2,
    ValueChanged<String> onChange,
    ValueChanged<String> onChange2,
    TextInputType inputType = TextInputType.text,
    TextInputType inputType2 = TextInputType.text,
    InputDecoration inputDecoration,
    InputDecoration inputDecoration2,
    String hintText,
    String hintText2,
    double fontSize = 14,
    num maxNum,
    num maxNum2,
    int placesLength,
    int onlyNumValue,
    int placesLength2,
    int onlyNumValue2,
  }) {
    return Flex(direction: Axis.horizontal, children: <Widget>[
      Container(
        width: tagWidth,
        height: minHeight,
        alignment: Alignment.topLeft,
        child: Row(
          children: <Widget>[
            Expanded(
                child: Text(
                  tag,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                      color: tagColor, height: 1.1, fontSize: fontSize),
                ),
                flex: 1),
            required
                ? Icon(MdiIcons.multiplication, size: 8, color: Colors.red)
                : Container(),
          ],
        ),
      ),
      Expanded(
        flex: 1,
        child: TextField(
          maxLines: valueMaxLines,
          enabled: isEdit,
          focusNode: focusNode,
          enableInteractiveSelection: isEdit,
          controller: controller,
          // maxLengthEnforced: true,
          onChanged: onChange,
          keyboardType: inputType,
          maxLength: maxLength,
          inputFormatters: _getInputFormatter(
            inputType,
            maxLength,
            maxNum: maxNum,
            placesLength: placesLength,
            onlyNumValue: onlyNumValue,
          ),
          decoration: inputDecoration ??
              InputDecoration(
                  hintText: hintText ?? '请填写$tag',
                  border: isEdit ? null : InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 3),
                  suffixStyle: TextStyle(color: Colors.black87),
                  suffixText: suffix ?? ''),
          style: TextStyle(height: 1.1, fontSize: fontSize, color: valueColor),
        ),
      ),
      Container(
        width: tagWidth2,
        height: minHeight,
        padding: EdgeInsets.only(left: 3),
        alignment: Alignment.topLeft,
        child: Row(
          children: <Widget>[
            Expanded(
                child: Text(
                  tag2,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(color: tagColor2, height: 1.1),
                ),
                flex: 1),
            required2
                ? Icon(MdiIcons.multiplication, size: 8, color: Colors.red)
                : Container(),
          ],
        ),
      ),
      Expanded(
        flex: 1,
        child: TextField(
          maxLines: valueMaxLines,
          enabled: isEdit,
          focusNode: focusNode2,
          enableInteractiveSelection: isEdit,
          controller: controller2,
          // maxLengthEnforced: true,
          onChanged: onChange2,
          maxLength: maxLength2,
          keyboardType: inputType2 ?? TextInputType.text,
          inputFormatters: _getInputFormatter(
            inputType2 ?? TextInputType.text,
            maxLength2,
            maxNum: maxNum2,
            placesLength: placesLength2,
            onlyNumValue: onlyNumValue2,
          ),
          decoration: inputDecoration2 ??
              InputDecoration(
                hintText: hintText2 ?? '请填写$tag2',
                border: isEdit2 ? null : InputBorder.none,
                contentPadding: EdgeInsets.only(left: 3),
                suffixText: suffix2 ?? '',
                suffixStyle: TextStyle(color: Colors.black87),
              ),
          style: TextStyle(height: 1.1, fontSize: 14, color: valueColor2),
        ),
      ),
    ]);
  }

  _buildOneItem(
    BuildContext context, {
    String tag,
    String suffix,
    bool showCounter = true,
    double tagWidth = 90,
    double minHeight = 35,
    int maxLength,
    Color valueColor = Colors.black,
    Color tagColor = Colors.grey,
    bool required = false,
    int valueMaxLines = 1,
    bool isEdit = true,
    FocusNode focusNode,
    // KeyboardActionsConfig config,
    TextEditingController controller,
    ValueChanged<String> onChange,
    TextInputType inputType = TextInputType.text,
    InputDecoration inputDecoration,
    String hintText,
    double fontSize = 14,
    Widget child,
    num maxNum,
    int placesLength,
    int onlyNumValue,
    TagCellStyle style = TagCellStyle.style2,
    Axis direction = Axis.horizontal,
    String allowSource,
  }) {
    Widget _tagWidget = Container(
      width: tagWidth,
      height: minHeight,
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          required
              ? Icon(MdiIcons.multiplication, size: 8, color: Colors.red)
              : Container(),
          SizedBox(width: 5),
          Expanded(
            child: Text(
              tag,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style:
                  TextStyle(color: tagColor, height: 1.1, fontSize: fontSize),
            ),
          ),
        ],
      ),
    );
    Widget _contentWidget = child ??
        Container(
          alignment: Alignment.topLeft,
          child: TextField(
            maxLines: valueMaxLines,
            focusNode: focusNode,
            enabled: isEdit,
            enableInteractiveSelection: isEdit,
            // maxLengthEnforced: true,
            controller: controller,
            onChanged: onChange,
            keyboardType: (valueMaxLines == null || valueMaxLines > 1)
                ? TextInputType.multiline
                : inputType,
            maxLength: maxLength,
            textAlign:
                style == TagCellStyle.style1 ? TextAlign.left : TextAlign.right,
            inputFormatters: _getInputFormatter(
              inputType,
              maxLength,
              maxNum: maxNum,
              onlyNumValue: onlyNumValue,
              placesLength: placesLength,
              allowSource: allowSource,
            ),
            textAlignVertical: TextAlignVertical.top,
            decoration: inputDecoration ??
                InputDecoration(
                    hintText: hintText ?? '请填写$tag',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 4),
                    labelStyle: TextStyle(fontSize: fontSize),
                    hintStyle: TextStyle(
                        fontSize: fontSize,
                        height: 1.1,
                        color: Color(0xffd2d2d2)),
                    suffixText: suffix ?? '',
                    counterStyle: TextStyle(color: Color(0xffd2d2d2)),
                    counterText: showCounter ? null : ''
//                focusedBorder:
//                    UnderlineInputBorder(borderSide: BorderSide(color: ThemeUtil.getPrimaryColor(context), width: 0.8)),
//                enabledBorder:
//                    UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).dividerColor, width: 0.8)),
                    ),
            style:
                TextStyle(height: 1.1, fontSize: fontSize, color: valueColor),
          ),
        );

    return direction == Axis.horizontal
        ? Row(children: <Widget>[
            _tagWidget,
            Expanded(child: _contentWidget),
            SizedBox(width: 5)
          ])
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                _tagWidget,
                SizedBox(height: 5),
                _contentWidget
              ]);
  }
}

/// [placesLength] 小数位（[decimal]=true时生效）<br/>
/// [onlyNumValue] 固定小数位,范围 null || [1-9]且[placesLength]=1时可用
_getInputFormatter(TextInputType keyboardType, int maxLength,
    {num maxNum, int placesLength, int onlyNumValue, String allowSource}) {
  if (keyboardType == TextInputType.numberWithOptions(decimal: true)) {
    return [
      UsNumberTextInputFormatter(
        max: maxNum,
        onlyNumValue: onlyNumValue,
        placesLength: placesLength,
        decimal: keyboardType == TextInputType.numberWithOptions(decimal: true),
      )
    ];
  } else if (keyboardType == TextInputType.number) {
    return [
      UsNumberTextInputFormatter(max: maxNum, decimal: false),
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(maxLength),
    ];
  } else if (keyboardType == TextInputType.phone) {
    return [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(maxLength)
    ];
  } else if (allowSource != null) {
    return [
      FilteringTextInputFormatter.allow(RegExp(allowSource))
      // [\u4e00-\u9fa5a-zA-Z0-9、，。、：；,.:;]
    ];
  }
  return null;
}

class UsNumberTextInputFormatter extends TextInputFormatter {
  static const defaultDouble = 0.001;
  bool decimal;
  num max;

  /// 小数位（[decimal]=true时生效）
  int placesLength;

  /// 固定小数位,范围 null || [1-9]且[placesLength]=1时可用，
  int onlyNumValue;

  UsNumberTextInputFormatter(
      {this.max, this.decimal = true, this.placesLength, this.onlyNumValue})
      : assert(onlyNumValue == null || (onlyNumValue > 0 && onlyNumValue < 10));

  static double strToFloat(String str, [double defaultValue = defaultDouble]) {
    if (str.isEmpty) return 0;
    try {
      return double.parse(str);
    } catch (e) {
      return defaultValue;
    }
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String value = newValue.text;
    int selectionIndex = newValue.selection.end;
    if (decimal) {
      if (value == '.') {
        value = '0.';
      } else if (value != '' &&
          value != defaultDouble.toString() &&
          strToFloat(value, defaultDouble) == defaultDouble) {
        value = oldValue.text;
        selectionIndex = oldValue.selection.end;
      } else {
        if (placesLength != null) {
          int index = value.indexOf('.');
          if (index > 0 && index + placesLength < value.length) {
            if (placesLength == 1 && onlyNumValue != null) {
              value = "${value.substring(0, index + 1)}$onlyNumValue";
            } else {
              value = value.substring(0, index + placesLength + 1);
            }
          }
        }
      }
    }
    if (max != null && value.isNotEmpty && num.parse(value) > max) {
      value = '$max';
    }
    selectionIndex = value.length;
    return TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }

// TextEditingValue _selectionAwareTextManipulation(
//   TextEditingValue value,
//   String substringManipulation(String substring),
// ) {
//   final int selectionStartIndex = value.selection.start;
//   final int selectionEndIndex = value.selection.end;
//   String manipulatedText;
//   TextSelection manipulatedSelection;
//   if (selectionStartIndex < 0 || selectionEndIndex < 0) {
//     manipulatedText = substringManipulation(value.text);
//   } else {
//     final String beforeSelection = substringManipulation(value.text.substring(0, selectionStartIndex));
//     final String inSelection = substringManipulation(value.text.substring(selectionStartIndex, selectionEndIndex));
//     final String afterSelection = substringManipulation(value.text.substring(selectionEndIndex));
//     manipulatedText = beforeSelection + inSelection + afterSelection;
//     if (value.selection.baseOffset > value.selection.extentOffset) {
//       manipulatedSelection = value.selection.copyWith(
//         baseOffset: beforeSelection.length + inSelection.length,
//         extentOffset: beforeSelection.length,
//       );
//     } else {
//       manipulatedSelection = value.selection.copyWith(
//         baseOffset: beforeSelection.length,
//         extentOffset: beforeSelection.length + inSelection.length,
//       );
//     }
//   }
//   return TextEditingValue(
//     text: manipulatedText,
//     selection: manipulatedSelection ?? const TextSelection.collapsed(offset: -1),
//     composing: manipulatedText == value.text ? value.composing : TextRange.empty,
//   );
// }
}
