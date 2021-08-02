library flutter_screen;

export 'screenutil_init.dart';

import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A Calculator.
class ScreenUtil {
  static ScreenUtil _instance;
  static const Size defaultSize = Size(1080, 1920);
  static double _pixelRatio;
  static double _screenWidth;
  static double _screenHeight;
  static double _statusBarHeight;
  static double _bottomBarHeight;
  static double _textScaleFactor;
  static Size _webSize;

  /// UI设计中手机尺寸 , px
  /// Size of the phone in UI Design , px
  Size uiSize = defaultSize;

  /// 控制字体是否要根据系统的“字体大小”辅助选项来进行缩放。默认值为false。
  /// allowFontScaling Specifies whether fonts should scale to respect Text Size accessibility settings. The default is false.
  bool allowFontScaling = false;

  /// 实际的dp与UI设计px的比例
  /// The ratio of the actual dp to the design draft px
  double get scaleWidth => _scaleWidth;
  double _scaleWidth;

  double get scaleHeight => _scaleHeight;
  double _scaleHeight;

  ScreenUtil._();

  factory ScreenUtil() {
    assert(
      _instance != null,
      '\nEnsure to initialize ScreenUtil before accessing it.\nPlease execute the init method : ScreenUtil.init()',
    );
    return _instance;
  }

  /// [defaultSize] - 设计尺寸
  static void init(
    BoxConstraints constraints, {
    Size designSize = defaultSize,
    bool allowFontScaling = false,
    Size webSize = defaultSize,
  }) {
    _webSize = webSize;
    _instance ??= ScreenUtil._();
    _instance
      ..uiSize = designSize
      ..allowFontScaling = allowFontScaling;
    // MediaQueryData mediaQuery = MediaQuery.of(context);
    var window = WidgetsBinding.instance?.window ?? ui.window;
    _pixelRatio = window.devicePixelRatio;
    // _pixelRatio = mediaQuery.devicePixelRatio;
    if (designSize.width > designSize.height) {
      _screenWidth = max(constraints.maxWidth, constraints.maxHeight);
      _screenHeight = min(constraints.maxWidth, constraints.maxHeight);
    } else {
      _screenWidth = min(constraints.maxWidth, constraints.maxHeight);
      _screenHeight = max(constraints.maxWidth, constraints.maxHeight);
    }
    _instance._scaleWidth = _screenWidth / designSize.width;
    _instance._scaleHeight = _screenHeight / designSize.height;

    // _statusBarHeight = mediaQuery.padding.top;
    // _bottomBarHeight = mediaQuery.padding.bottom;
    // _textScaleFactor = mediaQuery.textScaleFactor;
    _statusBarHeight = window.padding.top;
    _bottomBarHeight = window.padding.bottom;
    _textScaleFactor = window.textScaleFactor;
  }

  /// 每个逻辑像素的字体像素数，字体的缩放比例
  /// The number of font pixels for each logical pixel.
  double get textScaleFactor => _textScaleFactor;

  /// 设备的像素密度
  /// The size of the media in logical pixels (e.g, the size of the screen).
  double get pixelRatio => _pixelRatio;

  /// 当前设备宽度 dp
  /// The horizontal extent of this size.
  double get screenWidth =>
      kIsWeb ? min(_webSize.width, _screenWidth) : _screenWidth;

  ///当前设备高度 dp
  ///The vertical extent of this size. dp
  double get screenHeight =>
      kIsWeb ? min(_webSize.height, _screenHeight) : _screenHeight;

  /// 当前设备宽度 px
  /// The vertical extent of this size. px
  double get screenWidthPx => _screenWidth * _pixelRatio;

  /// 当前设备高度 px
  /// The vertical extent of this size. px
  double get screenHeightPx => _screenHeight * _pixelRatio;

  /// 状态栏高度 dp 刘海屏会更高
  /// The offset from the top
  double get statusBarHeight => _statusBarHeight;

  /// 底部安全区距离 dp
  /// The offset from the bottom.
  double get bottomBarHeight => _bottomBarHeight;

  double get scaleText => scaleWidth;

  /// 根据UI设计的设备宽度适配
  /// 高度也可以根据这个来做适配可以保证不变形,比如你先要一个正方形的时候.
  /// Adapted to the device width of the UI Design.
  /// Height can also be adapted according to this to ensure no deformation ,
  /// if you want a square
  double setWidth(num width) => kIsWeb ? width / 2 : width * scaleWidth;

  /// 根据UI设计的设备高度适配
  /// 当发现UI设计中的一屏显示的与当前样式效果不符合时,
  /// 或者形状有差异时,建议使用此方法实现高度适配.
  /// 高度适配主要针对想根据UI设计的一屏展示一样的效果
  /// Highly adaptable to the device according to UI Design
  /// It is recommended to use this method to achieve a high degree of adaptation
  /// when it is found that one screen in the UI design
  /// does not match the current style effect, or if there is a difference in shape.
  double setHeight(num height) => kIsWeb ? height / 2 : height * scaleHeight;

  ///字体大小适配方法
  ///- [fontSize] UI设计上字体的大小,单位px.
  ///Font size adaptation method
  ///- [fontSize] The size of the font on the UI design, in px.
  ///- [allowFontScaling]
  double setSp(num fontSize, {bool allowFontScalingSelf}) => kIsWeb
      ? fontSize / 2
      : (allowFontScalingSelf == null
          ? (allowFontScaling
              ? (fontSize * scaleText)
              : ((fontSize * scaleText) / _textScaleFactor))
          : (allowFontScalingSelf
              ? (fontSize * scaleText)
              : ((fontSize * scaleText) / _textScaleFactor)));
}

extension ScreenExtension on num {
  ///[ScreenUtil.setWidth]
  double get w => ScreenUtil().setWidth(this);

  ///[ScreenUtil.setHeight]
  double get h => ScreenUtil().setHeight(this);

  ///[ScreenUtil.setSp]
  double get sp => ScreenUtil().setSp(this);

  ///[ScreenUtil.setSp]
  double get ssp => ScreenUtil().setSp(this, allowFontScalingSelf: true);

  ///[ScreenUtil.setSp]
  double get nsp => ScreenUtil().setSp(this, allowFontScalingSelf: false);

  ///屏幕宽度的倍数
  ///Multiple of screen width
  double get sw => ScreenUtil().screenWidth * this;

  ///屏幕高度的倍数
  ///Multiple of screen height
  double get sh => ScreenUtil().screenHeight * this;
}
