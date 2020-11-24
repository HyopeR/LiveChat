import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:live_chat/components/pages/landing_page.dart';
import 'package:live_chat/components/pages/sign_in_page.dart';
import 'package:live_chat/components/pages/home_page.dart';
import 'package:live_chat/locator.dart';
import 'package:live_chat/views/chat_view.dart';
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
        ChangeNotifierProvider(create: (context) => UserView()),
        ChangeNotifierProvider(create: (context) => ChatView()),
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
          textTheme: TextTheme(
            headline6: TextStyle(fontSize: 18),
            bodyText2: TextStyle(fontSize: 12),
            bodyText1: TextStyle(fontSize: 12),
          ).apply(
            bodyColor: Colors.black,
          ),
          
          inputDecorationTheme: InputDecorationTheme(
            contentPadding: EdgeInsets.all(10),
          ),
        ),
      ),
    );
  }
}