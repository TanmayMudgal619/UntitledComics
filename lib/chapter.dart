import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'newapilib.dart';
import 'dart:io';
import 'globals.dart' as globals;
import 'package:path/path.dart' as path;

class chapter extends StatefulWidget {
  final String id;
  final String title;
  final String vol;
  final String scg;
  final String hash;
  final String bg;
  chapter(this.id, this.title, this.vol, this.scg, this.hash, this.bg);
  @override
  _chapterState createState() => _chapterState();
}

class _chapterState extends State<chapter> {
  late Future<getChapterImg> imgdata;
  String message = "Data";
  double value = 0.0;
  bool ver = true;
  int i = -1;
  int j = -1;

  @override
  void initState() {
    super.initState();
    imgdata = getchapterimage(widget.id);
    // imgdata.then((value) => downloadl(
    //     value.images.map((e) {
    //       j += 1;
    //       return "${value.baseUrl}/data/${widget.hash}/${value.images[j]}";
    //     }).toList(),
    //     value.images.map((e) {
    //       i += 1;
    //       return "${widget.id}${widget.vol}${widget.title}${widget.scg}$i${(!globals.prefs.getBool("datas")!) ? (value.images[i]) : (value.simages[i])}";
    //     }).toList()));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Center(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  widget.bg,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Container(
            color: Colors.black38,
            child: Scaffold(
              // backgroundColor: Colors.black,
              appBar: CupertinoNavigationBar(
                  backgroundColor: Colors.black38,
                  middle: Text(
                    "Chapter ${widget.title}",
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            right: 18,
                          ),
                          child: GestureDetector(
                            onTap: () => setState(() {
                              globals.prefs.setBool(
                                  "datas", !globals.prefs.getBool("datas")!);
                            }),
                            child: Icon(
                              CupertinoIcons.wifi,
                              size: 18,
                              color: (globals.prefs.getBool("datas")!)
                                  ? (Colors.blue)
                                  : (Colors.white),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() {
                            if (ver) {
                              ver = false;
                            } else {
                              ver = true;
                            }
                          }),
                          child: Icon(
                            (ver)
                                ? (CupertinoIcons.rectangle_expand_vertical)
                                : (CupertinoIcons.rectangle_compress_vertical),
                            size: 20.0,
                          ),
                        ),
                      ],
                    ),
                  )),
              body: Center(
                child: FutureBuilder<getChapterImg>(
                    future: imgdata,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            padding: EdgeInsets.zero,
                            addAutomaticKeepAlives: true,
                            scrollDirection:
                                (ver) ? (Axis.vertical) : (Axis.horizontal),
                            itemCount: snapshot.data!.images.length,
                            itemBuilder: (context, i) {
                              var picname =
                                  "${widget.id}${widget.vol}${widget.title}${widget.scg}$i${(!globals.prefs.getBool("datas")!) ? (snapshot.data!.images[i]) : (snapshot.data!.simages[i])}";
                              var img =
                                  File(path.join(globals.appdir.path, picname));
                              return Container(
                                width: (ver) ? (width) : (null),
                                child: (img.existsSync())
                                    ? (Image.file(img))
                                    : (
                                        // : (InkWell(
                                        //     onTap: () {
                                        //       print(globals.appdir.path);
                                        //       download(
                                        //               (!globals.prefs.getBool("datas")!)
                                        //                   ? "${snapshot.data!.baseUrl}/data/${widget.hash}/${snapshot.data!.images[i]}"
                                        //                   : "${snapshot.data!.baseUrl}/data-saver/${widget.hash}/${snapshot.data!.simages[i]}",
                                        //               picname)
                                        //           .then((value) => print("object"));
                                        //     },
                                        // child:
                                        CachedNetworkImage(
                                        imageUrl: (!globals.prefs
                                                .getBool("datas")!)
                                            ? "${snapshot.data!.baseUrl}/data/${widget.hash}/${snapshot.data!.images[i]}"
                                            : "${snapshot.data!.baseUrl}/data-saver/${widget.hash}/${snapshot.data!.simages[i]}",
                                        placeholder: (context, s) =>
                                            Image.asset(
                                          "assets/img/logo.png",
                                        ),
                                        // ),
                                      )),
                              );
                            });
                      } else if (snapshot.hasError) {
                        return Center(child: Text("${snapshot.error}"));
                      }
                      return Container(
                        child: Center(child: CircularProgressIndicator()),
                        color: Colors.black38,
                      );
                    }),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
