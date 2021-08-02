import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../toast.dart';
import 'datetime_picker_theme.dart';
import 'date_model.dart';
import 'i18n_model.dart';

export 'datetime_picker_theme.dart';
export 'date_model.dart';
export 'i18n_model.dart';

typedef DateChangedCallback(DateTime time);
typedef DateCancelledCallback();
typedef String StringAtIndexCallBack(int index);

class DatePicker {
  static Future<DateTime> showDateHalfHourPicker(
    BuildContext context, {
    bool showTitleActions: true,
    DateTime minTime,
    DateTime maxTime,
    DateChangedCallback onChanged,
    DateChangedCallback onConfirm,
    DateCancelledCallback onCancel,
    String title,
    locale: LocaleType.zh,
    DateTime currentTime,
    DatePickerTheme theme,
  }) async {
    return await Navigator.of(context, rootNavigator: true).push(
        _DatePickerRoute(
            showTitleActions: showTitleActions,
            onChanged: onChanged,
            onConfirm: onConfirm,
            onCancel: onCancel,
            locale: locale,
            theme: theme,
            barrierLabel:
                MaterialLocalizations.of(context).modalBarrierDismissLabel,
            barrierColor: CupertinoDynamicColor.resolve(
                CupertinoDynamicColor.withBrightness(
                  color: Color(0x33000000),
                  darkColor: Color(0x7A000000),
                ),
                context),
            pickerModel: DateHalfHourPickerModel(
                currentTime: currentTime,
                maxTime: maxTime,
                minTime: minTime,
                locale: locale)));
  }

  static Future<DateTime> showDateHourPicker(
    BuildContext context, {
    bool showTitleActions: true,
    DateTime minTime,
    DateTime maxTime,
    DateChangedCallback onChanged,
    DateChangedCallback onConfirm,
    DateCancelledCallback onCancel,
    String title,
    locale: LocaleType.zh,
    DateTime currentTime,
    DatePickerTheme theme,
  }) async {
    return await Navigator.of(context, rootNavigator: true).push(
        _DatePickerRoute(
            showTitleActions: showTitleActions,
            onChanged: onChanged,
            onConfirm: onConfirm,
            onCancel: onCancel,
            locale: locale,
            theme: theme,
            barrierLabel:
                MaterialLocalizations.of(context).modalBarrierDismissLabel,
            barrierColor: CupertinoDynamicColor.resolve(
                CupertinoDynamicColor.withBrightness(
                  color: Color(0x33000000),
                  darkColor: Color(0x7A000000),
                ),
                context),
            pickerModel: DateHourPickerModel(
                currentTime: currentTime,
                maxTime: maxTime,
                minTime: minTime,
                locale: locale)));
  }

  static Future<DateTime> showDateAmPmPicker(
    BuildContext context, {
    bool showTitleActions: true,
    DateTime minTime,
    DateTime maxTime,
    bool isAm = true,
    DateChangedCallback onChanged,
    DateChangedCallback onConfirm,
    DateCancelledCallback onCancel,
    String title,
    locale: LocaleType.en,
    DateTime currentTime,
    DatePickerTheme theme,
  }) async {
    return await Navigator.of(context, rootNavigator: true).push(
        _DatePickerRoute(
            showTitleActions: showTitleActions,
            onChanged: onChanged,
            onConfirm: onConfirm,
            onCancel: onCancel,
            locale: locale,
            theme: theme,
            barrierLabel:
                MaterialLocalizations.of(context).modalBarrierDismissLabel,
            barrierColor: CupertinoDynamicColor.resolve(
                CupertinoDynamicColor.withBrightness(
                  color: Color(0x33000000),
                  darkColor: Color(0x7A000000),
                ),
                context),
            pickerModel: DateAmPmPickerModel(
                currentTime: currentTime,
                isAm: isAm,
                maxTime: maxTime,
                minTime: minTime,
                locale: locale)));
  }

