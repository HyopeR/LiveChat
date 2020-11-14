import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  final double textSize;
  final double buttonRadius;
  final double buttonHeight;
  final Widget icon;
  final EdgeInsets margin;
  final EdgeInsets padding;

  final VoidCallback onPressed;

  // Varsayılan değerleri : ile belirtiyoruz.
  const LoginButton({
      Key key,
      @required this.buttonText,
      this.buttonColor: Colors.blue,
      this.textColor: Colors.white,
      this.textSize: 14,
      this.buttonRadius: 16,
      this.buttonHeight: 50,
      this.icon,
      this.onPressed,
      this.margin,
      this.padding : EdgeInsets.zero
      })

      // Assert kısmı herhangi bir kullanımda hata çıkarsa uyarı verir.
      : assert(buttonText != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin == null ? EdgeInsets.symmetric(vertical: 5) : margin,
      padding: padding,
      height: buttonHeight,

      child: RaisedButton(
          color: buttonColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(buttonRadius))),
          child: Stack(
            children: [

              icon != null
                ? Positioned(
                    height: buttonHeight,
                    left: 0,
                      child: Container(
                        alignment: Alignment.center,
                        child: icon,
                      )
                  )
                : Container(),

              Container(
                alignment: Alignment.center,
                child: Text(
                  '${buttonText.toString()}',
                  style: TextStyle(color: textColor, fontSize: textSize),
                ),
              )
            ],
          ),
          onPressed: onPressed),
    );
  }
}
