import 'package:flutter/material.dart';

import 'height_key_widget.dart';

class LineCell extends StatelessWidget {
  final String title;
  final Color color;
  final Widget titleChild;
  final Widget leading;
  final IconData iconData;
  final Color iconColor;
  final String iconPath;
  final String subLabel;
  final Widget subLabelChild;
  final bool showNext;
  final TextStyle titleStyle;
  final TextStyle subLabelStyle;
  final bool showLine;
  final double height;
  final String heightKey;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final EdgeInsetsGeometry padding;

  const LineCell({
    Key key,
    this.title,
    this.titleChild,
    this.iconData,
    this.subLabel,
    this.showNext = true,
    this.titleStyle,
    this.subLabelStyle,
    this.showLine = true,
    this.onTap,
    this.onLongPress,
    this.iconPath,
    this.color,
    this.subLabelChild,
    this.leading,
    this.height = 55,
    this.heightKey,
    this.iconColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 25),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget iconWidget = Container();
    if (this.leading != null) {
      iconWidget = this.leading;
    } else if (this.iconData != null) {
      iconWidget = Icon(this.iconData, color: iconColor, size: 18);
    } else if (this.iconPath != null && this.iconPath.isNotEmpty) {
      iconWidget = Image.asset(this.iconPath);
    }
    return Material(
      color: this.color ?? Theme.of(context).canvasColor,
      child: Ink(
        color: this.color ?? Theme.of(context).canvasColor,
        child: InkWell(
          onTap: this.onTap,
          onLongPress: this.onLongPress,
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: this.height,
                  padding: padding,
                  child: Row(
                    children: <Widget>[
                      iconWidget,
                      SizedBox(width: 15),
                      Expanded(
                        child: this.titleChild ??
                            HeightKeyWidget(
                              content: this.title ?? '',
                              textStyle: this.titleStyle ??
                                  Theme.of(context).textTheme.bodyText2,
                              heightKey: heightKey,
                              makLines: 1,
                            ),
                      ),
                      this.subLabelChild ??
                          Text(
                            subLabel ?? '',
                            style: this.subLabelStyle ??
                                Theme.of(context).textTheme.bodyText2,
                          ),
                      this.showNext
                          ? Icon(Icons.navigate_next, color: Color(0xff8c95ac))
                          : Container()
                    ],
                  ),
                ),
                Container(
                  height: showLine == true ? 0.5 : 0.0,
                  color: Theme.of(context).dividerColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