  ///
  /// Display date picker bottom sheet.
  ///
  static Future<DateTime> showDatePicker(
    BuildContext context, {
    bool showTitleActions: true,
    DateTime minTime,
    DateTime maxTime,
    DateChangedCallback onChanged,
    DateChangedCallback onConfirm,
    DateCancelledCallback onCancel,
    String title,
    locale: LocaleType.en,
    DateTime currentTime,
    DatePickerTheme theme,
  }) async {
    return await Navigator.of(context, rootNavigator: true).push(
        _DatePickerRoute(
            showTitleActions: showTitleActions,
            onChanged: onChanged,
            onConfirm: onConfirm,
            onCancel: onCancel,
            locale: locale,
            theme: theme,
            title: title,
            barrierLabel:
                MaterialLocalizations.of(context).modalBarrierDismissLabel,
            barrierColor: CupertinoDynamicColor.resolve(
                CupertinoDynamicColor.withBrightness(
                  color: Color(0x33000000),
                  darkColor: Color(0x7A000000),
                ),
                context),
            pickerModel: DatePickerModel(
                currentTime: currentTime,
                maxTime: maxTime,
                minTime: minTime,
                locale: locale)));
  }

  ///
  /// Display time picker bottom sheet.
  ///
  static Future<DateTime> showTimePicker(
    BuildContext context, {
    bool showTitleActions: true,
    bool showSecondsColumn: true,
    DateChangedCallback onChanged,
    DateChangedCallback onConfirm,
    DateCancelledCallback onCancel,
    locale: LocaleType.en,
    DateTime currentTime,
    DatePickerTheme theme,
    String title,
  }) async {
    return await Navigator.of(context, rootNavigator: true).push(
        _DatePickerRoute(
            showTitleActions: showTitleActions,
            onChanged: onChanged,
            onConfirm: onConfirm,
            onCancel: onCancel,
            locale: locale,
            theme: theme,
            title: title,
            barrierLabel:
                MaterialLocalizations.of(context).modalBarrierDismissLabel,
            barrierColor: CupertinoDynamicColor.resolve(
                CupertinoDynamicColor.withBrightness(
                  color: Color(0x33000000),
                  darkColor: Color(0x7A000000),
                ),
                context),
            pickerModel: TimePickerModel(
                currentTime: currentTime,
                locale: locale,
                showSecondsColumn: showSecondsColumn)));
  }

  ///
  /// Display time picker bottom sheet with AM/PM.
  ///
  static Future<DateTime> showTime12hPicker(
    BuildContext context, {
    bool showTitleActions: true,
    DateChangedCallback onChanged,
    DateChangedCallback onConfirm,
    DateCancelledCallback onCancel,
    locale: LocaleType.en,
    DateTime currentTime,
    DatePickerTheme theme,
    String title,
  }) async {
    return await Navigator.of(context, rootNavigator: true).push(
      _DatePickerRoute(
          showTitleActions: showTitleActions,
          onChanged: onChanged,
          onConfirm: onConfirm,
          onCancel: onCancel,
          locale: locale,
          theme: theme,
          title: title,
          barrierLabel:
              MaterialLocalizations.of(context).modalBarrierDismissLabel,
          barrierColor: CupertinoDynamicColor.resolve(
              CupertinoDynamicColor.withBrightness(
                color: Color(0x33000000),
                darkColor: Color(0x7A000000),
              ),
              context),
          pickerModel:
              Time12hPickerModel(currentTime: currentTime, locale: locale)),
    );
  }

