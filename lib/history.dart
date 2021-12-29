import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'mangalistviews.dart';
import 'globals.dart' as globals;
import 'newapilib.dart';
import 'dart:ui';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  late Future<List<MangaBasic>> history;
  // globals.li = globals.prefs.getStringList("his")!;
  @override
  void initState() {
    if (globals.li.isNotEmpty)
      history = getmangalist(globals.li.toList(), '100');
    super.initState();
  }

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
              "assets/img/maxresdefault.jpg",
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
                "History",
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: (globals.li.isEmpty)
                ? (Text("No History"))
                : (FutureBuilder<List<MangaBasic>>(
                    future: history,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.active:
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return Center(child: CircularProgressIndicator());
                        case ConnectionState.done:
                          if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          } else {
                            print(snapshot.data!.length);
                            return SingleChildScrollView(
                              child: GV(snapshot.data!),
                            );
                          }
                      }
                    },
                  )),
            backgroundColor: Colors.transparent,
          ),
        ),
      ],
    );
  }
}
