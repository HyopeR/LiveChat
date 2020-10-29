import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {

  final double formElementsHeight;
  final double formElementsRadius;
  final VoidCallback onPressed;

  const LoginForm({
    Key key,
    this.formElementsHeight : 50,
    this.formElementsRadius : 16,
    this.onPressed,
  }) : super(key: key);


  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  String email, password;
  final formKey = GlobalKey<FormState>();

  void formSubmit() {
    formKey.currentState.save();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -24,
          left: 0,
          child: Icon(
            Icons.arrow_drop_up_outlined,
            size: 75,
            color: Colors.black38,
          ),
        ),

        Container(
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black38,
            ),
            borderRadius: BorderRadius.circular(widget.formElementsRadius),
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  height: widget.formElementsHeight,
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,

                    onSaved: (value) => email = value,

                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: 'Email',
                        hintText: 'Email giriniz.',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(widget.formElementsRadius)
                        )
                    ),
                  ),
                ),


                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  height: widget.formElementsHeight,
                  child: TextFormField(
                    obscureText: true,

                    onSaved: (value) => password = value,

                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        labelText: 'Şifre',
                        hintText: 'Şifre giriniz.',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(widget.formElementsRadius)
                        )
                    ),
                  ),
                ),

                Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    height: widget.formElementsHeight,
                    width: double.infinity,
                    child: RaisedButton(
                      color: Theme.of(context).accentColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(widget.formElementsRadius)
                      ),
                      child: Text('Giriş Yap'),
                      onPressed: widget.onPressed,
                    )
                )


              ],
            ),
          ),
        )
      ],
    );
  }
}