  ///
  /// Display date&time picker bottom sheet.
  ///
  static Future<DateTime> showDateTimePicker(
    BuildContext context, {
    bool showTitleActions: true,
    DateTime minTime,
    DateTime maxTime,
    DateChangedCallback onChanged,
    DateChangedCallback onConfirm,
    DateCancelledCallback onCancel,
    locale: LocaleType.en,
    DateTime currentTime,
    DatePickerTheme theme,
    String title,
  }) async {
    return await Navigator.of(context, rootNavigator: true).push(
      _DatePickerRoute(
        showTitleActions: showTitleActions,
        onChanged: onChanged,
        onConfirm: onConfirm,
        onCancel: onCancel,
        locale: locale,
        theme: theme,
        title: title,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: CupertinoDynamicColor.resolve(
            CupertinoDynamicColor.withBrightness(
              color: Color(0x33000000),
              darkColor: Color(0x7A000000),
            ),
            context),
        pickerModel: DateTimePickerModel(
            currentTime: currentTime,
            minTime: minTime,
            maxTime: maxTime,
            locale: locale),
      ),
    );
  }

  ///
  /// Display date picker bottom sheet witch custom picker model.
  ///
  static Future<DateTime> showPicker(
    BuildContext context, {
    bool showTitleActions: true,
    DateChangedCallback onChanged,
    DateChangedCallback onConfirm,
    DateCancelledCallback onCancel,
    locale: LocaleType.en,
    BasePickerModel pickerModel,
    DatePickerTheme theme,
    String title,
  }) async {
    return await Navigator.of(context, rootNavigator: true).push(
        _DatePickerRoute(
            showTitleActions: showTitleActions,
            onChanged: onChanged,
            onConfirm: onConfirm,
            onCancel: onCancel,
            locale: locale,
            theme: theme,
            barrierColor: CupertinoDynamicColor.resolve(
                CupertinoDynamicColor.withBrightness(
                  color: Color(0x33000000),
                  darkColor: Color(0x7A000000),
                ),
                context),
            barrierLabel:
                MaterialLocalizations.of(context).modalBarrierDismissLabel,
            title: title,
            pickerModel: pickerModel));
  }
}

class _DatePickerRoute<T> extends PopupRoute<T> {
  _DatePickerRoute({
    this.barrierColor,
    this.showTitleActions,
    this.onChanged,
    this.onConfirm,
    this.onCancel,
    theme,
    this.barrierLabel,
    this.locale,
    RouteSettings settings,
    pickerModel,
    this.title,
  })  : this.pickerModel = pickerModel ?? DatePickerModel(),
        this.theme = theme ?? DatePickerTheme(),
        super(settings: settings);

  final bool showTitleActions;
  final DateChangedCallback onChanged;
  final DateChangedCallback onConfirm;
  final DateCancelledCallback onCancel;
  final DatePickerTheme theme;
  final LocaleType locale;
  final BasePickerModel pickerModel;
  final String title;

  Animation<double> _animation;
  Tween<Offset> _offsetTween;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  bool get barrierDismissible => true;

  @override
  final String barrierLabel;

  @override
  final Color barrierColor;

  @override
  Animation<double> createAnimation() {
    assert(_animation == null);
    _animation = CurvedAnimation(
      parent: super.createAnimation(),

      // These curves were initially measured from native iOS horizontal page
      // route animations and seemed to be a good match here as well.
      curve: Curves.linearToEaseOut,
      reverseCurve: Curves.linearToEaseOut.flipped,
    );
    _offsetTween = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: const Offset(0.0, 0.0),
    );
    return _animation;
  }

//  Widget buildPage2(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
//    Widget bottomSheet = new MediaQuery.removePadding(
//      context: context,
//      removeTop: true,
//      child: _DatePickerComponent(
//        onChanged: onChanged,
//        locale: this.locale,
//        route: this,
//        pickerModel: pickerModel,
//        title: title,
//      ),
//    );
//    ThemeData inheritTheme = Theme.of(context, shadowThemeOnly: true);
//    if (inheritTheme != null) {
//      bottomSheet = new Theme(data: inheritTheme, child: bottomSheet);
//    }
//    return bottomSheet;
//  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    Widget bottomSheet = new MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: _DatePickerComponent(
        onChanged: onChanged,
        locale: this.locale,
        route: this,
        pickerModel: pickerModel,
        title: title,
      ),
    );
