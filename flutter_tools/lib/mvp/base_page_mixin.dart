import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../router/navigator_util.dart';
import '../router/pop_param.dart';
import '../view/a.dart';
import '../view/toast.dart';
import '../view/typedef.dart';
import '../view/widget/empty_widget.dart';
import '../view/widget/loading_list_widget.dart';
import 'base_list_provider.dart';
import 'base_presenter.dart';
import 'base_view_model.dart';
import 'mvps.dart';

mixin ListPageMixin<T extends StatefulWidget, P extends BaseListPresenter,
        Pro extends BaseListProvider> on BasePageMixin<T, P>
    implements IMvpListView {
  ScrollController easyRefreshScrollController;
  P presenter;

  P createPresenter();

  Pro listProvider;

  @override
  void initState() {
    easyRefreshScrollController = ScrollController();
    listProvider = createProvider();
    super.initState();
  }

  @override
  Widget buildBody() {
    return BaseView<Pro>(
      model: listProvider,
      builder: (_, provider, __) => Material(
        color: getBackgroundColor(),
        child: Container(
          child: EasyRefresh(
            firstRefresh: firstRefresh(),
            emptyWidget: provider.showEmptyWidget
                ? EmptyWidget(
                    emptyImageAsset: getEmptyImageAsset(),
                    emptyMessage: getEmptyMessage(),
                    child: getEmptyChild())
                : provider.list.length == 0
                    ? LoadingListWidget(
                        itemChild: getLoadingChild(),
                        baseColor: getLoadingBaseColor(),
                        highlightColor: getLoadingHighlightColor())
                    : null,
            child: ListView.builder(
              controller: easyRefreshScrollController,
              shrinkWrap: true,
              itemCount: provider.list.length,
              itemBuilder: (ctx, index) => (index == provider.list.length - 1)
                  ? Column(children: <Widget>[
                      buildItemCell(ctx, provider.list[index], index),
                      SizedBox(height: getEndHeight()),
                    ])
                  : buildItemCell(ctx, provider.list[index], index),
            ),
            onRefresh: hasRefresh() ? () => presenter.fetchData(false) : null,
            onLoad: hasMore() ? () => presenter.fetchData(true) : null,
          ),
        ),
      ),
    );
  }

  @protected
  double getEndHeight() => 80;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: bottomOffstage ? buildAppBar() : null,
        body: Container(
          color: getBackgroundColor(),
          alignment: Alignment.center,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: buildBody(),
          ),
        ),
        endDrawer: buildEndDrawer(),
        bottomNavigationBar: bottomOffstage ? buildBottomAppBar() : null,
        floatingActionButton:
            bottomOffstage ? buildFloatingActionButton() : null,
        // resizeToAvoidBottomPadding: true,
        resizeToAvoidBottomInset: true,
        backgroundColor: getBackgroundColor(),
      ),
      onWillPop: onSystemBack,
    );
  }

  Widget getLoadingChild() => null;

  Color getLoadingBaseColor() => Colors.grey[300];

  Color getLoadingHighlightColor() => Colors.grey[100];

  Widget getEmptyChild() => null;

  String getEmptyImageAsset();

  String getEmptyMessage() => '暂无内容';

  bool firstRefresh() => true;

  bool hasRefresh() => true;

  bool hasMore() => true;

  Widget buildItemCell(BuildContext ctx, dynamic data, int index);

  Pro createProvider();

  @override
  void dispose() {
    easyRefreshScrollController?.dispose();
    super.dispose();
  }
}

