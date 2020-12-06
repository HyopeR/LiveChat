import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:live_chat/components/pages/landing_page.dart';
import 'package:live_chat/components/pages/sign_in_page.dart';
import 'package:live_chat/components/pages/home_page.dart';
import 'package:live_chat/locator.dart';
import 'package:live_chat/views/chat_view.dart';
import 'package:live_chat/views/user_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setup();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Color themeColor;
  Brightness themeBrightness;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((sharedPreferences) {
      String color = sharedPreferences.getString('themeColor') != null ? sharedPreferences.getString('themeColor') : 'orange';
      String brightness = sharedPreferences.getString('themeBrightness') != null ? sharedPreferences.getString('themeBrightness') : 'light';

      setState(() {
        themeColor = findColor(color);
        themeBrightness = findBrightness(brightness);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserView()),
        ChangeNotifierProvider(create: (context) => ChatView()),
      ],
      child: DynamicTheme(
        defaultBrightness: themeBrightness,
        data: (brightness) => ThemeData(
          primarySwatch: themeColor,
          brightness: brightness,
        ),

        themedWidgetBuilder: (context, theme) {
          return new MaterialApp(
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
              primarySwatch: theme.primaryColor,

              visualDensity: VisualDensity.adaptivePlatformDensity,
                textTheme: TextTheme(
                headline6: TextStyle(fontSize: 18),
                bodyText2: TextStyle(fontSize: 12),
                bodyText1: TextStyle(fontSize: 12),
              ).apply(),

              inputDecorationTheme: InputDecorationTheme(
                contentPadding: EdgeInsets.all(10),
              ),
            ),
          );
        },
      ),
    );
  }

  Color findColor(String colorName) {
    switch(colorName){
      case('orange'):
        return Colors.orange;
        break;
      case('blue'):
        return Colors.blue;
        break;
      case('amber'):
        return Colors.amber;
        break;
      case('green'):
        return Colors.green;
        break;
      case('purple'):
        return Colors.deepPurple;
        break;
      case('teal'):
        return Colors.teal;
        break;
      default:
        return Colors.orange;
        break;
    }
  }
  Brightness findBrightness(String brightnessName) {
    switch(brightnessName) {
      case('light'):
        return Brightness.light;
        break;
      case('dark'):
        return Brightness.dark;
        break;
      default:
        return Brightness.light;
        break;
    }
  }
}