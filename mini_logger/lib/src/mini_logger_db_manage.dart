import 'dart:async';

import 'mini_logger_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MiniLoggerDBManage {
  final String _dbName = 'mini_logger.db';
  final String _logTabName = 'tab_mini_logger';
  final String _idKey = 'id';
  final String _levelKey = 'level';
  final String _tagKey = 'tag';
  final String _contentKey = 'content';
  final String _createTimeKey = 'createTime';
  final String _statusKey = 'status';

  static MiniLoggerDBManage _manage;

  MiniLoggerDBManage._();

  static MiniLoggerDBManage internal() {
    if (_manage == null) {
      _manage = MiniLoggerDBManage._();
    }
    return _manage;
  }

  Database _db;

  Future<Database> _initDb() async {
    if (_db == null) {
      var dbDir = await getDatabasesPath();
      String dbPath = join(dbDir, _dbName);
      _db = await openDatabase(dbPath, version: 1, onCreate: _onCreate);
    }
    return _db;
  }

  FutureOr<void> _onCreate(Database _db, int version) async {
    // 创建日志表
    await _db.execute("""
    CREATE TABLE $_logTabName (
      $_idKey INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      $_levelKey TEXT(4) NOT NULL,
      $_tagKey TEXT(50) NOT NULL,
      $_contentKey TEXT NOT NULL,
      $_createTimeKey TEXT NOT NULL,
      $_statusKey INTEGER(4) NOT NULL DEFAULT 0
    )
    """);
  }

  FutureOr<int> insert(MiniLoggerModel log) async {
    var _dbClient = await _initDb();
    int value = await _dbClient.insert(
      _logTabName,
      {
        _levelKey: log.level.level,
        _tagKey: log.tag,
        _contentKey: log.content,
        _statusKey: log.status,
        _createTimeKey: log.createTime.toIso8601String()
      },
    );
    return value;
  }

  FutureOr<List<MiniLoggerModel>> query(QueryLogParameter parameter) async {
    StringBuffer where = _getWhereBuffer(parameter);
    where.write(" ORDER BY $_createTimeKey DESC");

    if (parameter.pageIndex != null &&
        parameter.pageSize != null &&
        parameter.pageIndex > 0 &&
        parameter.pageSize > 0) {
      where.write(" LIMIT ${(parameter.pageIndex - 1) * parameter.pageSize},${parameter.pageSize}");
    }
    var _dbClient = await _initDb();
    List<Map> maps = await _dbClient.query(_logTabName,
        columns: [_levelKey, _tagKey, _contentKey, _createTimeKey, _statusKey],
        where: where.toString());
    return maps
        .map((e) => MiniLoggerModel(
              MiniLoggerLevelEnum.of(e[_levelKey]),
              e[_tagKey],
              e[_contentKey],
              DateTime.tryParse(e[_createTimeKey]),
              e[_statusKey],
            ))
        .toList();
  }

  FutureOr<int> delete(QueryLogParameter parameter) async {
    StringBuffer buffer = _getWhereBuffer(parameter);
    var _dbClient = await _initDb();
    return await _dbClient.delete(_logTabName, where: buffer.toString());
  }

  StringBuffer _getWhereBuffer(QueryLogParameter parameter) {
    final String and = ' AND ';
    final String or = ' OR ';
    StringBuffer where = StringBuffer(" 1=1 ");
    if (parameter.level != null) {
      where
        ..write(and)
        ..write(_levelKey)
        ..write(" IN [")
        ..write(parameter.level.map((e) => e.level).toList().join(','))
        ..write("]");
    }
    if (parameter.minTime != null) {
      where
        ..write(and)
        ..write(
            "strftime('s',$_createTimeKey) >= strftime('s','${parameter.minTime.toIso8601String()}') ");
    }
    if (parameter.maxTime != null) {
      where
        ..write(and)
        ..write(
            "strftime('s',$_createTimeKey) <= strftime('s','${parameter.maxTime.toIso8601String()}')");
    }
    if (parameter.tag != null) {
      where..write(and)..write(_tagKey)..write(' = ')..write("'${parameter.tag}'");
    }
    if (parameter.searchKey != null && parameter.searchKey.isNotEmpty) {
      where
        ..write(and)
        ..write("(")
        ..write("$_contentKey LIKE '%${parameter.searchKey}%'")
        ..write(or)
        ..write("$_tagKey LIKE '%${parameter.searchKey}%'")
        ..write(or)
        ..write("$_createTimeKey LIKE '%${parameter.searchKey}%'")
        ..write(")");
    }

    return where;
  }
}
