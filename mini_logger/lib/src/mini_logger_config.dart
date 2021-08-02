import 'mini_logger_model.dart';

/// 日志上传事件
/// [value] 等待上传的日志！
/// [value] 反馈是否处理成功！
typedef UpLogEvent = Future<bool> Function(MiniLoggerModel value);

/// 日志配置
class MiniLoggerConfig {
  /// 是否打印日志
  bool withPrint;

  /// 最小打印日志等级
  MiniLoggerLevelEnum minPrintLevel;

  /// 是否保存到数据库
  bool withSQLite;

  /// 最小保存日志等级
  MiniLoggerLevelEnum minSQLiteLevel;

  /// 最小上传日志等级
  MiniLoggerLevelEnum minUpLevel;

  /// 日志上传事件，不设置时不上传，将在每次打印时，结合[minUpLevel]判断是否上传
  UpLogEvent upLogEvent;

  /// 日志标签
  String tag;

  bool withPrintColor;

  /// 初始化配置
  /// - [minPrintLevel] - 最小打印等级，默认 [MiniLoggerLevelEnum.D]
  /// - [minSQLiteLevel] - 最小保存日志等级，默认 [MiniLoggerLevelEnum.I]
  /// - [minUpLevel] - 最小上传等级，默认 [MiniLoggerLevelEnum.W]
  MiniLoggerConfig(
      {this.withPrint = true,
      MiniLoggerLevelEnum minPrintLevel,
      this.withSQLite = false,
      MiniLoggerLevelEnum minSQLiteLevel,
      MiniLoggerLevelEnum minUpLevel,
      this.upLogEvent,
      this.withPrintColor = false,
      this.tag = "mini_log"}) {
    this.minPrintLevel = minPrintLevel ?? MiniLoggerLevelEnum.D;
    this.minSQLiteLevel = minSQLiteLevel ?? MiniLoggerLevelEnum.I;
    this.minUpLevel = minUpLevel ?? MiniLoggerLevelEnum.W;
  }
}
