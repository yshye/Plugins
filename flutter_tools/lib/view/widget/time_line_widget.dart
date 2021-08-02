import 'package:flutter/material.dart';

import '../../util/theme_util.dart';
import 'separator_widget.dart';

class TimeLineWidget extends StatelessWidget {
  final Widget rightWidget;
  final Widget titleWidget;
  final Widget subWidget;
  final Widget pointWidget;
  final bool showHorizontal;
  final bool showVertical;
  final Color color;
  final Color printColor;
  final double leftSpace;
  final double topSpace;
  final double lineLeft;
  final double pointLeft;
  final bool showTopLine;

  TimeLineWidget({
    this.titleWidget,
    this.subWidget,
    this.pointWidget,
    this.rightWidget,
    this.showHorizontal = true,
    this.showVertical = true,
    this.showTopLine = true,
    this.color,
    this.printColor,
    this.leftSpace = 20,
    this.topSpace = 3,
    this.lineLeft = 10,
    this.pointLeft = 6,
  });

  @override
  Widget build(BuildContext context) {
    Widget _pointWidget = pointWidget ??
        ClipOval(
            child: Container(
                width: 12,
                height: 12,
                color: printColor ?? ThemeUtil.getAccentColor(context)));
    Widget _rightWidget = rightWidget ??
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: topSpace == 0 ? 4 : 0),
            titleWidget ?? Container(),
            SizedBox(height: 12.0),
            subWidget ?? Container(),
            SizedBox(height: 12.0),
          ],
        );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: leftSpace + 10),
                child: _rightWidget,
              ),
              Positioned(
                left: lineLeft,
                top: showTopLine ? 0 : topSpace,
                bottom: 0,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          // padding: EdgeInsets.only(left: lineLeft),
                          child: showVertical
                              ? SeparatorWidget(
                                  color: color,
                                  emptyDash: 0,
                                  dash: 2,
                                  lineWidth: 0.6,
                                )
                              : Container(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                left: pointLeft - 2,
                width: leftSpace,
                top: topSpace,
                child: Row(
                  children: <Widget>[
                    _pointWidget,
                    showHorizontal
                        ? Expanded(
                            child: SeparatorWidget(
                                direction: Axis.horizontal,
                                emptyDash: 0,
                                color: color),
                          )
                        : Container()
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
