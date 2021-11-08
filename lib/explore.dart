import 'dart:math';

import 'package:flutter/material.dart';
import 'mangalistviews.dart';
import 'show.dart';
import 'newapilib.dart';
import 'package:flutter/cupertino.dart';
import 'globals.dart' as globals;

class Explore extends StatefulWidget {
  //Have to Work on Explore Tab
  Explore();

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  late Future<Map<String, Set<mangaBasic>>> exdata;

  @override
  void initState() {
    exdata = expl(0); //Function to Get random Comics
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, Set<mangaBasic>>>(
      future: exdata,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          default:
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              return RefreshIndicator(
                //To Shuffle The Loaded Comics
                backgroundColor: Colors.white,
                onRefresh: () {
                  return Future.delayed(Duration(seconds: 1), () {
                    setState(() {});
                  });
                },
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: snapshot.data!.entries.map((e) {
                      var a = Random().nextInt((e.value.length > 9)
                          ? (e.value.length - 9)
                          : (e.value.length));
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8.0,
                                top: 8.0,
                                bottom: 3.0,
                              ),
                              child: InkWell(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => showMangas(
                                      e.value.toList(),
                                      globals.gen[e.key]!,
                                    ),
                                  ),
                                ),
                                child: Text.rich(
                                  TextSpan(
                                      text: globals.gen[e.key]!,
                                      children: [
                                        WidgetSpan(
                                            child: Icon(
                                          CupertinoIcons.forward,
                                        ))
                                      ],
                                      style: TextStyle(fontSize: 20)),
                                ),
                              ),
                            ),
                            GV((e.value.length > 9)
                                ? (e.value.toList().sublist(a, a + 9))
                                : (e.value.toList())),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            }
        }
      },
    );
  }
}
