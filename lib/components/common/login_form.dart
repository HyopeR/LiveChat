import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum FormType {Register, Login}

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
  String buttonText;

  var formType = FormType.Login;
  final _formKey = GlobalKey<FormState>();

  void formSubmit() {
    _formKey.currentState.save();
  }

  void changeFormType() {
    formType == FormType.Login
        ? setState(() => formType = FormType.Register)
        : setState(() => formType = FormType.Login);
  }

  @override
  Widget build(BuildContext context) {

    buttonText = formType == FormType.Login ? 'Giriş Yap' : 'Kayıt Ol';

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
          padding: EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black38,
            ),
            borderRadius: BorderRadius.circular(widget.formElementsRadius),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                Container(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    splashRadius: 25,
                    icon: formType == FormType.Login ? Icon(Icons.article) : Icon(Icons.login),
                    onPressed: () => changeFormType(),
                  ),
                ),

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
                      child: Text(buttonText),
                      onPressed: widget.onPressed,
                    )
                ),

              ],
            ),
          ),
        )
      ],
    );
  }
}
