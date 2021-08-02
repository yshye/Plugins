import 'package:dio/dio.dart';

void _printLog(Object object, Map<String, dynamic> extra) => print(object);

class MiniLogInterceptor extends Interceptor {
  DateTime? _startTime;
  StringBuffer _log = StringBuffer();
  Map<String, dynamic> extra;

  void Function(Object object, Map<String, dynamic> extra) printError;
  void Function(Object object, Map<String, dynamic> extra) printResponse;

  MiniLogInterceptor({
    this.printResponse = _printLog,
    this.printError = _printLog,
    this.extra = const {},
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    this.extra = options.extra;
    _startTime = DateTime.now();
    _log.write("${'=' * 20}     ${options.method}     ${'=' * 20}\n");
    _log..write('- URL: ')..write(options.baseUrl)..write(options.path);
    if (options.queryParameters.length > 0) {
      StringBuffer _parameters = StringBuffer();
      options.queryParameters.forEach((key, value) {
        _parameters..write('&')..write(key)..write('=')..write(value);
      });
      _log..write('?')..write(_parameters.toString().substring(1))..write('\n');
    } else {
      _log..write('\n');
    }
    _log..write('- METHOD: ')..write(options.method)..write('\n');
    _log
      ..write('- HEADER: \n')
      ..write(options.headers.mapToStructureString())
      ..write('\n');

    final data = options.data;
    if (data != null) {
      _log.write('- BODY: \n');
      if (data is Map) {
        _log..write(data.mapToStructureString())..write('\n');
      } else if (data is FormData) {
        var fields = Map()..addEntries(data.files)..addEntries(data.fields);
        _log..write(fields.mapToStructureString())..write('\n');
      } else {
        _log..write(data.toString())..write('\n');
      }
    }
    handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    int duration = DateTime.now().difference(_startTime!).inMilliseconds;
    _log
      ..write(
          '${'✖' * 20}     请求错误: ${(duration / 1000).toStringAsFixed(4)} 秒    ${'✖' * 20}\n');
    _log..write('-DioError ：$err\n');
    printError(_log.toString(), this.extra);
    handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    int duration = DateTime.now().difference(_startTime!).inMilliseconds;
    _log
      ..write(
          "${'=' * 20}   请求成功：${(duration / 1000).toStringAsFixed(4)} 秒    ${'=' * 20}\n");
    _log..write('- STATUS: ${response.statusCode}\n');
    _log..write('- RESPONSE:\n');
    var data = response.data;
    if (data is Map) {
      _log..write(data.mapToStructureString());
    } else {
      _log..write(data.toString());
    }
    _log.write('\n');
    printResponse(_log.toString(), this.extra);
    handler.next(response);
  }
}

extension Map2StringEx on Map {
  String mapToStructureString({int indentation = 2}) {
    String result = "";
    String indentationStr = " " * indentation;
    if (true) {
      result += "{";
      this.forEach((key, value) {
        if (value is Map) {
          var temp = value.mapToStructureString(indentation: indentation + 2);
          result += "\n$indentationStr" + "\"$key\" : $temp,";
        } else if (value is List) {
          result += "\n$indentationStr" +
              "\"$key\" : ${value.listToStructureString(indentation: indentation + 2)},";
        } else {
          result += "\n$indentationStr" + "\"$key\" : \"$value\",";
        }
      });
      result = result.substring(0, result.length - 1);
      result += indentation == 2 ? "\n}" : "\n${" " * (indentation - 1)}}";
    }

    return result;
  }
}

extension List2StringEx on List {
  String listToStructureString({int indentation = 2}) {
    String result = "";
    String indentationStr = " " * indentation;
    if (true) {
      result += "$indentationStr[";
      this.forEach((value) {
        if (value is Map) {
          var temp = value.mapToStructureString(indentation: indentation + 2);
          result += "\n$indentationStr" + "\"$temp\",";
        } else if (value is List) {
          result += value.listToStructureString(indentation: indentation + 2);
        } else {
          result += "\n$indentationStr" + "\"$value\",";
        }
      });
      result = result.substring(0, result.length - 1);
      result += "\n$indentationStr]";
    }

    return result;
  }
}
