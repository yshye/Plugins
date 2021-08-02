// part of flutter_screen;

import 'package:flutter/material.dart';

import 'flutter_screen.dart';

class ScreenUtilInit extends StatelessWidget {
  /// A helper widget that initializes [ScreenUtil]
  ScreenUtilInit({
    this.builder,
    this.designSize = ScreenUtil.defaultSize,
    this.webSize = ScreenUtil.defaultSize,
    Key key,
  }) : super(key: key);

  final Widget Function() builder;

  /// The [Size] of the device in the design draft, in dp
  final Size designSize;

  final Size webSize;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, BoxConstraints constraints) {
      return OrientationBuilder(
        builder: (_, Orientation orientation) {
          if (constraints.maxWidth != 0) {
            ScreenUtil.init(
              constraints,
              designSize: designSize,
              webSize: webSize,
            );
            return builder();
          }
          return Container();
        },
      );
    });
  }
}
