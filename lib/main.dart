import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:live_chat/components/pages/landing_page.dart';
import 'package:live_chat/components/pages/sign_in_page.dart';
import 'package:live_chat/components/pages/home_page.dart';
import 'package:live_chat/locator.dart';
import 'package:live_chat/views/user_view.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setup();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserView>.value(value: UserView()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Live Chat',

        initialRoute: '/',
        routes: {
          '/': (context) => LandingPage(),
          '/signInPage': (context) => SignInPage(),
          '/homePage': (context) => HomePage(),
        },
        onUnknownRoute: (RouteSettings settings) {
          print('Bulunamayan rota tespiti.');

          return MaterialPageRoute(
              builder: (context) => LandingPage()
          );
        },

        theme: ThemeData(
          primarySwatch: Colors.amber,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      ),
    );
  }
}