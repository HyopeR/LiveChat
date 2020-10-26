import 'package:flutter/material.dart';

import 'package:live_chat/components/pages/sign_in_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Live Chat',

      initialRoute: '/',
      routes: {
        '/': (context) => SignInPage(),
      },
      onUnknownRoute: (RouteSettings settings) => MaterialPageRoute(builder: (context) => SignInPage()),

      theme: ThemeData(
        primarySwatch: Colors.amber,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}