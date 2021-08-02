import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'application.dart';
import 'pop_param.dart';

class NavigatorUtil {
  static Future<PopParam> pushRouter(BuildContext context, String path,
      {bool replace = false,
      bool clearStack = false,
      TransitionType transition = TransitionType.inFromRight}) async {
    assert(context != null);
    FocusScope.of(context).requestFocus(FocusNode());
    var result = await Application.router.navigateTo(
      context,
      path,
      replace: replace,
      clearStack: clearStack,
      transition: transition,
      transitionDuration: Duration(milliseconds: 200),
    );
    if (result != null && result is PopParam) return result;
    return PopParam(false, null);
  }

  static Future<PopParam> push(BuildContext context, Widget page) async {
    assert(context != null && page != null);
    FocusScope.of(context).requestFocus(FocusNode());
    var result = await Navigator.push(
        context, CupertinoPageRoute(builder: (ctx) => page));
    if (result != null && result is PopParam) return result;
    return PopParam(false, null);
  }

  static void pop(BuildContext context, {bool success, dynamic data}) {
    FocusScope.of(context).requestFocus(FocusNode());
    if (Navigator.canPop(context)) {
      if (success == null) {
        Navigator.pop(context);
      } else {
        Navigator.pop(context, PopParam(success, data));
      }
    }
  }

  /// 拨打号码
  static void launchTel(String tel) => launch("tel:$tel");

  static void launchUrl(String url) => launch(url);

  ///  发送邮件
  static void launchMail(String email) => launch("mailto:$email");
}
