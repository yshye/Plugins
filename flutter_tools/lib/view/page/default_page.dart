import 'package:flutter/material.dart';

class DefaultPage extends StatelessWidget {
  final Widget child;
  final String title;

  const DefaultPage({Key key, @required this.title, @required this.child})
      : assert(title != null && child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: child,
    );
  }
}
