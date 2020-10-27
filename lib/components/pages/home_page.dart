import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  User _user;

  @override
  Widget build(BuildContext context) {
    _user = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Ana Sayfa'),

        actions: [
          IconButton(
            splashRadius: 25,
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed(
                  '/signInPage',
              );
            },
          )
        ],
      ),

      body: Center(
        child: Text('Hoş geldiniz. ${_user.uid}'),
      ),
    );
  }
}
