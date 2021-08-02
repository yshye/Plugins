import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../dialog/dialog.dart';
import '../model/tag_cell_type.dart';
import '../typedef.dart';

/// [onItemSelected] -1 代表无数据
Widget buildTagSelectCell<T>(
  BuildContext context,
  String tag, {
  IconData iconData = Icons.keyboard_arrow_down,
  Widget icon,
  Color iconColor = const Color(0xffbcbcbc),
  double tagWidth = 100,
  String hintText,
  double fontSize = 16,
  double miniHeight = 40,
  Color tagColor = const Color(0xff63728f),
  TextEditingController controller,
  TextInputType inputType,
  InputDecoration inputDecoration,
  List<T> items,
  BuildCheckChild<T> buildCheckChild,
  VoidCallback onTap,
  bool required = false,
  bool isEdit = true,
  int valueMaxLines = 1,
  double paddingRight = 0.0,
  EdgeInsetsGeometry padding = const EdgeInsets.all(1),
  bool showLine = false,
  Color color = Colors.transparent,
  Widget child,
  ValueChanged<int> onItemSelected,
  double iconWidth = 40,
  TagCellStyle style = TagCellStyle.style2,
}) {
  return Material(
    color: color,
    child: Ink(
      child: InkWell(
        onTap: isEdit
            ? (onItemSelected == null
                ? onTap
                : () {
                    if (items == null || items.length < 1) {
                      onItemSelected(-1);
                    }
                    showBottomPopup(context, '请选择$tag', items,
                            buildCheckChild: buildCheckChild, autoHeight: true)
                        .then((index) {
                      if (index == null || index < 0) return;
                      onItemSelected(index);
                    });
                  })
            : null,
        child: Column(children: <Widget>[
          Padding(
            padding: padding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: tagWidth,
                    height: miniHeight ?? 40,
                    child: Row(
                      children: <Widget>[
                        required
                            ? Icon(MdiIcons.multiplication,
                                size: 8, color: Colors.red)
                            : Container(width: 0),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            tag,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                color: tagColor,
                                height: 1.1,
                                fontSize: fontSize),
                          ),
                        ),
                      ],
                    )),
                Expanded(
                  child: child ??
                      TextField(
                        enabled: false,
                        enableInteractiveSelection: false,
                        controller: controller,
                        keyboardType: inputType ?? TextInputType.text,
                        textAlign: style == TagCellStyle.style1
                            ? TextAlign.start
                            : TextAlign.right,
                        decoration: inputDecoration ??
                            InputDecoration(
                              hintText: hintText ?? '请选择$tag',
                              hintStyle: TextStyle(
                                  fontSize: fontSize,
                                  height: 1.1,
                                  color: Color(0xffd2d2d2)),
                              border: InputBorder.none,
                              labelStyle: TextStyle(fontSize: fontSize),
                            ),
                        style: TextStyle(height: 1.1, fontSize: fontSize),
                      ),
                ),
                SizedBox(width: 5),
                Container(
                  width: isEdit ? iconWidth : 0,
                  alignment: Alignment.topRight,
                  child: isEdit
                      ? (icon ??
                          Icon(iconData, color: iconColor ?? Color(0xffbcbcbc)))
                      : Container(),
                ),
                SizedBox(width: paddingRight)
              ],
            ),
          ),
          showLine ? Divider(height: 0.5, color: Colors.grey[50]) : Container(),
        ]),
      ),
    ),
  );
}
