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
                'Oturum Açın',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24)
            ),

            SizedBox(height: 10),

            LoginButton(
              buttonText: 'Google ile Oturum Aç',
              textColor: Colors.white,
              textSize: Theme.of(context).textTheme.headline6.fontSize,

              buttonRadius: 15,
              buttonColor: Colors.red,
              buttonHeight: 50,

              icon: Icon(Icons.add, color: Colors.white,),
              onPressed: (){},
            ),

            LoginButton(
              buttonText: 'Facebook ile Oturum Aç',
              textColor: Colors.white,
              textSize: Theme.of(context).textTheme.headline6.fontSize,

              buttonRadius: 15,
              buttonColor: Color(0xFF334D92),
              buttonHeight: 50,

              icon: Icon(Icons.add, color: Colors.white,),
              onPressed: (){},
            )

          ],
        ),
      ),
    );
  }
}
