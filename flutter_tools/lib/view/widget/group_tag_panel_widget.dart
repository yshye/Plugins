import 'package:flutter/material.dart';
import 'package:flutter_tools/view/model/tag_value_model.dart';

import 'tag_panel_widget.dart';

class GroupTagPanelWidget extends StatelessWidget {
  final String groupTitle;
  final TextStyle groupTitleStyle;
  final Color groupTitleColor;
  final EdgeInsets groupTitlePadding;
  final EdgeInsets panelPadding;
  final List<TagValueModel> items;
  final double tagWidth;
  final Color tagColor;
  final Color valueColor;
  final Color panelColor;
  final TextAlign textAlign;
  final double fontSize;
  final Color titlePrefixColor;

  const GroupTagPanelWidget({
    Key key,
    this.groupTitle,
    this.groupTitleStyle,
    this.groupTitleColor,

    this.items,
    this.groupTitlePadding,
    this.panelPadding,
    this.tagWidth = 100,
    this.tagColor = const Color(0xff939baf),
    this.valueColor = const Color(0xff5d6478),
    this.panelColor = Colors.white,
    this.textAlign = TextAlign.left,
    this.fontSize = 16,
    this.titlePrefixColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding:
              groupTitlePadding ?? EdgeInsets.only(bottom: 5, left: 10, top: 5),
          width: double.infinity,
          color: groupTitleColor,
          child: Row(children: [
            if(titlePrefixColor!=null)...{
              Container(
                width: 3,
                height: 20,
                color: titlePrefixColor,
                margin: EdgeInsets.only(right: 5),
              ),
            },
            Text(
              groupTitle ?? '',
              style: groupTitleStyle ??
                  TextStyle(fontSize: 16, color: Color(0xff9fa7b7)),
            ),
          ],)
        ),
        TagPanelWidget(
          items,
          tagWidth: tagWidth,
          tagColor: tagColor,
          valueColor: valueColor,
          panelColor: panelColor,
          padding: panelPadding ?? EdgeInsets.only(bottom: 5, left: 10, top: 5,right: 5),
          fontSize: fontSize,
          textAlign: textAlign,
        )
      ],
    );
  }
}
