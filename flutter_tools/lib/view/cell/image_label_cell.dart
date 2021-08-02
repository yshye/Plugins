import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tools/view/widget/badge_widget.dart';

class ImageLabelCell extends StatelessWidget {
  final String label;
  final String imagePath;
  final Color color;
  final Color labelColor;
  final double labelSize;
  final VoidCallback onTap;
  final double iconSize;
  final double interval;
  final String text;
  final int number;
  final double offsetX;
  final double offsetY;
  final bool visible;

  const ImageLabelCell({
    Key key,
    this.label,
    this.imagePath,
    this.color,
    this.labelColor,
    this.onTap,
    this.labelSize = 12,
    this.iconSize = 25,
    this.interval = 12,
    this.text,
    this.number,
    this.offsetX = -8,
    this.offsetY = -8,
    this.visible = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        color: color ?? Theme.of(context).canvasColor,
        child: InkWell(
          onTap: onTap,
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                BadgeWidget(
                  number: number,
                  text: text,
                  visible: visible,
                  offsetX: offsetX,
                  offsetY: offsetY,
                  child: SizedBox(
                    width: iconSize,
                    height: iconSize,
                    child: Image.asset(this.imagePath),
                  ),
                ),
                SizedBox(height: interval),
                Text(this.label ?? '',
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontSize: labelSize,
                          color: labelColor,
                        )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
