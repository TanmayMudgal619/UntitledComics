import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/rendering.dart';
import 'manga.dart';
import 'newapilib.dart';
import 'show.dart';

//A class for The Horizontal Row on Main Page
class HorizontalRow extends StatelessWidget {
  final double width;
  final String title;
  final List<MangaBasic> items;
  final int count;
  HorizontalRow(this.width, this.title, this.items, this.count);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
              top: 8.0, left: 5.0, bottom: 10.0, right: 8.0),
          child: InkWell(
            splashColor: Colors.transparent,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShowMangas(items, title))),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                      text: title,
                      children: [
                        WidgetSpan(
                          child: Icon(
                            CupertinoIcons.forward,
                          ),
                        ),
                      ],
                      style: TextStyle(fontSize: 20)),
                )
              ],
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: items
                .sublist(0, 10)
                .map(
                  (e) => Container(
                    child: CurveMangaB(e, width),
                    margin: EdgeInsets.only(
                      left: 5,
                      right: 15,
                      bottom: 10,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

//A Class for  Comic Card
class CurveMangaB extends StatelessWidget {
  final MangaBasic item;
  final double width;
  CurveMangaB(this.item, this.width);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return InkWell(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MangaMain(item),
          ),
        );
      },
      onDoubleTap: () {
        //Double Tap to Get Info. about The Comic
        showCupertinoModalPopup(
            context: context,
            builder: (context) {
              return Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: width,
                  height: height * 0.65,
                  child: Material(
                    child: show(context, item, height * 0.65, width),
                  ),
                ),
              );
            });
      },
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Container(
          width: 105,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Colors.white12, width: 3),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Material(
                child: Container(
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        item.cover,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black87, Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          10,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          child: Container(
                            margin: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(1000)),
                            ),
                            padding: EdgeInsets.all(5),
                            child: Icon(CupertinoIcons.circle_fill,
                                size: 10,
                                color: (item.status == "ongoing")
                                    ? (Colors.blueAccent)
                                    : ((item.status == "completed")
                                        ? (Colors.green)
                                        : ((item.status == "hiatus")
                                            ? (Colors.orange)
                                            : (Colors.red)))),
                          ),
                          alignment: Alignment.centerRight,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 3.0, left: 4.0),
                          child: Text(
                            item.title,
                            maxLines: 4,
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                              fontSize: 13.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

InkWell show(
    BuildContext context, MangaBasic item, double height, double width) {
  return InkWell(
    focusColor: Colors.transparent,
    hoverColor: Colors.transparent,
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    onDoubleTap: () {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MangaMain(item),
        ),
      );
    },
    child: Stack(
      children: [
        Column(
          children: [
            Container(
              height: height * 0.14,
              width: width,
            ),
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Container(
                height: height * 0.86,
                width: width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(item.cover),
                    fit: BoxFit.cover,
                  ),
                ),
                child: ClipRRect(
                  child: Container(
                    color: Colors.black12,
                    padding: EdgeInsets.only(top: height * 0.14),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: TextStyle(color: Colors.white),
                                  textScaleFactor: 1.5,
                                ),
                                Text(
                                  item.authors
                                      .toString()
                                      .replaceAll("[", "")
                                      .replaceAll("]", "")
                                      .replaceAll(",", " "),
                                  style: TextStyle(color: Colors.white),
                                ),
                                Padding(padding: EdgeInsets.all(5.0)),
                                Text(
                                  (item.descm == "")
                                      ? ("Nothing Provided by the Uploaders!")
                                      : (item.descm
                                          .replaceAllMapped(
                                              RegExp(r"\[(/)?\w+\]"),
                                              (match) => '')
                                          .replaceAllMapped(
                                              RegExp(r"\[url(.+)]"),
                                              (match) => '')),
                                  style: TextStyle(color: Colors.white),
                                ),
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
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: height * 0.28,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: CachedNetworkImageProvider(item.cover),
                fit: BoxFit.cover,
              ),
            ),
            margin: EdgeInsets.only(right: 8.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.all(Radius.circular(1000)),
                ),
                padding: EdgeInsets.all(5),
                child: Icon(CupertinoIcons.circle_fill,
                    size: 10,
                    color: (item.status == "ongoing")
                        ? (Colors.blueAccent)
                        : ((item.status == "completed")
                            ? (Colors.green)
                            : ((item.status == "hiatus")
                                ? (Colors.orange)
                                : (Colors.red)))),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