//    ThemeData inheritTheme = Theme.of(context, shadowThemeOnly: true);
//    if (inheritTheme != null) {
//      bottomSheet = new Theme(data: inheritTheme, child: bottomSheet);
//    }
    return CupertinoUserInterfaceLevel(
      data: CupertinoUserInterfaceLevelData.elevated,
      child: bottomSheet,
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: FractionalTranslation(
        translation: _offsetTween.evaluate(_animation),
        child: child,
      ),
    );
  }
}

class _DatePickerComponent extends StatefulWidget {
  _DatePickerComponent(
      {Key key,
      @required this.route,
      this.onChanged,
      this.locale,
      this.pickerModel,
      this.title})
      : super(key: key);

  final DateChangedCallback onChanged;

  final _DatePickerRoute route;

  final LocaleType locale;

  final BasePickerModel pickerModel;

  final String title;

  @override
  State<StatefulWidget> createState() {
    return _DatePickerState();
  }
}

class _DatePickerState extends State<_DatePickerComponent> {
  FixedExtentScrollController leftScrollCtrl,
      middleScrollCtrl,
      rightScrollCtrl,
      rightEndScrollCtrl;

  @override
  void initState() {
    super.initState();
    refreshScrollOffset();
  }

  void refreshScrollOffset() {
//    print('refreshScrollOffset ${widget.pickerModel.currentRightIndex()}');
    leftScrollCtrl = new FixedExtentScrollController(
        initialItem: widget.pickerModel.currentLeftIndex());
    middleScrollCtrl = new FixedExtentScrollController(
        initialItem: widget.pickerModel.currentMiddleIndex());
    rightScrollCtrl = new FixedExtentScrollController(
        initialItem: widget.pickerModel.currentRightIndex());
    if (widget.pickerModel.currentRightEndIndex() != null) {
      // L.i('rightEndScrollCtrl');
      rightEndScrollCtrl = new FixedExtentScrollController(
          initialItem: widget.pickerModel.currentRightEndIndex());
    }
  }

