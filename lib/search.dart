import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'newapilib.dart';
import 'mangalistviews.dart';

class Search extends StatefulWidget {
  List<mangaBasic> data;
  Search(this.data);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return GV(widget.data);
  }
}
