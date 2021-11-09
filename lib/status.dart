import 'package:flutter/material.dart';
import 'mangalistviews.dart';
import 'newapilib.dart';
import 'globals.dart' as globals;

class Status extends StatefulWidget {
  const Status({Key? key}) : super(key: key);

  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  Map<String, Map<String, dynamic>> alsts = {
    "reading": {
      "data": globals.comicstatus["reading"],
      "off": 0,
      "loading": false,
      "loaded": <mangaBasic>[],
      "next": true,
      "scroll": null,
    },
    "on_hold": {
      "data": globals.comicstatus["on_hold"],
      "off": 0,
      "loading": false,
      "loaded": <mangaBasic>[],
      "next": true,
      "scroll": null,
    },
    "plan_to_read": {
      "data": globals.comicstatus["plan_to_read"],
      "off": 0,
      "loading": false,
      "loaded": <mangaBasic>[],
      "next": true,
      "scroll": null,
    },
    "dropped": {
      "data": globals.comicstatus["dropped"],
      "off": 0,
      "loading": false,
      "loaded": <mangaBasic>[],
      "next": true,
      "scroll": null,
    },
    "re_reading": {
      "data": globals.comicstatus["re_reading"],
      "off": 0,
      "loading": false,
      "loaded": <mangaBasic>[],
      "next": true,
      "scroll": null,
    },
    "completed": {
      "data": globals.comicstatus["completed"],
      "off": 0,
      "loading": false,
      "loaded": <mangaBasic>[],
      "next": true,
      "scroll": null,
    }
  };
  @override
  void initState() {
    alsts.entries.forEach((element) {
      element.value["scroll"] = ScrollController();
      element.value["scroll"].addListener(() {
        if ((element.value["scroll"].offset >=
                element.value["scroll"].position.maxScrollExtent) &&
            !element.value["scroll"].position.outOfRange &&
            element.value["next"] &&
            !element.value["loading"]) {
          setState(() {
            element.value["loading"] = true;
            element.value["off"] += 100;
            get_mangalist(
                    element.value["data"].sublist(
                        element.value["off"],
                        (element.value["data"].length - element.value["off"] >=
                                100)
                            ? (100)
                            : (null)),
                    '100')
                .then((value) => setState(() {
                      element.value["loaded"].addAll(value);
                      element.value["loading"] = false;
                      if (value.length < 100) {
                        element.value["next"] = false;
                      }
                    }));
          });
        }
      });
      if (element.value["data"] != null)
        get_mangalist(
                element.value["data"].sublist(
                    0,
                    (element.value["data"].length - element.value["off"] >= 100)
                        ? (100)
                        : (null)),
                '100')
            .then((value) {
          if (!mounted) return;
          setState(() {
            element.value["loaded"].addAll(value);
            if (value.length < 100) {
              element.value["next"] = false;
            }
          });
        });
      else {
        if (!mounted) return;
        setState(() {
          element.value["next"] = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TabBar(
          isScrollable: true,
          indicatorColor: Colors.white,
          tabs: [
            Tab(
              child: Text("Reading"),
            ),
            Tab(
              child: Text("On Hold"),
            ),
            Tab(
              child: Text("Plan to Read"),
            ),
            Tab(
              child: Text("Dropped"),
            ),
            Tab(
              child: Text("Re Reading"),
            ),
            Tab(
              child: Text("Completed"),
            ),
          ],
        ),
        Flexible(
          fit: FlexFit.loose,
          child: TabBarView(
              children: alsts.entries
                  .map((e) => (e.value["loaded"].isEmpty)
                      ? ((e.value["next"])
                          ? (Center(
                              child: CircularProgressIndicator(),
                            ))
                          : Center(child: (Text("Nothing Here!"))))
                      : (SingleChildScrollView(
                          controller: e.value["scroll"],
                          child: GV(
                            e.value["loaded"],
                          ),
                        )))
                  .toList()),
        ),
      ],
    );
  }
}