  @override
  Widget build(BuildContext context) {
    DatePickerTheme theme = widget.route.theme;
    return GestureDetector(
      child: AnimatedBuilder(
        animation: widget.route.animation,
        builder: (BuildContext context, Widget child) {
          final double bottomPadding = MediaQuery.of(context).padding.bottom;
          return Padding(
            padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: CustomSingleChildLayout(
                delegate: _BottomPickerLayout(
                    widget.route.animation.value, theme,
                    showTitleActions: widget.route.showTitleActions,
                    bottomPadding: bottomPadding),
                child: GestureDetector(
                  child: Material(
                    color: theme.backgroundColor ?? Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    child: _renderPickerView(theme),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _notifyDateChanged() {
    if (widget.onChanged != null) {
      widget.onChanged(widget.pickerModel.finalTime());
    }
  }

  Widget _renderPickerView(DatePickerTheme theme) {
    Widget itemView = _renderItemView(theme);
    if (widget.route.showTitleActions) {
      return Column(
        children: <Widget>[
          _renderTitleActionsView(theme, title: widget.title),
          itemView,
        ],
      );
    }
    return itemView;
  }

  Widget _renderColumnView(
      ValueKey key,
      DatePickerTheme theme,
      StringAtIndexCallBack stringAtIndexCB,
      ScrollController scrollController,
      int layoutProportion,
      ValueChanged<int> selectedChangedWhenScrolling,
      ValueChanged<int> selectedChangedWhenScrollEnd) {
    return Expanded(
      flex: layoutProportion,
      child: Container(
          padding: EdgeInsets.all(8.0),
          height: theme.containerHeight,
          decoration:
              BoxDecoration(color: theme.backgroundColor ?? Colors.white),
          child: NotificationListener(
              onNotification: (ScrollNotification notification) {
                if (notification.depth == 0 &&
                    selectedChangedWhenScrollEnd != null &&
                    notification is ScrollEndNotification &&
                    notification.metrics is FixedExtentMetrics) {
                  final FixedExtentMetrics metrics = notification.metrics;
                  final int currentItemIndex = metrics.itemIndex;
                  selectedChangedWhenScrollEnd(currentItemIndex);
                }
                return false;
              },
              child: CupertinoPicker.builder(
                  key: key,
                  backgroundColor: theme.backgroundColor ?? Colors.white,
                  scrollController: scrollController,
                  itemExtent: theme.itemHeight,
                  onSelectedItemChanged: (int index) {
                    selectedChangedWhenScrolling(index);
                  },
                  useMagnifier: true,
                  itemBuilder: (BuildContext context, int index) {
                    final content = stringAtIndexCB(index);
                    if (content == null) {
                      return null;
                    }
                    return Container(
                      height: theme.itemHeight,
                      alignment: Alignment.center,
                      child: Text(
                        content,
                        style: theme.itemStyle,
                        textAlign: TextAlign.start,
                      ),
                    );
                  }))),
    );
  }

  Widget _renderItemView(DatePickerTheme theme) {
    List<Widget> items = [
      Container(
        child: widget.pickerModel.layoutProportions()[0] > 0
            ? _renderColumnView(
                ValueKey(widget.pickerModel.currentLeftIndex() * 1000000),
                theme,
                widget.pickerModel.leftStringAtIndex,
                leftScrollCtrl,
                widget.pickerModel.layoutProportions()[0], (index) {
                widget.pickerModel.setLeftIndex(index);
              }, (index) {
                setState(() {
                  refreshScrollOffset();
                  _notifyDateChanged();
                });
              })
            : null,
      ),
      Text(
        widget.pickerModel.leftDivider(),
        style: theme.itemStyle,
      ),
      Container(
        child: widget.pickerModel.layoutProportions()[1] > 0
            ? _renderColumnView(
                ValueKey(widget.pickerModel.currentLeftIndex() * 1000000 +
                    widget.pickerModel.currentMiddleIndex() * 10000),
                theme,
                widget.pickerModel.middleStringAtIndex,
                middleScrollCtrl,
                widget.pickerModel.layoutProportions()[1], (index) {
                widget.pickerModel.setMiddleIndex(index);
              }, (index) {
                setState(() {
                  refreshScrollOffset();
                  _notifyDateChanged();
                });
              })
            : null,
      ),
      Text(
        widget.pickerModel.rightDivider(),
        style: theme.itemStyle,
      ),
      Container(
        child: widget.pickerModel.layoutProportions()[2] > 0
            ? _renderColumnView(
                ValueKey(widget.pickerModel.currentLeftIndex() * 1000000 +
                    widget.pickerModel.currentMiddleIndex() * 10000 +
                    widget.pickerModel.currentRightIndex() * 100),
                theme,
                widget.pickerModel.rightStringAtIndex,
                rightScrollCtrl,
                widget.pickerModel.layoutProportions()[2], (index) {
                widget.pickerModel.setRightIndex(index);
                _notifyDateChanged();
              }, (index) {
                if (widget.pickerModel.layoutProportions().length > 3) {
                  setState(() {
                    refreshScrollOffset();
                    _notifyDateChanged();
                  });
                }
              })
            : null,
      ),
    ];

    if (widget.pickerModel.layoutProportions().length == 4) {
      items.addAll([
        Text(
          widget.pickerModel.rightEndDiver(),
          style: theme.itemStyle,
        ),
        Container(
          child: widget.pickerModel.layoutProportions()[3] > 0
              ? _renderColumnView(
                  ValueKey(widget.pickerModel.currentLeftIndex() * 1000000 +
                      widget.pickerModel.currentMiddleIndex() * 10000 +
                      widget.pickerModel.currentRightIndex() * 100 +
                      widget.pickerModel.currentRightEndIndex()),
                  theme,
                  widget.pickerModel.rightEndStringAtIndex,
                  rightEndScrollCtrl,
                  widget.pickerModel.layoutProportions()[3], (index) {
                  widget.pickerModel.setRightEndIndex(index);
                  _notifyDateChanged();
                }, null)
              : null,
        ),
      ]);
    }

    return Container(
      color: theme.backgroundColor ?? Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items,
      ),
    );
  }

  // Title View
  Widget _renderTitleActionsView(DatePickerTheme theme, {String title}) {
    String done = _localeDone();
    String cancel = _localeCancel();

    return Container(
      height: theme.titleHeight,
      child: Row(
        children: <Widget>[
          Container(
            height: theme.titleHeight,
            child: CupertinoButton(
              pressedOpacity: 0.3,
              padding: EdgeInsets.only(left: 16, top: 0),
              child: Text(
                '$cancel',
                style: theme.cancelStyle,
              ),
              onPressed: () {
                Navigator.pop(context);
                if (widget.route.onCancel != null) {
                  widget.route.onCancel();
                }
              },
            ),
          ),
          Expanded(
            child: Container(
              height: theme.titleHeight,
              alignment: Alignment.center,
              child: Text(
                title ?? '',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            height: theme.titleHeight,
            child: CupertinoButton(
              pressedOpacity: 0.3,
              padding: EdgeInsets.only(right: 16, top: 0),
              child: Text('$done', style: theme.doneStyle),
              onPressed: () {
                if (widget.pickerModel is DatePickerModel ||
                    widget.pickerModel is DateTimePickerModel) {
                  DateTime _minTime;
                  DateTime _maxTime;
                  if (widget.pickerModel is DatePickerModel) {
                    DatePickerModel _model =
                        widget.pickerModel as DatePickerModel;
                    _minTime = _model.minTime;
                    if (_minTime.year == 1970 &&
                        _minTime.month == 1 &&
                        _minTime.day == 1) {
                      _minTime = null;
                    }
                    _maxTime = _model.maxTime;
                    if (_maxTime.year == 2049 &&
                        _maxTime.month == 12 &&
                        _maxTime.day == 31) {
                      _maxTime = null;
                    }
                  } else {
                    DateTimePickerModel _model =
                        widget.pickerModel as DateTimePickerModel;
                    _minTime = _model.minTime;
                    _maxTime = _model.maxTime;
                  }
                  print(widget.pickerModel.finalTime());
                  print(_maxTime);
                  if (_maxTime != null &&
                      widget.pickerModel.finalTime().isAfter(_maxTime)) {
                    ToastUtil.showError('你选择的时间超出了范围，请重新选择！');
                    return;
                  }
                  if (_minTime != null &&
                      widget.pickerModel.finalTime().isBefore(_minTime)) {
                    ToastUtil.showError('你选择的时间超出了范围，请重新选择！');
                    return;
                  }
                }
                Navigator.pop(context, widget.pickerModel.finalTime());
                if (widget.route.onConfirm != null) {
                  widget.route.onConfirm(widget.pickerModel.finalTime());
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  String _localeDone() {
    return i18nObjInLocale(widget.locale)['done'];
  }

  String _localeCancel() {
    return i18nObjInLocale(widget.locale)['cancel'];
  }
}

class _BottomPickerLayout extends SingleChildLayoutDelegate {
  _BottomPickerLayout(this.progress, this.theme,
      {this.itemCount, this.showTitleActions, this.bottomPadding = 0});

  final double progress;
  final int itemCount;
  final bool showTitleActions;
  final DatePickerTheme theme;
  final double bottomPadding;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    double maxHeight = theme.containerHeight;
    if (showTitleActions) {
      maxHeight += theme.titleHeight;
    }

    return new BoxConstraints(
        minWidth: constraints.maxWidth,
        maxWidth: constraints.maxWidth,
        minHeight: 0.0,
        maxHeight: maxHeight + bottomPadding);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    double height = size.height - childSize.height * progress;
    return new Offset(0.0, height);
  }

  @override
  bool shouldRelayout(_BottomPickerLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
