import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'helper.dart';
import 'manga.dart';
import 'newapilib.dart';
import 'package:flutter/cupertino.dart';

//Class For Based Comic Tiles
class Perdatatile extends StatelessWidget {
  final MangaBasic perdata;
  final double width;
  Perdatatile(this.perdata, this.width);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return InkWell(
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
                    child: show(context, perdata, height * 0.65, width),
                  ),
                ),
              );
            });
      },
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MangaMain(perdata)));
      },
      child: Container(
        height: 160,
        margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          child: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 105,
                  height: 160,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        perdata.cover,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // ),
                Expanded(
                    child: Container(
                  height: 160,
                  padding: EdgeInsets.only(
                    left: 10,
                    top: 5,
                    bottom: 5,
                    right: 5,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            perdata.title,
                            textScaleFactor: 1.2,
                            style: TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          Text(
                            perdata.authors
                                .toString()
                                .replaceAll("[", "")
                                .replaceAll("]", ""),
                            style: TextStyle(color: Colors.white70),
                            textScaleFactor: 0.9,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Container(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 3.0),
                              child: Icon(Icons.circle,
                                  size: 10.0,
                                  color: (perdata.status == "ongoing")
                                      ? (Colors.blueAccent)
                                      : ((perdata.status == "completed")
                                          ? (Colors.green)
                                          : ((perdata.status == "hiatus")
                                              ? (Colors.orange)
                                              : (Colors.red)))),
                            ),
                            Text(
                              "${perdata.status.toUpperCase()}",
                              textScaleFactor: 0.9,
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GV extends StatelessWidget {
  final List<MangaBasic> data;
  GV(this.data);
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: data.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: (width ~/ 120),
        childAspectRatio: 105 / 160,
        mainAxisSpacing: 10,
        crossAxisSpacing: 5,
      ),
      itemBuilder: (context, i) {
        return Center(child: CurveMangaB(data[i], width));
      },
    );
  }
}

class GVV extends StatelessWidget {
  final List<MangaBasic> data;
  final double width;
  GVV(this.data, this.width);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: data.map((e) => Perdatatile(e, width)).toList(),
    );
  }
}
