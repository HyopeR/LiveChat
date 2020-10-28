import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              height: 50,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Email giriniz.',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16)
                  )
                ),
              ),
            ),


            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              height: 50,
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: 'Şifre',
                    hintText: 'Şifre giriniz.',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16)
                    )
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
