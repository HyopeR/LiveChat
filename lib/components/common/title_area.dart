import 'package:flutter/material.dart';

class TitleArea extends StatelessWidget {

  final String titleText;
  final EdgeInsets margin;
  final EdgeInsets padding;

  final IconData icon;
  final double iconSize;
  final Color iconColor;

  final double textSize;
  final Color textColor;
  final FontWeight textFontWeight;

  const TitleArea({
    Key key,
    this.titleText,
    this.margin,
    this.padding,

    this.icon : Icons.brightness_1,
    this.iconSize : 22,
    this.iconColor : Colors.amber,

    this.textSize : 18,
    this.textColor : Colors.black,
    this.textFontWeight : FontWeight.w500
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin != null ? margin : EdgeInsets.symmetric(vertical: 5),
      padding: padding != null ? padding :  EdgeInsets.symmetric(vertical: 10),
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: iconSize,
                  color: iconColor,
                ),
                SizedBox(width: 5),
                Text(
                    titleText,
                    style: TextStyle(fontSize: textSize, fontWeight: textFontWeight, color: textColor)
                )
              ],
            ),
            Divider(thickness: 2)
          ],
        ),
      ),
    );
  }
}