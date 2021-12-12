import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'manga.dart';
import 'newapilib.dart';
import 'helper.dart';

class MangaPage extends StatefulWidget {
  final List<MangaBasic> homedata;
  final List<MangaBasic> updates;
  final List<MangaBasic> ss;

  MangaPage(this.homedata, this.updates, this.ss);

  @override
  _MangaPageState createState() => _MangaPageState();
}

class _MangaPageState extends State<MangaPage> {
  int now = 0;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.all(2.5)),
        Container(
          padding: EdgeInsets.all(10),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: CarouselSlider(
                  items: widget.ss
                      .map(
                        (e) => GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MangaMain(e)));
                          },
                          child: Container(
                            width: width,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  child: Container(
                                    width: 150,
                                    height: 220,
                                    child: CachedNetworkImage(
                                      // e.cover,
                                      placeholder: (context, url) => Center(
                                        child: Container(
                                          child: SizedBox(
                                            width: 30,
                                            height: 30,
                                            child: CircularProgressIndicator(),
                                          ),
                                        ),
                                      ),
                                      imageUrl: e.cover,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 2.0),
                                          child: Text(
                                            e.title,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                            ),
                                            overflow: TextOverflow.fade,
                                            maxLines: 3,
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Text(
                                              e.descm,
                                              style: TextStyle(
                                                  color: Colors.white),
                                              overflow: TextOverflow.fade,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  options: CarouselOptions(
                    autoPlay: true,
                    autoPlayCurve: Curves.decelerate,
                    enlargeCenterPage: true,
                    viewportFraction: 1.0,
                    height: 210,
                    onPageChanged: (v, l) {
                      setState(() {
                        now = v;
                      });
                    },
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration: Duration(milliseconds: 650),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.ss.length,
              (index) => Padding(
                padding: const EdgeInsets.all(2.0),
                child: Icon(
                  (index == now)
                      ? (CupertinoIcons.capsule_fill)
                      : (CupertinoIcons.capsule),
                  size: 12,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 5.0,
            bottom: 5.0,
          ),
          child: HorizontalRow(width, "Latest Updates", widget.homedata, 10),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
          child: HorizontalRow(width, "Recently Added", widget.updates, 10),
        ),
      ],
    );
  }
}
