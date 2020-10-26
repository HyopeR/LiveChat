import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {

  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  final double textSize;
  final double buttonRadius;
  final double buttonHeight;
  final Widget icon;

  final VoidCallback onPressed;

  const LoginButton({
    Key key,
    this.buttonText,
    this.buttonColor,
    this.textColor,
    this.textSize,
    this.buttonRadius,
    this.buttonHeight,
    this.icon,
    this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      height: buttonHeight,
      child: RaisedButton(
          color: buttonColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(buttonRadius))),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(

                    child: icon,

                )
              ),

              Expanded(
                  flex: 5,
                  child: Container(

                    child: Text(
                      '${buttonText.toString()}',
                      style: TextStyle(color: textColor, fontSize: textSize),
                    ),

                  )
              )
            ],
          ),
          onPressed: onPressed),
    );
  }
}
