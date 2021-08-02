import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'mixin_state.dart';

abstract class MiniDetailState<T extends StatefulWidget> extends State<T>
    with StateMixin, AutomaticKeepAliveClientMixin {
  bool bottomOffstage = true;
  bool isEdited = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: bottomOffstage ? buildAppBar() : null,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset(),
        body: Container(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: getMaxWidth(),
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                Container(
                  color: getBackgroundColor(),
                  height: double.infinity,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () =>
                        FocusScope.of(context).requestFocus(FocusNode()),
                    child: buildBody() ?? buildLodingWidget(),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Offstage(
                      child: buildBottomOffstage(), offstage: bottomOffstage),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  right: 0,
                  bottom: 0,
                  child: buildTopLayout(),
                ),
              ],
            ),
          ),
        ),
        endDrawer: buildEndDrawer(),
        bottomNavigationBar: bottomOffstage ? buildBottomAppBar() : null,
        floatingActionButton:
            bottomOffstage ? buildFloatingActionButton() : null,
        // resizeToAvoidBottomPadding: true,

        backgroundColor: getBackgroundColor(),
      ),
      onWillPop: onSystemBack,
    );
  }

  double getMaxWidth() => MediaQuery.of(context).size.width;

  void openEndDrawer() => _scaffoldKey.currentState?.openEndDrawer();

  BottomAppBar buildBottomAppBar() {
    Widget widget = buildNavigationButton();
    if (widget == null) return null;
    return BottomAppBar(
        color: Theme.of(context).bottomAppBarColor,
        child: widget,
        elevation: 0.5);
  }

  PreferredSizeWidget buildAppBar() => buildTitle() == null
      ? null
      : AppBar(
          brightness: Theme.of(context).appBarTheme.brightness,
          centerTitle: centerTitle(),
          leading: buildLeading(),
          title: buildTitle() ?? Text(''),
          elevation: barElevation(),
          actions: buildActions(),
        );

  double barElevation() => 0.5;

  @protected
  bool centerTitle() => true;

  @protected
  List<Widget> buildActions() => [];

  @protected
  Widget buildTitle();

  @protected
  Widget buildLeading() => null;

  @protected
  Widget buildBody();

  @protected
  Widget buildEndDrawer();

  @protected
  Widget buildNavigationButton();

  @protected
  Widget buildFloatingActionButton() => null;

  @protected
  Color getBackgroundColor() => Theme.of(context).backgroundColor;

  @protected
  Future<bool> onSystemBack() async {
    back(success: isEdited);
    return false;
  }

  @protected
  Widget buildBottomOffstage() => Container();

  @protected
  void changeBottomOffstage() {
    bottomOffstage = !bottomOffstage;
    setState(() {});
  }

  @protected
  Widget buildTopLayout() => Container();

  bool resizeToAvoidBottomInset() => true;

  @override
  bool get wantKeepAlive => false;
}
