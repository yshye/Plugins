import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../num/num_util.dart';
import '../../../util/regex_util.dart';
import 'chart_color.dart';

class PieChartWidget extends StatelessWidget {
  final List<StatisticsModel> items;
  final bool animate;
  final String label;
  final double height;
  final bool isInt;
  final Color color;
  final Color iconColor;
  final Color labelColor;
  final double labelFontSize;
  final bool showNum;
  final bool enableSort;
  final List<charts.Series> _seriesList = [];
  final EdgeInsetsGeometry padding;

  PieChartWidget(this.items,
      {this.label,
      this.color,
      this.isInt = true,
      this.animate = true,
      this.height = 200,
      int maxItems = 6,
      this.labelFontSize = 12,
      this.iconColor,
      this.labelColor,
      this.showNum = false,
      this.enableSort = false,
      this.padding = const EdgeInsets.only()}) {
//    items.removeWhere((item) => item.yValue == 0.0);
    List<StatisticsModel> data = [];
    if (enableSort)
      items.sort((o1, o2) => o2.yValue.floor() - o1.yValue.floor());
    if (items.length > maxItems) {
      double size = 0;
      for (var i = maxItems; i < items.length; i++) {
        size += items[i].yValue;
      }
      data = items.sublist(0, maxItems);
      data.add(StatisticsModel('其它', size));
    } else {
      data.addAll(items);
    }
    _seriesList
      ..clear()
      ..addAll(_createSeries(data));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color ?? Theme.of(context).canvasColor,
      padding: padding,
      height: height,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                top: (label == null || label.isEmpty) ? 0.0 : 30),
            child: _buildChart(),
          ),
          Positioned(
              left: 10,
              top: 5,
              right: 10,
              child: Text(
                label ?? '数据报表',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: labelFontSize,
//                    fontWeight: FontWeight.bold,
                    color: labelColor ??
                        Theme.of(context).textTheme.bodyText1.color),
              ))
        ],
      ),
    );
  }

  Widget _buildChart() {
    return charts.PieChart(
      _seriesList,
      animate: animate,
      behaviors: [
        charts.DatumLegend(
          position: charts.BehaviorPosition.bottom,
          desiredMaxRows: 1,
          horizontalFirst: false,
//          cellPadding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
          outsideJustification: charts.OutsideJustification.middle,
          insideJustification: charts.InsideJustification.topEnd,
          showMeasures: true,
          legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
          measureFormatter: (num value) {
            if (showNum)
              return value == null
                  ? '- '
                  : '${isInt ? NumUtil.getNumByValueDouble(value, 0) : value} ';
            return '';
          },
          entryTextStyle: charts.TextStyleSpec(fontSize: 12),
        ),
      ],
      defaultRenderer: charts.ArcRendererConfig(
        arcWidth: (height * 0.15).floor(),
        arcRendererDecorators: [
          charts.ArcLabelDecorator(
            labelPosition: charts.ArcLabelPosition.inside,
          )
        ],
      ),
    );
  }

  /// 解析图标数据
  List<charts.Series<StatisticsModel, String>> _createSeries(
      List<StatisticsModel> data) {
    double allSize = 0;
    data.forEach((item) => allSize += item.yValue);
    return [
      charts.Series<StatisticsModel, String>(
        id: 'Sales',
        domainFn: (StatisticsModel sales, _) => sales.xLabel,
        measureFn: (StatisticsModel sales, _) => sales.yValue,
        colorFn: (StatisticsModel sales, index) =>
            charts.ColorUtil.fromDartColor(
                sales.color ?? ChartColors.themeDefault[index]),
        labelAccessorFn: (StatisticsModel sales, _) {
          if (sales.yValue == 0) return '';
          return "${NumUtil.getNumByValueDouble(NumUtil.divide(sales.yValue, allSize == 0.0 ? 1.0 : allSize) * 100, 0)}%";
        },
        data: data,
      )
    ];
  }
}

class StatisticsModel {
  final String xLabel;
  double yValue;
  String yLabel;
  Color color;

  StatisticsModel(this.xLabel, var yValue, {this.yLabel, this.color}) {
    if (yValue == null) this.yValue = 0.0;
    if (yValue is int || yValue is num)
      this.yValue = yValue.toDouble();
    else if (yValue is double) {
      this.yValue = yValue;
    } else if (yValue is String && RegexUtil.isNumber(yValue))
      this.yValue = double.parse(yValue);
    else
      this.yValue = 0.0;
    if (this.yLabel == null) this.yLabel = "$yValue";
  }
}
