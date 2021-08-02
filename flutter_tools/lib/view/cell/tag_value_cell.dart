import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../router/navigator_util.dart';
import '../../util/string_util.dart';
import '../../util/theme_util.dart';
import '../model/tag_value_model.dart';
import '../toast.dart';
import 'ink_cell.dart';

class TagValueCell extends StatelessWidget {
  final TagValueModel data;
  final Color color;

  final double tagWidth;

  final double miniHeight;

  final double fontSize;
  final BuildContext context;
  final EdgeInsetsGeometry padding;
  final TextAlign textAlign;

  TagValueCell({
    Key key,
    this.context,
    this.data,
    this.color,
    this.tagWidth = 70,
    this.miniHeight = 15,
    this.fontSize = 16,
    this.padding = const EdgeInsets.all(1),
    this.textAlign = TextAlign.left,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Padding(
        padding: padding,
        child: data.tag2 == null
            ? _buildOneLine(
                data.tag,
                data.value,
                tagHeight: data.tagHight,
                tagColor: data.tagColor,
                valueColor: data.valueColor,
                clip: data.clip,
                clipTap: data.clipTap,
                inputType: data.inputType,
                child: data.child,
                valueMaxLines: data.maxLines,
                tagWidth: tagWidth,
                miniHeight: miniHeight,
                fontSize: fontSize,
                context: context,
                textAlign: textAlign,
                direction: data.axis ?? Axis.horizontal,
              )
            : Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: _buildOneLine(
                        data.tag,
                        data.value,
                        tagColor: data.tagColor,
                        tagHeight: data.tagHight,
                        valueColor: data.valueColor,
                        inputType: data.inputType,
                        valueMaxLines: data.maxLines,
                        tagWidth: tagWidth,
                        miniHeight: miniHeight,
                        fontSize: fontSize,
                        context: context,
                        direction: Axis.horizontal,
                      )),
                  Expanded(
                      flex: 1,
                      child: _buildOneLine(
                        data.tag2,
                        data.value2,
                        tagColor: data.tagColor2,
                        valueColor: data.valueColor2,
                        inputType: data.inputType2,
                        valueMaxLines: data.maxLines2,
                        tagWidth: tagWidth,
                        miniHeight: miniHeight,
                        clip: data.clip,
                        fontSize: fontSize,
                        context: context,
                        direction: Axis.horizontal,
                      )),
                ],
              ),
      ),
      data.showLine ? Divider() : Container(),
    ]);
  }

  _buildOneLine(
    String tag,
    String value, {
    Color tagColor = Colors.grey,
    bool tagHeight = false,
    Color valueColor,
    TextInputType inputType = TextInputType.text,
    bool clip = false,
    VoidCallback clipTap,
    Widget child,
    double tagWidth = 70,
    double miniHeight = 20,
    double fontSize,
    int valueMaxLines = 1,
    BuildContext context,
    TextAlign textAlign = TextAlign.left,
    Axis direction = Axis.horizontal,
  }) {
    bool flag = false;
    String url = '';
    IconData iconData;
    if (!StringUtil.isEmpty(value)) {
      if (clip) iconData = Icons.content_copy;
      if (inputType == TextInputType.phone) {
        flag = true;
        url = 'tel:$value';
        iconData = Icons.phone;
      } else if (inputType == TextInputType.emailAddress) {
        flag = true;
        url = 'mailto:$value';
        iconData = Icons.email;
      } else if (inputType == TextInputType.url) {
        flag = true;
        url = value;
        iconData = Icons.web;
      }
    }

    Widget valueWidget = Container(
      alignment: Alignment.centerLeft,
      child: child ??
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  value ?? '',
                  overflow: valueMaxLines == 1 ? TextOverflow.ellipsis : null,
                  maxLines: valueMaxLines,
                  textAlign: textAlign,
                  style: TextStyle(
                      height: 1.1,
                      fontSize: fontSize,
                      color: valueColor ??
                          (flag
                              ? ThemeUtil.getAccentColor(context)
                              : ThemeUtil.getBodyTextColor(context))),
                ),
              ),
              iconData != null
                  ? Icon(iconData,
                      size: 12, color: ThemeUtil.getAccentColor(context))
                  : Container()
            ],
          ),
    );

    return InkCell(
      padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
      circular: 0,
      onTap: (flag || clip)
          ? () {
              if (flag) {
                NavigatorUtil.launchUrl(url);
              } else {
                if (clipTap != null) {
                  clipTap();
                } else {
                  if (!StringUtil.isEmpty(value) && context != null) {
                    StringUtil.clip(value);
                    ToastUtil.show('已复制');
                  }
                }
              }
            }
          : null,
      child: Flex(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        direction: direction,
        children: <Widget>[
          SizedBox(height: direction == Axis.horizontal ? miniHeight : 0),
          Container(
            alignment: Alignment.topLeft,
            width: direction == Axis.horizontal ? tagWidth : double.infinity,
            child: Text(
              tag ?? '',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                  color: tagColor,
                  height: 1.1,
                  fontSize: fontSize,
                  fontWeight: tagHeight ? FontWeight.bold : FontWeight.normal),
            ),
          ),
          direction == Axis.horizontal
              ? Expanded(child: valueWidget)
              : valueWidget,
        ],
      ),
    );
  }
}
