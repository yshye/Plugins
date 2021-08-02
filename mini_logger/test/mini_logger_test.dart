import 'package:ansicolor/ansicolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_logger/mini_logger.dart';

void main() {
  List.generate(10, (index) => print(((index+1)/2).round()-1));
}

void testMiniLogConfig(){
  test('测试MiniLogConfig类', () {
    final config = MiniLoggerConfig();
    expect(config.withPrint, true);
    expect(config.minPrintLevel?.level, 'V');
    expect(config.minUpLevel?.level, 'W');
    expect(config.minSQLiteLevel?.level, 'D');
    expect(config.tag, 'mini_log');
    expect(config.upLogEvent, null);
  });
}

void testAnsi(){
  // print("\x1B[38;5;196m sdsadsad");
  // print("\x1B[48;5;30m dasdas");
  List.generate(8, (index) => print("\u001b[3${index}m 3${index}m 的字体颜色"));
  List.generate(8, (index) => print("\u001b[4${index}m 4${index}m 的背景色"));
}

void testAnsiPen(){
  ansiColorDisabled = false;
  List<Color> list = [Colors.black, Colors.blue, Colors.green, Colors.orange, Colors.red];
  list.forEach((color) {
    AnsiPen pen = AnsiPen()
      ..rgb(r: color.red / 255.0, g: color.green / 255.0, b: color.blue / 255.0);
    var hex = "#" +
        ((256 + color.red << 8 | color.green) << 8 | color.blue).toRadixString(16).substring(1);
    hex = "#" +
        color.red.toRadixString(16).padLeft(2, '0') +
        color.green.toRadixString(16).padLeft(2, '0') +
        color.blue.toRadixString(16).padLeft(2, '0');
    print(pen('这个颜色是：$hex'));
  });
}
