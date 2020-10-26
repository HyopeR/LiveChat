import 'package:flutter/material.dart';

import 'package:live_chat/components/common/login_button.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
        elevation: 0,
      ),

      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            Text(
                'Oturum Açma Yöntemleri',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24)
            ),

            SizedBox(height: 10),

            LoginButton(
              buttonText: 'Google ile Oturum Aç',
              textColor: Colors.black,
              textSize: Theme.of(context).textTheme.headline6.fontSize,

              buttonRadius: 16,
              buttonColor: Colors.white,

              icon: Image.asset('assets/images/google-logo.png'),
              onPressed: (){},
            ),

            LoginButton(
              buttonText: 'Facebook ile Oturum Aç',
              textColor: Colors.white,
              textSize: Theme.of(context).textTheme.headline6.fontSize,

              buttonRadius: 16,
              buttonColor: Color(0xFF334D92),

              icon: Image.asset('assets/images/facebook-logo.png'),
              onPressed: (){},
            ),

            LoginButton(
              buttonText: 'Email ve Şifre ile Oturum Aç',
              textColor: Colors.white,
              textSize: Theme.of(context).textTheme.headline6.fontSize,

              buttonRadius: 16,
              buttonColor: Colors.grey,

              icon: Icon(Icons.email, color: Colors.white, size: 30,),
              onPressed: (){},
            )

          ],
        ),
      ),
    );
  }
}
