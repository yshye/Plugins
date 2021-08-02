import 'package:flutter/material.dart';

import '../../router/pop_param.dart';
import '../base/mini_detail_state.dart';
import '../cell/material_button_cell.dart';
import '../typedef.dart';
import '../widget/mini_search_widget.dart';
import '../widget/select_widget.dart';

class SelectPage<T> extends StatefulWidget {
  final String title;
  final bool showSearchBar;
  final List<T> data;
  final BuildCheckChild<T> buildCheckChild;
  final List<T> selectedData;
  final Compare<T> compare;

  /// 自定义模糊匹配
  final Contains<T> contains;
  final bool multiple;
  final int max;

  const SelectPage({
    Key key,
    this.title,
    this.showSearchBar = true,
    this.data,
    this.buildCheckChild,
    this.selectedData,
    this.compare,
    this.multiple = false,
    this.max,
    this.contains,
  }) : super(key: key);

  @override
  _SelectPageState createState() => _SelectPageState<T>();
}

class _SelectPageState<T> extends MiniDetailState<SelectPage<T>> {
  final TextEditingController controller = TextEditingController();
  SelectWidget<T> _child;

  @override
  void initState() {
    _child = SelectWidget<T>(
      widget.data,
      buildCheckChild: widget.buildCheckChild,
      selectedData: widget.selectedData,
      compare: widget.compare,
      multiple: widget.multiple,
      max: widget.max,
      contains: widget.contains,
    );
    controller.addListener(() {
      _child?.search(controller.text.trim());
    });
    super.initState();
  }

  @override
  Widget buildBody() => _child;

  @override
  Widget buildEndDrawer() => null;

  @override
  Widget buildNavigationButton() {
    return Container(
      height: 80,
      padding: EdgeInsets.only(bottom: 15),
      alignment: Alignment.bottomCenter,
      child: MaterialButtonCell(
        radius: 34,
        miniWidth: 300,
        height: 45,
        label: '确定',
        onTap: () {
          List<T> temp = _child.getSelected();
          if (temp.length == 0) {
            showError('未选择任何内容！');
            return;
          } else {
            back(success: true, data: temp);
          }
        },
        textColor: Colors.white,
        color: Color(0xff487cff),
      ),
    );
//    return MaterialButtonCell(
//      textColor: Colors.blue,
//      child: Text('确定'),
//      onTap: () {
//        List<T> temp = _child.getSelected();
//        if (temp.length == 0) {
//          showToast('未选择任何内容！');
//          return;
//        } else {
//          back(success: true, data: temp);
//        }
//      },
//    );
  }

  @override
  void back({bool success, dynamic data}) {
    return Navigator.pop(context, PopParam(success, data));
  }

  @override
  Widget buildTitle() {
    return widget.showSearchBar
        ? MiniSearchWidget(
            controller: controller,
            hintText: widget.title ?? '',
            autoFocus: false)
        : Text(widget.title ?? '');
  }
}
