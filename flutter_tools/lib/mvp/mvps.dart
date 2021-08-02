import 'package:flutter/material.dart';

import 'view_lifecycle.dart';

abstract class IMvpView {
  BuildContext getContext();

  /// 显示Progress
  void showProgress();

  /// 关闭Progress
  void closeProgress();

  /// 展示Toast
  void showToast(String string,
      {TextStyle textStyle, bool dismissOtherToast = true});

  void showError(String error);
}

abstract class IMvpListView extends IMvpView {
  /// 获取数据[more] - true:加载更多，-false：下拉刷新
  void updateListUI(bool more, List value, {bool show = true});
}

abstract class IMvpPresenter extends IViewLifecycle {}

abstract class IMvpListPresenter extends IMvpPresenter {
  fetchData(bool more);
}
