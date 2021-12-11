import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'newapilib.dart';
import 'globals.dart' as globals;
import 'load.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usrnm =
      TextEditingController(); //Text Controller for Username
  TextEditingController pswd =
      TextEditingController(); //Text Controller for Password
  bool show = false; //Show Password

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Container(
              decoration: BoxDecoration(
            image: DecorationImage(
              image:
                  AssetImage("assets/img/maxresdefault.jpg"), //Background Image
              fit: BoxFit.cover,
            ),
          )),
        ),
        BackdropFilter(
          filter:
              ImageFilter.blur(sigmaX: 4, sigmaY: 4), //To Create Blur Effect
          child: Scaffold(
            appBar: AppBar(
              brightness: Brightness.dark,
              automaticallyImplyLeading: false,
              title: Text(
                "Login",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.transparent,
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        padding: EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                          color: Colors.white12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/img/logo.png", //App Logo
                              width: 50,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 1.0),
                              child: TextFormField(
                                controller: usrnm,
                                style: TextStyle(color: Colors.white),
                                cursorColor: Colors.white,
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                      width: 3,
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black26,
                                      width: 3,
                                    ),
                                  ),
                                  labelText: 'Username',
                                  labelStyle: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(8.0)),
                            Padding(
                              padding: const EdgeInsets.only(left: 1.0),
                              child: TextFormField(
                                controller: pswd,
                                obscureText: !show,
                                style: TextStyle(color: Colors.white),
                                cursorColor: Colors.white,
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                      width: 3,
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black26,
                                      width: 3,
                                    ),
                                  ),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        show = !show;
                                      });
                                    },
                                    child: Icon(
                                      (show)
                                          ? (Icons.remove_red_eye)
                                          : (Icons.remove_red_eye_outlined),
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  labelText: 'Password',
                                  labelStyle: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: ListTile(
                                tileColor: Colors.white24,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                leading: Icon(Icons.login),
                                onTap: () async {
                                  if (usrnm.text.isNotEmpty &&
                                      pswd.text
                                          .isNotEmpty) //Checking if Username or Password is Empty
                                  {
                                    var a;
                                    try {
                                      a = await login(
                                          usrnm.text, pswd.text); //Log In
                                    } catch (e) {
                                      if (e.toString() ==
                                          "Exception: Error code : 400") {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Invalid Username/Password!",
                                            ),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(e.toString()),
                                          ),
                                        );
                                      }
                                      return;
                                    }
                                    globals.prefs.setBool("incog", false);
                                    globals.prefs.setString("session",
                                        a["session"]); //Storing The Token
                                    globals.prefs.setString("refresh",
                                        a["refresh"]); //Storing The Refreshing Token
                                    globals.prefs.setString("username",
                                        usrnm.text); //Storing The Username
                                    globals.prefs.setBool("login",
                                        true); //Changing The State in Loged In
                                    globals.incog = false;
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Loading(), //Called To load the Data For Home Page
                                      ),
                                    );
                                  }
                                },
                                title: Text(
                                  "LogIn",
                                  style: TextStyle(color: Colors.black45),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: ListTile(
                                tileColor: Colors.white24,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                leading: Icon(Icons.person_off_rounded),
                                onTap: () {
                                  globals.incog = true;
                                  globals.prefs.setBool("incog", true);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Loading()));
                                },
                                title: Text(
                                  "Incognito",
                                  style: TextStyle(color: Colors.black45),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
