import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'newapilib.dart';
import 'globals.dart' as globals;

class Chapter extends StatefulWidget {
  final String id;
  final String title;
  final String vol;
  final String scg;
  final String hash;
  final String bg;
  Chapter(this.id, this.title, this.vol, this.scg, this.hash, this.bg);
  @override
  _ChapterState createState() => _ChapterState();
}

class _ChapterState extends State<Chapter> {
  //List of Images in the Chapter
  late Future<GetChapterImg> imgdata;
  //View Vertical or Horiizontal
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
                child: FutureBuilder<GetChapterImg>(
                    future: imgdata,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          color: Colors.black45,
                          child: ListView.builder(
                              padding: EdgeInsets.zero,
                              addAutomaticKeepAlives: true,
                              scrollDirection:
                                  (ver) ? (Axis.vertical) : (Axis.horizontal),
                              itemCount: snapshot.data!.images.length,
                              itemBuilder: (context, i) {
                                // var picname =
                                //     "${widget.id}${widget.vol}${widget.title}${widget.scg}$i${(!globals.prefs.getBool("datas")!) ? (snapshot.data!.images[i]) : (snapshot.data!.simages[i])}";
                                // var img =
                                //     File(path.join(globals.appdir.path, picname));
                                return Container(
                                  width: (ver) ? (width) : (null),
                                  child: CachedNetworkImage(
                                    imageUrl: (!globals.prefs.getBool("datas")!)
                                        ? "${snapshot.data!.baseUrl}/data/${widget.hash}/${snapshot.data!.images[i]}"
                                        : "${snapshot.data!.baseUrl}/data-saver/${widget.hash}/${snapshot.data!.simages[i]}",
                                    placeholder: (context, s) => Image.asset(
                                      "assets/img/logo.png",
                                    ),
                                  ),
                                );
                              }),
                        );
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
