import 'package:flutter/material.dart';
import 'newapilib.dart';
import 'manga.dart';

class RandomManga extends StatefulWidget {
  const RandomManga({Key? key}) : super(key: key);

  @override
  _RandomMangaState createState() => _RandomMangaState();
}

class _RandomMangaState extends State<RandomManga> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.black,
        child: FutureBuilder<MangaBasic>(
          future: randommanga(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      snapshot.error.toString(),
                      style: TextStyle(color: Colors.white12),
                    ),
                  );
                } else {
                  return MangaMain(
                    snapshot.data!,
                  );
                }
            }
          },
        ),
      ),
    );
  }
}
