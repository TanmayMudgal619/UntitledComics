import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'chapter.dart';
import 'globals.dart' as globals;

class chapterTile extends StatefulWidget {
  final String id;
  final String chapter;
  final String volumne;
  final String title;
  final String lang;
  final String hash;
  final String scg;
  chapterTile(this.id, this.chapter, this.volumne, this.title, this.lang,
      this.hash, this.scg);
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
                      widget.volumne, widget.scg, widget.hash)));
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
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Icon(
                CupertinoIcons.download_circle,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
