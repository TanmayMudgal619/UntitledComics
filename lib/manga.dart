import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'newapilib.dart';
import 'mangachapter.dart';
import 'globals.dart' as globals;
import 'mangalistviews.dart';
import 'package:cached_network_image/cached_network_image.dart';

class mangaMain extends StatefulWidget {
  mangaBasic data;
  mangaMain(this.data);

  @override
  _mangaMainState createState() => _mangaMainState();
}

class _mangaMainState extends State<mangaMain>
    with SingleTickerProviderStateMixin {
  var offset = 0;
  int next = 1;
  int foll = -1;
  double margin = 0.9;

  late Future<List<mangaChapterData>> chdata;
  ScrollController cnt = ScrollController();
  late TabController taba;
  int current = 0;
  List<mangaChapterData> currentchdata = [];
  bool isload = true;
  List<String> statuses = [
    "reading",
    "on_hold",
    "plan_to_read",
    "dropped",
    "re_reading",
    "completed",
    "Followed"
  ];
  double op = 0.0;
  double top = 0;
  bool exp = false;
  late Future<List<mangaBasic>> rel;
  String st = "Followed", initst = "Followed";
  @override
  void dispose() {
    globals.CT = "";
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    cnt.addListener(() {
      if (margin == 1.0 &&
          cnt.position.userScrollDirection == ScrollDirection.forward &&
          cnt.position.pixels + 1 < cnt.position.maxScrollExtent) {
        setState(() {
          cnt.animateTo(
            cnt.position.minScrollExtent,
            curve: Curves.ease,
            duration: Duration(milliseconds: 200),
          );
          margin = 0.9;
          exp = false;
        });
      }
      if (margin == 0.9 &&
          cnt.position.userScrollDirection == ScrollDirection.reverse) {
        setState(() {
          cnt.animateTo(
            cnt.position.maxScrollExtent,
            curve: Curves.linear,
            duration: Duration(milliseconds: 200),
          );
          margin = 1.0;
          exp = true;
        });
      }
    });
    for (var i in globals.als.entries) {
      if (i.value.indexOf(widget.data.id) != -1) {
        st = i.key;
        initst = st;
      }
    }
    status(widget.data.id, globals.prefs.getString("session")!,
            globals.prefs.getString("refresh")!)
        .then((value) {
      if (value == "OK") {
        if (!mounted) return;
        setState(() {
          foll = 1;
        });
      } else {
        if (!mounted) return;
        setState(() {
          foll = 0;
        });
      }
    });
    globals.CT = widget.data.title;
    rel = get_mangalist_tag(
        widget.data.genrei, widget.data.publicationDemographic, '20');
    chdata = getChapters(widget.data.id.toString(), 100, offset, 'asc', 'asc',
        globals.prefs.getString("lang")!.toLowerCase());
    taba = TabController(length: 3, vsync: this);
    taba.addListener(() {
      setState(() {
        current = taba.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: CachedNetworkImageProvider(
                  widget.data.cover,
                ),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.4), BlendMode.darken)),
          ),
        ),
        Scaffold(
          // floatingActionButtonLocation:
          //     FloatingActionButtonLocation.miniEndFloat,
          // floatingActionButton: (margin == 1.0)
          //     ? (FloatingActionButton(
          //         backgroundColor: Colors.black12,
          //         mini: true,
          //         onPressed: () {
          //           setState(() {
          //             exp = false;
          //             cnt.animateTo(0,
          //                 curve: Curves.linear,
          //                 duration: Duration(milliseconds: 500));
          //             margin = 0.9;
          //           });
          //         },
          //         child: Icon(
          //           CupertinoIcons.chevron_up,
          //         ),
          //       ))
          //     : (null),
          appBar: CupertinoNavigationBar(
            backgroundColor: Colors.transparent,
            brightness: Brightness.dark,
            middle: Text(
              widget.data.title,
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: NestedScrollView(
              controller: cnt,
              headerSliverBuilder: (context, value) {
                return [
                  SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 30, bottom: 30, left: 25, right: 25),
                      width: size.width,
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    border: Border.all(
                                      color: Colors.white12,
                                      width: 3,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: widget.data.cover,
                                          placeholder: (context, url) =>
                                              Container(
                                            height: 200,
                                            child: Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          ),
                                          width: 150,
                                          fit: BoxFit.cover,
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onLongPress: () {
                                              unfollow(
                                                      widget.data.id,
                                                      globals.prefs.getString(
                                                          "session")!,
                                                      globals.prefs.getString(
                                                          "refresh")!)
                                                  .then((value) {
                                                setState(() {
                                                  // op = 1;
                                                  // top = -30;
                                                  foll = 0;
                                                });
                                              });
                                            },
                                            onTap: () {
                                              if (foll == 0)
                                                follow(
                                                        widget.data.id,
                                                        globals.prefs.getString(
                                                            "session")!,
                                                        globals.prefs.getString(
                                                            "refresh")!)
                                                    .then((value) {
                                                  setState(() {
                                                    op = 1;
                                                    top = -30;
                                                    foll = 1;
                                                  });
                                                });
                                              else {
                                                showCupertinoModalPopup(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return Material(
                                                        child: Align(
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom:
                                                                        25.0),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25),
                                                              child:
                                                                  BackdropFilter(
                                                                filter: ImageFilter
                                                                    .blur(
                                                                        sigmaX:
                                                                            10,
                                                                        sigmaY:
                                                                            10),
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10.0),
                                                                  color: Colors
                                                                      .white12,
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .copyWith()
                                                                          .size
                                                                          .width *
                                                                      0.9,
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .copyWith()
                                                                          .size
                                                                          .height /
                                                                      3,
                                                                  child: Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child:
                                                                            Text(
                                                                          "Set Reading Status",
                                                                          style:
                                                                              TextStyle(color: Colors.grey.shade100),
                                                                          textScaleFactor:
                                                                              1.1,
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Container(
                                                                          child:
                                                                              StatefulBuilder(
                                                                            builder:
                                                                                (context, setModalSate) {
                                                                              return SingleChildScrollView(
                                                                                child: Column(
                                                                                  children: statuses
                                                                                      .map((e) => ListTile(
                                                                                            visualDensity: VisualDensity.compact,
                                                                                            leading: Radio(
                                                                                              fillColor: MaterialStateProperty.all(Colors.white),
                                                                                              groupValue: st,
                                                                                              value: e,
                                                                                              onChanged: (String? value) {
                                                                                                setModalSate(() {
                                                                                                  st = value.toString();
                                                                                                });
                                                                                              },
                                                                                            ),
                                                                                            title: Text(
                                                                                              e.toUpperCase(),
                                                                                              style: TextStyle(color: Colors.white),
                                                                                            ),
                                                                                          ))
                                                                                      .toList(),
                                                                                ),
                                                                              );
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            top:
                                                                                8.0,
                                                                            bottom:
                                                                                8.0,
                                                                            right:
                                                                                18,
                                                                            left:
                                                                                18),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            TextButton(
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.all(5.0),
                                                                                child: Icon(
                                                                                  CupertinoIcons.xmark,
                                                                                  color: Colors.redAccent,
                                                                                ),
                                                                              ),
                                                                              onPressed: () {
                                                                                st = initst;
                                                                                Navigator.pop(context);
                                                                              },
                                                                            ),
                                                                            TextButton(
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.all(5.0),
                                                                                child: Icon(
                                                                                  CupertinoIcons.check_mark,
                                                                                  color: Color(0xff0D81EC),
                                                                                ),
                                                                              ),
                                                                              onPressed: () {
                                                                                if (initst != st) {
                                                                                  // print(initst);
                                                                                  if (initst != "Followed") {
                                                                                    globals.als[initst]!.remove(widget.data.id);
                                                                                  }
                                                                                  initst = st;
                                                                                  upst(
                                                                                    widget.data.id,
                                                                                    st.toLowerCase(),
                                                                                    globals.prefs.getString("session")!,
                                                                                    globals.prefs.getString("refresh")!,
                                                                                  ).then((value) {
                                                                                    if (st.toLowerCase() != "followed") {
                                                                                      if (globals.als[st.toLowerCase()]!.isEmpty) {
                                                                                        globals.als[st.toLowerCase()] = [
                                                                                          widget.data.id
                                                                                        ];
                                                                                      } else
                                                                                        globals.als[st.toLowerCase()]!.add(widget.data.id);
                                                                                    }
                                                                                  });
                                                                                }
                                                                                Navigator.pop(context);
                                                                              },
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              }
                                            },
                                            child: Container(
                                              margin: EdgeInsets.all(5.0),
                                              padding: EdgeInsets.only(
                                                top: 1.5,
                                                left: 1.5,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10000),
                                                ),
                                                color: Colors.black87,
                                              ),
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: SizedBox(
                                                    width: 25,
                                                    height: 25,
                                                    child: (foll == -1)
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(3.0),
                                                            child:
                                                                (CircularProgressIndicator(
                                                              strokeWidth: 2.0,
                                                              color:
                                                                  Colors.white,
                                                            )),
                                                          )
                                                        : (Icon(
                                                            (foll == 1)
                                                                ? (CupertinoIcons
                                                                    .bell)
                                                                : (CupertinoIcons
                                                                    .bell_slash),
                                                          )),
                                                  )),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          child: AnimatedOpacity(
                                            opacity: op,
                                            duration: Duration(seconds: 1),
                                            onEnd: () {
                                              setState(() {
                                                op = 0;
                                              });
                                            },
                                            child: Icon(
                                              CupertinoIcons.heart_solid,
                                              size: 50,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 2.0, left: 10.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.data.title,
                                              textScaleFactor: 1.2,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 4,
                                            ),
                                            Text(
                                              widget.data.authors
                                                  .toString()
                                                  .replaceAll("[", "")
                                                  .replaceAll("]", ""),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                            Text(
                                              widget.data.artists
                                                  .toString()
                                                  .replaceAll("[", "")
                                                  .replaceAll("]", ""),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(5.0),
                                            ),
                                            Text(
                                              (widget.data.lastvolume == null)
                                                  ? ("Volumes : N/A")
                                                  : ("Volumes : ${widget.data.lastvolume}"),
                                            ),
                                            Text(
                                              (widget.data.lastchapter == null)
                                                  ? ("Chapters : N/A")
                                                  : ("Chapters : ${widget.data.lastchapter}"),
                                            ),
                                            Text(
                                              (widget.data.publicationDemographic ==
                                                      null)
                                                  ? ("Demography : N/A")
                                                  : ("Demography : ${widget.data.publicationDemographic.toUpperCase()}"),
                                            ),
                                          ],
                                        ),
                                        Padding(padding: EdgeInsets.all(5.0)),
                                        Container(
                                          padding: EdgeInsets.all(5.0),
                                          decoration: BoxDecoration(
                                            color: Colors.black12,
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 3.0),
                                                child: Icon(
                                                    CupertinoIcons
                                                        .circle_filled,
                                                    size: 10.0,
                                                    color: (widget
                                                                .data.status ==
                                                            "ongoing")
                                                        ? (Color(0xff0D81EC))
                                                        : ((widget.data
                                                                    .status ==
                                                                "completed")
                                                            ? (Colors.green)
                                                            : ((widget.data
                                                                        .status ==
                                                                    "hiatus")
                                                                ? (Colors
                                                                    .orange)
                                                                : (Colors
                                                                    .red)))),
                                              ),
                                              Text(
                                                "${widget.data.status.toUpperCase()}",
                                                textScaleFactor: 0.9,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: Container(
                width: size.width * 0.9,
                margin: (margin == 1.0)
                    ? (EdgeInsets.zero)
                    : (EdgeInsets.only(bottom: 20)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: (margin == 1.0)
                          ? (BorderRadius.zero)
                          : (BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            )),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        width: size.width * margin,
                        decoration: BoxDecoration(
                          color: Colors.white38,
                        ),
                        child: TabBar(
                          controller: taba,
                          tabs: [
                            Tab(child: Text("Info")),
                            Tab(child: Text("Chapters")),
                            Tab(child: Text("Based"))
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: ClipRRect(
                        borderRadius: (margin == 1.0)
                            ? (BorderRadius.zero)
                            : (BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              )),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          width: size.width * margin,
                          color: Colors.white38,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TabBarView(
                              physics: NeverScrollableScrollPhysics(),
                              controller: taba,
                              children: [
                                ListView(
                                  children: [
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      dense: true,
                                      horizontalTitleGap: 0.0,
                                      leading: Icon(
                                        CupertinoIcons
                                            .rectangle_fill_on_rectangle_angled_fill,
                                        color: Color(0xff0D81EC),
                                      ),
                                      title: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 12.4),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Sypnosis",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                              textScaleFactor: 1.7,
                                            ),
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              onTap: () => setState(() {
                                                exp = !exp;
                                                if (exp)
                                                  cnt.animateTo(
                                                    cnt.position
                                                        .maxScrollExtent,
                                                    curve: Curves.linear,
                                                    duration: Duration(
                                                        milliseconds: 500),
                                                  );
                                                margin = 1.0;
                                                exp = true;
                                              }),
                                              child: Text(
                                                (widget.data.desc == "")
                                                    ? ("Nothing Provided by the Uploaders!")
                                                    : (widget.data.desc
                                                        .replaceAllMapped(
                                                            RegExp(
                                                                r"\[(/)?\w+\]"),
                                                            (match) => '')
                                                        .replaceAllMapped(
                                                            RegExp(
                                                                r"\[url(.+)]"),
                                                            (match) => '')),
                                                style: TextStyle(
                                                    color: Colors.white70),
                                                textScaleFactor: 1.1,
                                                maxLines: (exp) ? (null) : (10),
                                                overflow: TextOverflow.fade,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      dense: true,
                                      horizontalTitleGap: 0.0,
                                      leading: Icon(
                                        CupertinoIcons.tag,
                                        color: Color(0xff0D81EC),
                                      ),
                                      title: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          (widget.data.genre.isEmpty)
                                              ? Padding(
                                                  padding: EdgeInsets.only(
                                                    right: 5.0,
                                                  ),
                                                  child: (Chip(
                                                    backgroundColor:
                                                        Colors.black54,
                                                    visualDensity:
                                                        VisualDensity.compact,
                                                    label: Text(
                                                      "Read and Find",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  )),
                                                )
                                              : (Wrap(
                                                  children: widget.data.genre
                                                      .map((e) => Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                              right: 5.0,
                                                            ),
                                                            child: Chip(
                                                              backgroundColor:
                                                                  Colors
                                                                      .black54,
                                                              visualDensity:
                                                                  VisualDensity
                                                                      .compact,
                                                              label: Text(
                                                                e,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          ))
                                                      .toList(),
                                                ))
                                        ],
                                      ),
                                    ),
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      dense: true,
                                      horizontalTitleGap: 0.0,
                                      leading: Icon(
                                        CupertinoIcons.tag,
                                        color: Color(0xff0D81EC),
                                      ),
                                      title: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            (widget.data.theme.isEmpty)
                                                ? Padding(
                                                    padding: EdgeInsets.only(
                                                      right: 5.0,
                                                    ),
                                                    child: (Chip(
                                                      backgroundColor:
                                                          Colors.black54,
                                                      visualDensity:
                                                          VisualDensity.compact,
                                                      label: Text(
                                                        "Read and Find",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    )),
                                                  )
                                                : (Wrap(
                                                    children: widget.data.theme
                                                        .map((e) => Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                right: 5.0,
                                                              ),
                                                              child: Chip(
                                                                backgroundColor:
                                                                    Colors
                                                                        .black54,
                                                                visualDensity:
                                                                    VisualDensity
                                                                        .compact,
                                                                label: Text(
                                                                  e,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ))
                                                        .toList(),
                                                  ))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                FutureBuilder<List<mangaChapterData>>(
                                  future: chdata,
                                  builder: (context, snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.active:
                                      case ConnectionState.none:
                                      case ConnectionState.waiting:
                                        if (offset == 0)
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        else
                                          return ListView(
                                              // controller: cnt1,
                                              children: List.generate(
                                                  currentchdata.length + next,
                                                  (i) {
                                            if (i == currentchdata.length)
                                              return TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    offset += 100;
                                                    chdata = getChapters(
                                                        widget.data.id
                                                            .toString(),
                                                        100,
                                                        offset,
                                                        'asc',
                                                        'asc',
                                                        globals.prefs
                                                            .getString("lang")!
                                                            .toLowerCase());
                                                  });
                                                },
                                                child: SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Color(0xff0D81EC)),
                                                ),
                                              );
                                            return chapterTile(
                                              currentchdata[i].id,
                                              currentchdata[i].chapter,
                                              currentchdata[i].volume,
                                              currentchdata[i].title,
                                              currentchdata[i].lang,
                                              currentchdata[i].hash,
                                              currentchdata[i].scg,
                                            );
                                          }));
                                      default:
                                        if (snapshot.hasError) {
                                          return Text(
                                              snapshot.error.toString());
                                        } else {
                                          if (snapshot.data!.isNotEmpty) {
                                            if (snapshot.data!.length < 100)
                                              next = 0;
                                            if (isload) {
                                              currentchdata
                                                  .addAll(snapshot.data!);
                                              isload = false;
                                            }
                                            return ListView(
                                                // controller: cnt1,
                                                children: List.generate(
                                                    currentchdata.length + next,
                                                    (i) {
                                              if (i == currentchdata.length)
                                                return TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      offset += 100;
                                                      isload = true;
                                                      chdata = getChapters(
                                                          widget.data.id
                                                              .toString(),
                                                          100,
                                                          offset,
                                                          'asc',
                                                          'asc',
                                                          globals.prefs
                                                              .getString(
                                                                  "lang")!
                                                              .toLowerCase());
                                                    });
                                                  },
                                                  child: Text(
                                                    "More",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Color(
                                                                0xff0D81EC)),
                                                  ),
                                                );
                                              return chapterTile(
                                                currentchdata[i].id,
                                                currentchdata[i].chapter,
                                                currentchdata[i].volume,
                                                currentchdata[i].title,
                                                currentchdata[i].lang,
                                                currentchdata[i].hash,
                                                currentchdata[i].scg,
                                              );
                                            }));
                                          }
                                          return Center(
                                            child: Text(
                                              "No Chapters For Selected Language!",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          );
                                        }
                                    }
                                  },
                                ),
                                FutureBuilder<List<mangaBasic>>(
                                  future: rel,
                                  builder: (context, snap) {
                                    switch (snap.connectionState) {
                                      case ConnectionState.active:
                                      case ConnectionState.none:
                                      case ConnectionState.waiting:
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      default:
                                        if (snap.hasError)
                                          return Text(snap.error.toString());
                                        else {
                                          if (snap.data!.isNotEmpty) {
                                            return SingleChildScrollView(
                                              // controller: cnt2,
                                              child:
                                                  GVV(snap.data!, size.width),
                                            );
                                          } else
                                            return Center(
                                              child: Text(
                                                "No Other Comic Have Same Traits.",
                                              ),
                                            );
                                        }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
