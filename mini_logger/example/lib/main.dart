import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mini_logger/mini_logger.dart';
import 'package:english_words/english_words.dart';

void main() {
  L.init(MiniLoggerConfig(
    tag: 'mini_log_example',
    withSQLite: true,
    upLogEvent: upLog,
    minSQLiteLevel: MiniLoggerLevelEnum.V,
    withPrintColor: !Platform.isIOS,
  ));
  runApp(MyApp());
}

Future<bool> upLog(MiniLoggerModel log) async {
  L.d("正在提交日志：$log", withSQLite: false, withUp: false, tag: '上传日志');
  return true;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '日志测试'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _controller;
  QueryLogParameter _parameter = QueryLogParameter();

  List<MiniLoggerModel> _list = [];

  int _counter = 0;

  @override
  void initState() {
    _query();
    _controller = TextEditingController();
    _controller.addListener(() {
      _parameter.searchKey = _controller.text.trim();
      _query();
    });
    super.initState();
  }

  void _add() async {
    int index = (_counter++) % 5;
    var log = generateWordPairs().take(math.Random().nextInt(50) + 20).join(' ');
    switch (index) {
      case 0:
        L.v(log);
        break;
      case 1:
        L.d(log, withUp: math.Random().nextBool());
        break;
      case 2:
        L.i(log, withSQLite: math.Random().nextBool());
        break;
      case 3:
        L.w(log, withUp: false);
        break;
      case 4:
        L.e(log, withSQLite: true);
        break;
    }
    _query();
  }

  void _delete() async {
    int sum = await L.deleteLog(QueryLogParameter(maxTime: DateTime.now()));
    print('删除了$sum条记录');
    _query();
  }

  void _query() async {
    _list = await L.queryLogs(_parameter);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Card(
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(top: 0.0),
                hintText: '日志测试',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            if (index.isOdd) return Divider();
            MiniLoggerModel _log = _list[(index / 2).floor()];
            return Text(_log.toString(), style: TextStyle(color: _log.level.color));
          },
          itemCount: _list.length * 2,
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: _delete,
            tooltip: 'delete',
            child: Icon(Icons.delete),
            backgroundColor: Colors.red,
          ),
          SizedBox(height: 20),
          FloatingActionButton(onPressed: _add, tooltip: 'add', child: Icon(Icons.add))
        ],
      ), // This t
    );
  }

  String getDateTimeStr(DateTime time) {
    return "${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}";
  }
}