mixin BasePageMixin<T extends StatefulWidget, P extends BasePresenter>
    on State<T> implements IMvpView {
  List<TextEditingController> textControllers = [];
  P presenter;

  P createPresenter();

  @override
  BuildContext getContext() => context;
  bool bottomOffstage = true;
  bool isEdited = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: bottomOffstage ? buildAppBar() : null,
        body: Stack(
          children: <Widget>[
            Container(
              color: getBackgroundColor(),
              alignment: Alignment.center,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                child: buildBody() ?? Text('正在加载数据…'),
              ),
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Offstage(
                    child: buildBottomOffstage(), offstage: bottomOffstage)),
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              bottom: 0,
              child: buildTopLayout(),
            ),
          ],
        ),
        endDrawer: buildEndDrawer(),
        bottomNavigationBar: bottomOffstage ? buildBottomAppBar() : null,
        floatingActionButton:
            bottomOffstage ? buildFloatingActionButton() : null,
        // resizeToAvoidBottomPadding: true,
        resizeToAvoidBottomInset: true, // 键盘遮挡
        backgroundColor: getBackgroundColor(),
      ),
      onWillPop: onSystemBack,
    );
  }

  BottomAppBar buildBottomAppBar() {
    Widget widget = buildNavigationButton();
    if (widget == null) return null;
    return BottomAppBar(
      color: Theme.of(context).bottomAppBarColor,
      child:
          Padding(padding: EdgeInsets.only(left: 5, right: 5), child: widget),
    );
  }

  AppBar buildAppBar() => AppBar(
        brightness: Theme.of(context).appBarTheme.brightness,
        centerTitle: centerTitle(),
        title: buildTitle() ?? Text(''),
        actions: buildActions(),
      );

  @protected
  bool centerTitle() => true;

  @protected
  List<Widget> buildActions() => [];

  @protected
  Widget buildTitle() => null;

  @protected
  Widget buildBody() => null;

  @protected
  Widget buildEndDrawer() => null;

  @protected
  Widget buildNavigationButton() => null;

  @protected
  Widget buildFloatingActionButton() => null;

  @protected
  Color getBackgroundColor() => Theme.of(context).backgroundColor;

  @protected
  Widget buildBottomOffstage() => Container();

  @protected
  void changeBottomOffstage() {
    bottomOffstage = !bottomOffstage;
    setState(() {});
  }

  @protected
  Widget buildTopLayout() => Container();

  @override
  void closeProgress() {
    if (mounted && _isShowDialog) {
      _isShowDialog = false;
      NavigatorUtil.pop(context);
    }
  }

  bool _isShowDialog = false;

  @override
  void showProgress([String hintText = '正在处理...']) {
    /// 避免重复弹出
    if (mounted && !_isShowDialog) {
      _isShowDialog = true;
      showLoadingDialog(context, hintText: hintText, onWillPop: () async {
        _isShowDialog = false;
        return Future.value(true);
      });
    }
  }

  @override
  void showToast(String string,
          {TextStyle textStyle, bool dismissOtherToast = true}) =>
      ToastUtil.show(string,
          textStyle: textStyle, dismissOtherToast: dismissOtherToast);

  @override
  void showError(String error) => ToastUtil.showError(error);

  @override
  void didChangeDependencies() {
    presenter?.didChangeDependencies();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    textControllers.forEach((_controller) {
      _controller?.dispose();
    });
    textControllers.clear();
    presenter?.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    presenter?.deactivate();
    super.deactivate();
  }

  @override
  void didUpdateWidget(T oldWidget) {
    presenter?.didUpdateWidgets<T>(oldWidget);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    presenter = createPresenter();
    presenter?.view = this;
    presenter?.initState();
    SchedulerBinding.instance.addPostFrameCallback(presenter?.afterBuild);
    super.initState();
  }

  @protected
  void back({@required bool success, dynamic data}) =>
      NavigatorUtil.pop(context, success: success, data: data);

  @protected
  Future<PopParam> pushPage(Widget page) => NavigatorUtil.push(context, page);

  @protected
  Future<PopParam> pushRouter(String path,
          {bool replace = false,
          bool clearStack = false,
          TransitionType transition = TransitionType.inFromRight}) =>
      NavigatorUtil.pushRouter(context, path,
          replace: replace, clearStack: clearStack, transition: transition);

  void massageDialog(String content,
          {String title,
          String colorContent,
          String buttonText = '知道了',
          VoidCallback onPressed,
          bool left = false}) =>
      showMassageDialog(
        context,
        content,
        title: title,
        colorContent: colorContent,
        buttonText: buttonText,
        onPressed: onPressed,
        left: left,
      );

  void confirmDialog(String content,
          {String title,
          String colorContent,
          String cancelText,
          onCancelPressed,
          String okText,
          VoidCallback onOkPressed,
          bool left = false}) =>
      showConfirmDialog(
        context,
        content,
        title: title,
        colorContent: colorContent,
        cancelText: cancelText,
        onCancelPressed: onCancelPressed,
        okText: okText,
        onOkPressed: onOkPressed,
        left: left,
      );

  Future<int> bottomPopup<T>(String title, List<T> item,
          {String message, BuildCheckChild<T> buildCheckChild}) =>
      showBottomPopup(context, title, item,
          message: message, buildCheckChild: buildCheckChild);

  @protected
  isEmpty(value) => (value);

  @protected
  isNotEmpty(value) => !isEmpty(value);

  @protected
  isTrue(value) => value != null && value is bool && value;

  @protected
  Future<bool> onSystemBack() {
    back(success: isEdited);
    return Future.value(false);
  }
}
