import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'chapter.dart';
import 'globals.dart' as globals;
import 'newapilib.dart';

class chapterTile extends StatefulWidget {
  final String id;
  final String chapter;
  final String volumne;
  final String title;
  final String lang;
  final String hash;
  final String scg;
  final String bg;
  chapterTile(this.id, this.chapter, this.volumne, this.title, this.lang,
      this.hash, this.scg, this.bg);
  @override
  chapterTileState createState() => chapterTileState();
}

String _emoji(String country) {
  int flagOffset = 0x1F1E6;
  int asciiOffset = 0x41;

  int firstChar = country.codeUnitAt(0) - asciiOffset + flagOffset;
  int secondChar = country.codeUnitAt(1) - asciiOffset + flagOffset;

  String emoji =
      String.fromCharCode(firstChar) + String.fromCharCode(secondChar);
  return emoji;
}

class chapterTileState extends State<chapterTile> {
  late Future<getChapterImg> imgdata;
  int i = -1;
  int j = -1;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      margin: EdgeInsets.only(bottom: 5, top: 5),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: ListTile(
        visualDensity: VisualDensity.compact,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => chapter(widget.id, widget.chapter,
                  widget.volumne, widget.scg, widget.hash, widget.bg),
            ),
          );
        },
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Chapter ${widget.chapter}",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              (widget.title == null)
                  ? ("Chapter ${widget.chapter}")
                  : "${widget.title}",
              style: TextStyle(color: Colors.white),
              textScaleFactor: 0.9,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
        subtitle: Text(
          widget.scg,
          style: TextStyle(color: Colors.white),
          overflow: TextOverflow.ellipsis,
          textScaleFactor: 0.85,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_emoji(globals.languageToFlag[widget.lang]!)),
            // InkWell(
            //   onTap: () {
            //     ScaffoldMessenger.of(context)
            //         .showSnackBar(SnackBar(content: Text("Downloading.....")));
            //     imgdata = getchapterimage(widget.id);
            //     imgdata.then((value) {
            //       downloadl(
            //         value.images.map(
            //           (e) {
            //             j += 1;
            //             return "${value.baseUrl}/data/${widget.hash}/${value.images[j]}";
            //           },
            //         ).toList(),
            //         value.images.map((e) {
            //           i += 1;
            //           return "${widget.id}${widget.volumne}${widget.title}${widget.scg}$i${(!globals.prefs.getBool("datas")!) ? (value.images[i]) : (value.simages[i])}";
            //         }).toList(),
            //       );
            //       ScaffoldMessenger.of(context).showSnackBar(
            //           SnackBar(content: Text("Download Finish!")));
            //     });
            //   },
            //   child: Padding(
            //     padding: const EdgeInsets.only(left: 15),
            //     child: Icon(
            //       CupertinoIcons.download_circle,
            //       size: 20,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
