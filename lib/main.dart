import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'load.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart' as globals;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart' as pp;
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  globals.prefs = await SharedPreferences.getInstance();
  globals.appdir = await pp.getApplicationDocumentsDirectory();
  final l = globals.prefs.getString("lang") ?? 0;
  if (l == 0) {
    globals.prefs.setString("lang", "EN");
  }
  final chk = globals.prefs.getBool("login") ?? 0;
  if (chk == 0) {
    globals.prefs.setBool("datas", false);
    globals.prefs.setBool("login", false);
    globals.prefs.setString("session", "");
    globals.prefs.setString("refresh", "");
    globals.prefs.setStringList("hist", []);
  }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
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
      title: "App",
      home: (globals.prefs.getBool("login")!) ? (Loading()) : (Login()),
    );
  }
}
