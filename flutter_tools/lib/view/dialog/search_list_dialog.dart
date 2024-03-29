import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tools/view/widget/mini_search_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../router/navigator_util.dart';
import '../typedef.dart';
import 'bottom_sheet_dialog.dart';
import '../../extension/extension.dart';

class SearchListDialog<T> extends StatefulWidget {
  final String hintText;
  final double titleHeight;
  final Color backgroundColor;
  final List<T> items;
  final ToString<T> toLabel;
  final ValueChanged<T> onTap;
  final BuildCheckChild<T> buildCheckChild;
  final EdgeInsetsGeometry padding;
  final bool Function(T t1, T t2) compare;
  final T value;
  final double height;
  final int top;

  const SearchListDialog(
      {Key key,
      this.hintText,
      this.titleHeight = 60,
      this.onTap,
      this.backgroundColor = Colors.white,
      this.items,
      this.toLabel,
      this.padding = const EdgeInsets.only(left: 5, right: 5, bottom: 10),
      this.buildCheckChild,
      this.height,
      this.value,
      this.top = 100,
      this.compare})
      : super(key: key);

  @override
  _SearchListDialogState<T> createState() => _SearchListDialogState<T>();
}

class _SearchListDialogState<T> extends State<SearchListDialog<T>> {
  final TextEditingController _searchController = TextEditingController();
  String _searchKey = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _searchKey = _searchController.text;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    List<T> _list = widget.items;
    if (_searchKey.isNotEmpty) {
      _list = _list
              .where((element) => widget.toLabel(element).contains(_searchKey))
              ?.toList() ??
          [];
    }
    double _height = widget.height;
    if (_height == null) {
      if (widget.items.length < 6) {
        _height = widget.titleHeight + widget.items.length * 60 + 10;
      } else {
        _height = MediaQuery.of(context).size.height * 4 / 9.0;
      }
    }

    return BottomSheetDialog(
      title: Container(
        padding: const EdgeInsets.only(top: 8.0, right: 50, left: 10),
        height: widget.titleHeight + 8.0,
        child: MiniSearchWidget(
          controller: _searchController,
          hintText: widget.hintText ?? '快速搜索',
          autoFocus: false,
          height: 40,
        ),
      ),
      padding: EdgeInsets.only(left: 5, top: 10, right: 5, bottom: 10),
      height: _height,
      titleLeft: Container(
        height: widget.titleHeight + 8.0,
      ),
      titleRight: CupertinoButton(
        child: Icon(Icons.clear, color: Colors.grey),
        padding: EdgeInsets.all(10),
        onPressed: () => NavigatorUtil.pop(context),
      ),
      children: _list
          .subListEnd(0, widget.top)
          .map((e) => widget.buildCheckChild != null
              ? widget.buildCheckChild(context, e)
              : ListTile(
                  onTap: () {
                    NavigatorUtil.pop(context);
                    widget.onTap(e);
                  },
                  title: Text(widget.toLabel(e) ?? '',
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: Icon(
                    MdiIcons.check,
                    color: widget.compare == null
                        ? Colors.transparent
                        : (widget.compare(widget.value, e)
                            ? Colors.blue
                            : Colors.transparent),
                  ),
                ))
          .toList(),
    );
  }
}
