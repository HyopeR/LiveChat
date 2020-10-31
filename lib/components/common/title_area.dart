import 'package:flutter/material.dart';

class TitleArea extends StatelessWidget {

  final String titleText;
  final Widget icon;

  const TitleArea({Key key, this.titleText, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                icon != null
                    ? icon
                    : Icon(
                        Icons.brightness_1,
                        size: 24,
                        color: Theme.of(context).primaryColor,
                      ),

                SizedBox(width: 5),
                Text(
                    titleText,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)
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