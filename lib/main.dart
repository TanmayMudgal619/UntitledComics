import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'load.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart' as globals;
import 'package:flutter/services.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //To save Basic Information such as Username, Data Saving mode, Language Preffered, etc
  globals.prefs = await SharedPreferences.getInstance();
  //Directory for Downloading Images
  // globals.appdir = await pp.getApplicationDocumentsDirectory();
  //lang is for language(By Default EN), login show that does the user is LogedIn or Not
  final l = globals.prefs.getString("lang") ?? 0;
  if (l == 0) {
    globals.prefs.setString("lang", "EN");
  }
  final chk = globals.prefs.getBool("login") ?? 0;
  if (chk == 0) {
    //Seting Up basic Things
    //datas for Data Saving Mode
    //session to store Token
    //refresh to store Refresh Token
    //hist to store Searching History
    globals.prefs.setBool("incog", false);
    globals.prefs.setBool("datas", false);
    globals.prefs.setBool("login", false);
    globals.prefs.setString("session", "");
    globals.prefs.setString("refresh", "");
    globals.prefs.setStringList("hist", []);
    globals.prefs.setStringList("his", []);
  }
  globals.li = globals.prefs.getStringList("his")!.toSet();

  globals.incog = globals.prefs.getBool("incog") ?? (false);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    //Setting the Orientation to Vertical
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
          textTheme: TextTheme(
            bodyText1: TextStyle(color: Colors.white),
            bodyText2: TextStyle(color: Colors.white),
            headline1: TextStyle(color: Colors.white),
            headline2: TextStyle(color: Colors.white),
            headline3: TextStyle(color: Colors.white),
            headline4: TextStyle(color: Colors.white),
            headline5: TextStyle(color: Colors.white),
            headline6: TextStyle(color: Colors.white),
          ),
          snackBarTheme: SnackBarThemeData(
            backgroundColor: Colors.black54,
            behavior: SnackBarBehavior.floating,
          ),
          scaffoldBackgroundColor: Colors.transparent,
          primaryColor: Colors.white,
          primarySwatch: MaterialColor(0xFFFFFFFF, <int, Color>{
            50: Color(0xFFFFFFFF),
            100: Color(0xFFFFFFFF),
            200: Color(0xFFFFFFFF),
            300: Color(0xFFFFFFFF),
            400: Color(0xFFFFFFFF),
            500: Color(0xFFFFFFFF),
            600: Color(0xFFFFFFFF),
            700: Color(0xFFFFFFFF),
            800: Color(0xFFFFFFFF),
            900: Color(0xFFFFFFFF),
          }),
          canvasColor: Colors.transparent,
          tabBarTheme: TabBarTheme(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
          ),
          appBarTheme: AppBarTheme(
            brightness: Brightness.dark,
            backgroundColor: Colors.transparent,
            titleTextStyle: TextStyle(color: Colors.white),
            centerTitle: true,
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
          ),
          cupertinoOverrideTheme: CupertinoThemeData(
              scaffoldBackgroundColor: Colors.black,
              primaryColor: Colors.white),
          iconTheme: IconThemeData(color: Colors.white)),
      title: "Untitled Comics",
      home: (globals.prefs.getBool("incog")! == true)
          ? (Loading())
          : ((globals.prefs.getBool("login")!)
              ? (Loading())
              : (Login())), //If Loged In then Open the Main App otherwise Login Page
    );
  }
}
