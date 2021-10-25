import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'newapilib.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart' as pp;
import 'globals.dart' as globals;
import 'package:path/path.dart' as path;

class chapter extends StatefulWidget {
  final String id;
  final String title;
  final String vol;
  final String scg;
  final String hash;
  chapter(this.id, this.title, this.vol, this.scg, this.hash);
  @override
  _chapterState createState() => _chapterState();
}

class _chapterState extends State<chapter> {
  late Future<getChapterImg> imgdata;
  String message = "Data";
  double value = 0.0;
  bool ver = true;

  @override
  void initState() {
    super.initState();
    imgdata = getchapterimage(widget.id);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CupertinoNavigationBar(
          backgroundColor: Colors.black,
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
                      globals.prefs
                          .setBool("datas", !globals.prefs.getBool("datas")!);
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
                      var img = File(path.join(globals.appdir.path, picname));
                      return Container(
                        width: (ver) ? (width) : (null),
                        child: (img.existsSync())
                            ? (Image.file(img))
                            : (InkWell(
                                onTap: () {
                                  print(globals.appdir.path);
                                  download(
                                          (!globals.prefs.getBool("datas")!)
                                              ? "${snapshot.data!.baseUrl}/data/${widget.hash}/${snapshot.data!.images[i]}"
                                              : "${snapshot.data!.baseUrl}/data-saver/${widget.hash}/${snapshot.data!.simages[i]}",
                                          picname)
                                      .then((value) => print("object"));
                                },
                                child: CachedNetworkImage(
                                  imageUrl: (!globals.prefs.getBool("datas")!)
                                      ? "${snapshot.data!.baseUrl}/data/${widget.hash}/${snapshot.data!.images[i]}"
                                      : "${snapshot.data!.baseUrl}/data-saver/${widget.hash}/${snapshot.data!.simages[i]}",
                                  placeholder: (context, s) =>
                                      Image.asset("assets/img/ic_launcher.png"),
                                ),
                              )),
                      );
                    });
              } else if (snapshot.hasError) {
                return Center(child: Text("${snapshot.error}"));
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }
}
