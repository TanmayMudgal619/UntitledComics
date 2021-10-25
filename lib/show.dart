import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'mangalistviews.dart';
import 'newapilib.dart';
import 'dart:ui';

class showMangas extends StatefulWidget {
  final List<mangaBasic> data;
  final String title;
  showMangas(this.data, this.title);
  @override
  _showMangasState createState() => _showMangasState();
}

class _showMangasState extends State<showMangas> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Center(
          child: Container(
            height: size.height,
            width: size.width,
            child: Image.asset(
              "assets/img/newbg.jpg",
              fit: BoxFit.cover,
            ),
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
          child: Scaffold(
            appBar: CupertinoNavigationBar(
              backgroundColor: Colors.transparent,
              middle: Text(
                widget.title,
                style: TextStyle(color: Colors.white),
              ),
            ),
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: GV(widget.data),
            ),
          ),
        ),
      ],
    );
  }
}
