import 'package:ansicolor/ansicolor.dart';

import 'mini_logger_db_manage.dart';
import 'mini_logger_model.dart';

import 'mini_logger_config.dart';

class L {
  /// 日志配置
  static MiniLoggerConfig _config = MiniLoggerConfig();

  /// 初始化日志
  static void init([MiniLoggerConfig config]) {
    ansiColorDisabled = !(config?.withPrintColor ?? false);
    L._config = config ?? _config;
  }

  /// Verbose就是冗长啰嗦的。通常表达开发调试过程中的一些详细信息。
  static void v(Object object, {String tag, bool withSQLite, bool withUp}) {
    if (MiniLoggerLevelEnum.V >= _config.minPrintLevel) {
      _handleLog(MiniLoggerLevelEnum.V, object,
          tag: tag, withSQLite: withSQLite, withUp: withUp);
    }
  }

  /// Info来表达一些信息。
  static void i(Object object, {String tag, bool withSQLite, bool withUp}) {
    if (MiniLoggerLevelEnum.I >= _config.minPrintLevel) {
      _handleLog(MiniLoggerLevelEnum.I, object,
          tag: tag, withSQLite: withSQLite, withUp: withUp);
    }
  }

  ///蓝色，Debug来表达调试信息。
  static void d(Object object, {String tag, bool withSQLite, bool withUp}) {
    if (MiniLoggerLevelEnum.D >= _config.minPrintLevel) {
      _handleLog(MiniLoggerLevelEnum.D, object,
          tag: tag, withSQLite: withSQLite, withUp: withUp);
    }
  }

  /// Warn表示警告，但不一定会马上出现错误，开发时有时用来表示特别注意的地方。
  static void w(Object object, {String tag, bool withSQLite, bool withUp}) {
    if (MiniLoggerLevelEnum.W >= _config.minPrintLevel) {
      _handleLog(MiniLoggerLevelEnum.W, object,
          tag: tag, withSQLite: withSQLite, withUp: withUp);
    }
  }

  ///Error 出现错误，是最需要关注解决的。
  static void e(Object object, {String tag, bool withSQLite, bool withUp}) {
    if (MiniLoggerLevelEnum.E >= _config.minPrintLevel) {
      _handleLog(MiniLoggerLevelEnum.E, object,
          tag: tag, withSQLite: withSQLite, withUp: withUp);
    }
  }

  static Future<List<MiniLoggerModel>> queryLogs(
      [QueryLogParameter _parameter]) async {
    if (_config.withSQLite ?? false)
      return await MiniLoggerDBManage.internal()
          .query(_parameter ?? QueryLogParameter());
    return [];
  }

  static Future<int> deleteLog([QueryLogParameter _parameter]) async {
    return await MiniLoggerDBManage.internal()
        .delete(_parameter ?? QueryLogParameter());
  }

  static void _handleLog(
    MiniLoggerLevelEnum level,
    Object object, {
    String tag,
    bool withSQLite,
    bool withUp,
  }) {
    tag = tag ?? _config.tag ?? 'mini_log';
    bool enablePrint =
        (_config.withPrint ?? false) && level >= _config.minPrintLevel;
    withUp =
        _config.upLogEvent != null && (withUp ?? level >= _config.minUpLevel);
    withSQLite = withSQLite ??
        ((_config.withSQLite ?? false) && level >= _config.minSQLiteLevel);
    String content = object.toString();
    DateTime _now = DateTime.now();
    MiniLoggerModel _log = MiniLoggerModel(level, tag, content, _now, 0);

    if (withUp) {
      _config.upLogEvent(_log).then((value) {
        _log.status = value ? 1 : 0;
        if (withSQLite) {
          MiniLoggerDBManage.internal().insert(_log);
        }
      });
    } else {
      if (withSQLite) {
        MiniLoggerDBManage.internal().insert(_log);
      }
    }

    if (enablePrint) {
      int index = 1;
      AnsiPen pen = AnsiPen()
        ..rgb(
            r: level.color.red / 255.0,
            g: level.color.green / 255.0,
            b: level.color.blue / 255);
      while (content.isNotEmpty) {
        if (content.length > 1024) {
          print(pen(
              "[$tag][${level.level}][${index++}]: ${content.substring(0, 512)}"));
          content = content.substring(512);
        } else {
          print(pen("[$tag][${level.level}][${index++}]: $content"));
          content = '';
        }
      }
    }
  }
}
