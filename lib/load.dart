import 'dart:ui';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'loadhome.dart';
import 'newapilib.dart';
import 'package:flutter/cupertino.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  late Future<List<List<mangaBasic>>> data;
  @override
  void initState() {
    super.initState();
    data = homeload();
    data.then((value) {
      globals.mdata = value;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoadHome(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/img/maxresdefault.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        height: size.height,
        width: size.width,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/img/logo.png",
                fit: BoxFit.scaleDown,
              ),
              Padding(padding: EdgeInsets.all(10.0)),
            ],
          ),
        ),
      ),
    );
  }
}
