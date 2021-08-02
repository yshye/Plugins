import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tools/util/string_util.dart';
import 'package:oktoast/oktoast.dart';

import '../../router/navigator_util.dart';
import '../tool.dart';
import '../typedef.dart';
import 'bottom_sheet_dialog.dart';
import 'customize_dialog.dart';

Future showCustomizeDialog(
  BuildContext context,
  Widget widget, {
  bool barrierDismissible = true,
  Future<bool> Function() onWillPop,
}) {
  return showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (ctx) => WillPopScope(
        onWillPop: () => onWillPop ?? Future.value(barrierDismissible),
        child: CustomizeDialog(
          child: widget,
          barrierDismissible: barrierDismissible,
        )),
  );

  // return showTransparentDialog(
  //   context: context,
  //   barrierDismissible: barrierDismissible,
  //   builder: (_) {
  //     return WillPopScope(
  //         onWillPop: () => onWillPop ?? Future.value(barrierDismissible),
  //         child: CustomizeDialog(
  //           child: widget,
  //           barrierDismissible: barrierDismissible,
  //         ));
  //   },
  // );
}

/// 默认dialog背景色为半透明黑色，这里修改源码改为透明
Future showTransparentDialog({
  @required BuildContext context,
  bool barrierDismissible = true,
  WidgetBuilder builder,
}) {
  // , shadowThemeOnly: true
  final ThemeData theme = Theme.of(context);
  return showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext buildContext, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      final Widget pageChild = Builder(builder: builder);
      return SafeArea(
        child: Builder(builder: (BuildContext context) {
          return theme != null
              ? Theme(data: theme, child: pageChild)
              : pageChild;
        }),
      );
    },
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: const Color(0x00FFFFFF),
    transitionDuration: const Duration(milliseconds: 150),
    transitionBuilder: _buildMaterialDialogTransitions,
  );
}

Widget _buildMaterialDialogTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child) {
  return FadeTransition(
    opacity: CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    ),
    child: child,
  );
}

void showConfirmDialog(BuildContext context, String content,
    {String title,
    String colorContent,
    String cancelText,
    onCancelPressed,
    String okText,
    VoidCallback onOkPressed,
    bool left = false}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => CupertinoAlertDialog(
      title: Text(title ?? "提示"),
      content: Container(
        alignment: left ? Alignment.centerLeft : Alignment.center,
        padding: EdgeInsets.only(top: 10),
        child: buildSearchSpan(content ?? '', colorContent ?? '',
            style: TextStyle(
                height: 1.5,
                color: Theme.of(context).textTheme.bodyText2.color)),
      ),
      actions: <Widget>[
        CupertinoButton(
          child: Text(cancelText ?? "取消"),
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8)),
          onPressed: () {
            NavigatorUtil.pop(context);
            if (onCancelPressed != null) onCancelPressed();
          },
        ),
        CupertinoButton(
          child: Text(okText ?? "确认", style: TextStyle(color: Colors.red)),
          onPressed: () {
            NavigatorUtil.pop(context);
            if (onOkPressed != null) onOkPressed();
          },
        )
      ],
    ),
  );
}

void showMassageDialog(BuildContext context, String content,
    {String title,
    String colorContent,
    String buttonText = '知道了',
    VoidCallback onPressed,
    TextStyle titleStyle,
    bool left = false}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => CupertinoAlertDialog(
      title: Text(title ?? "提示", style: titleStyle),
      content: GestureDetector(
        onLongPress: () {
          StringUtil.clip(content);
          showToast('已复制');
        },
        child: Container(
          alignment: left ? Alignment.centerLeft : Alignment.center,
          padding: EdgeInsets.only(top: 10),
          child: buildSearchSpan(content ?? '', colorContent ?? '',
              style: TextStyle(height: 1.5, color: Colors.black)),
        ),
      ),
      actions: <Widget>[
        CupertinoButton(
          child: Text(buttonText,
              style: TextStyle(color: Theme.of(context).primaryColor)),
          onPressed: () {
            if (onPressed != null) {
              onPressed();
            } else {
              NavigatorUtil.pop(context);
            }
          },
        )
      ],
    ),
  );
}

Future<int> showBottomPopup<T>(
    BuildContext context, String title, List<T> items,
    {String message,
    BuildCheckChild<T> buildCheckChild,
    double height,
    bool autoHeight = false}) async {
  if (autoHeight && height == null) {
    if (items.length < 5) {
      height = 40 + items.length * MediaQuery.of(context).size.height * 4 / 45;
    }
  }
  return showCupertinoModalPopup(
    context: context,
//        isScrollControlled: true,
//        backgroundColor: Colors.transparent,
    builder: (ctx) => BottomSheetDialog(
      height: height ?? MediaQuery.of(context).size.height * 4 / 9,
      titleLeft: Container(),
      titleRight: CupertinoButton(
        child: Icon(Icons.clear, color: Colors.grey),
        padding: EdgeInsets.all(10),
        onPressed: () => NavigatorUtil.pop(ctx),
      ),
      title: Text(title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      children: items
          .map((item) => ListTile(
                title: buildCheckChild != null
                    ? buildCheckChild(ctx, item)
                    : Text('${item}', style: TextStyle(fontSize: 16)),
                onTap: () => Navigator.pop(ctx, items.indexOf(item)),
              ))
          .toList(),
    ),
  );

//  final ThemeData theme = Theme.of(context);
//  final TextStyle dialogTextStyle = theme.textTheme.subtitle1.copyWith(color: theme.textTheme.caption.color);
//  List<CupertinoActionSheetAction> itemSheet = [];
//  for (var i = 0; i < items.length; ++i) {
//    itemSheet.add(
//      CupertinoActionSheetAction(
//        onPressed: () => Navigator.pop(context, i),
//        child: buildCheckChild != null
//            ? buildCheckChild(context, items[i])
//            : Text('${items[i]}', style: TextStyle(fontSize: 16)),
//      ),
//    );
//  }
//  return await showCupertinoModalPopup<int>(
//    context: context,
//    builder: (context) => CupertinoActionSheet(
//      title: Text(title ?? '请选择'),
//      message: message == null ? null : Text(message, style: dialogTextStyle),
//      actions: itemSheet,
//      cancelButton: CupertinoActionSheetAction(
//        child: const Text('取消'),
//        isDefaultAction: true,
//        onPressed: () => Navigator.pop(context, null),
//      ),
//    ),
//  );
}
