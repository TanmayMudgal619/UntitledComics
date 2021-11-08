import 'package:flutter/material.dart';
import 'newapilib.dart';
import 'manga.dart';

class randomManga extends StatefulWidget {
  const randomManga({Key? key}) : super(key: key);

  @override
  _randomMangaState createState() => _randomMangaState();
}

class _randomMangaState extends State<randomManga> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.black,
        child: FutureBuilder<mangaBasic>(
          future: random_manga(),
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
                  return mangaMain(
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
