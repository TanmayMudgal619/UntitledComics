import 'package:flutter/material.dart';
import 'helper.dart';
import 'manga.dart';
import 'newapilib.dart';
import 'package:flutter/cupertino.dart';

//Class For Based Comic Tiles
class perdatatile extends StatelessWidget {
  mangaBasic perdata;
  double width;
  perdatatile(this.perdata, this.width);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onDoubleTap: () {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return InkWell(
                onDoubleTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => mangaMain(perdata),
                      ));
                },
                child: Container(
                  height: width * 5 / 4,
                  width: width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        perdata.cover,
                      ),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    color: Colors.black87.withOpacity(0.75),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    perdata.cover,
                                    width: 100,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      perdata.title,
                                      style: TextStyle(color: Colors.white),
                                      textScaleFactor: 1.5,
                                    ),
                                    Text(
                                      perdata.authors
                                          .toString()
                                          .replaceAll("[", "")
                                          .replaceAll("]", "")
                                          .replaceAll(",", " "),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.all(5.0)),
                          Text(
                            perdata.descm,
                            style: TextStyle(color: Colors.white),
                          ),
                          Padding(padding: EdgeInsets.all(5.0)),
                          Wrap(
                            children: perdata.genre
                                .map((e) => Card(
                                      margin: EdgeInsets.only(
                                          right: 5.0, bottom: 8.0),
                                      color: Colors.black,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          e,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            });
      },
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => mangaMain(perdata)));
      },
      child: Container(
        height: width * 0.3 / 1.4,
        margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
        padding: EdgeInsets.only(left: width * 0.03),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: width * 0.22 / 1.4,
              height: width * 0.3 / 1.4,
              child: Image.network(
                perdata.cover,
                width: width * 0.22 / 1.4,
                height: width * 0.3 / 1.4,
                fit: BoxFit.cover,
              ),
            ),
            // ),
            Expanded(
                child: Container(
              height: width * 0.3 / 1.4,
              padding: EdgeInsets.only(left: width * 0.03),
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
                      ),
                      Text(
                        perdata.authors
                            .toString()
                            .replaceAll("[", "")
                            .replaceAll("]", ""),
                        style: TextStyle(color: Colors.white60),
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
                          style: TextStyle(color: Colors.grey),
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
    );
  }
}

class GV extends StatelessWidget {
  List<mangaBasic> data;
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
  List<mangaBasic> data;
  double width;
  GVV(this.data, this.width);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: data.map((e) => perdatatile(e, width)).toList(),
    );
  }
}
