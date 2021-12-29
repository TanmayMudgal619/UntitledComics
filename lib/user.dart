import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'globals.dart' as globals;
import 'login.dart';
import 'dart:ui';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String lang = globals.prefs.getString("lang")!;

  void showPicker() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          lang = "ANY";
          return Material(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 11.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      color: Colors.white12,
                      width: MediaQuery.of(context).copyWith().size.width * 0.9,
                      height: MediaQuery.of(context).copyWith().size.height / 3,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Select Your Preffered Language",
                              style: TextStyle(color: Colors.grey),
                              textScaleFactor: 1.1,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: CupertinoPicker(
                                useMagnifier: true,
                                magnification: 1.2,
                                backgroundColor: Colors.transparent,
                                onSelectedItemChanged: (value) {
                                  setState(() {
                                    lang = globals.langs[value].toString();
                                  });
                                },
                                itemExtent: 32.0,
                                children: List.generate(
                                    globals.langs.length,
                                    (i) => DropdownMenuItem(
                                        value: globals.langs[i],
                                        child: Center(
                                          child: Text(
                                            globals.langs[i],
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ))),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, bottom: 8.0, right: 18, left: 18),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Icon(
                                      CupertinoIcons.xmark,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                TextButton(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Icon(
                                      CupertinoIcons.check_mark,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      globals.prefs.setString("lang", lang);
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: Container(
              height: 250,
              width: size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10000.0),
                    child: Image.asset(
                      "assets/img/as.jpeg",
                      fit: BoxFit.fill,
                      width: 100,
                      height: 100,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        globals.prefs.getString("username")!,
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 15.0,
              right: 15.0,
              top: 8.0,
              bottom: 8.0,
            ),
            child: ListTile(
              tileColor: Colors.white30,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              onTap: showPicker,
              title: Text(
                "Chapter Language",
                style: TextStyle(color: Colors.white),
              ),
              trailing: Text(globals.prefs.getString("lang")!),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 15.0,
              right: 15.0,
              top: 8.0,
              bottom: 8.0,
            ),
            child: ListTile(
              onTap: () => showCupertinoModalPopup(
                  context: context,
                  builder: (context) {
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Material(
                        child: Container(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                padding: EdgeInsets.all(10.0),
                                color: Colors.white12,
                                width: MediaQuery.of(context)
                                        .copyWith()
                                        .size
                                        .width *
                                    0.9,
                                height: MediaQuery.of(context)
                                        .copyWith()
                                        .size
                                        .height *
                                    0.32,
                                child: StatefulBuilder(
                                  builder: (context, setModalSate) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 8.0),
                                      child: Column(
                                        children: [
                                          ListTile(
                                            dense: true,
                                            onTap: () => setState(() {
                                              globals.csafe = !globals.csafe;
                                            }),
                                            title: Text(
                                              "Safe",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                              ),
                                            ),
                                            trailing: Switch(
                                              inactiveTrackColor: Colors.white,
                                              activeTrackColor:
                                                  Colors.grey.shade300,
                                              activeColor: Colors.black12,
                                              value: globals.csafe,
                                              onChanged: (value) {
                                                setModalSate(() {
                                                  globals.csafe = value;
                                                });
                                              },
                                            ),
                                          ),
                                          ListTile(
                                            dense: true,
                                            title: Text(
                                              "Suggestive",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                              ),
                                            ),
                                            trailing: Switch(
                                              inactiveTrackColor: Colors.white,
                                              activeTrackColor:
                                                  Colors.grey.shade300,
                                              activeColor: Colors.black12,
                                              value: globals.csugs,
                                              onChanged: (value) {
                                                setModalSate(() {
                                                  globals.csugs = value;
                                                });
                                              },
                                            ),
                                          ),
                                          ListTile(
                                            dense: true,
                                            title: Text(
                                              "Erotica",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                              ),
                                            ),
                                            trailing: Switch(
                                              inactiveTrackColor: Colors.white,
                                              activeTrackColor:
                                                  Colors.grey.shade300,
                                              activeColor: Colors.black12,
                                              value: globals.cero,
                                              onChanged: (value) {
                                                setModalSate(() {
                                                  globals.cero = value;
                                                });
                                              },
                                            ),
                                          ),
                                          ListTile(
                                            dense: true,
                                            title: Text(
                                              "Pornographic",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                              ),
                                            ),
                                            trailing: Switch(
                                              inactiveTrackColor: Colors.white,
                                              activeTrackColor:
                                                  Colors.grey.shade300,
                                              activeColor: Colors.black12,
                                              value: globals.cpor,
                                              onChanged: (value) {
                                                setModalSate(() {
                                                  globals.cpor = value;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              tileColor: Colors.white30,
              title: Text(
                "Content Filter",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 15.0,
              right: 15.0,
              top: 8.0,
              bottom: 8.0,
            ),
            child: MergeSemantics(
              child: ListTile(
                tileColor: Colors.white30,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                title: Text(
                  "Data Saver",
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Switch(
                  inactiveTrackColor: Colors.white,
                  activeTrackColor: Colors.grey.shade300,
                  activeColor: Colors.black12,
                  value: globals.prefs.getBool("datas")!,
                  onChanged: (bool value) {
                    setState(() {
                      globals.prefs.setBool("datas", value);
                    });
                  },
                ),
                onTap: () {
                  setState(() {
                    globals.prefs
                        .setBool("datas", !globals.prefs.getBool("datas")!);
                  });
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 15.0,
              right: 15.0,
              top: 8.0,
              bottom: 8.0,
            ),
            child: MergeSemantics(
              child: ListTile(
                tileColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                title: Text(
                  "Log Out",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  setState(() {
                    globals.prefs.setBool("login", false);
                    globals.prefs.setBool("incog", true);
                    globals.prefs.setStringList("his", []);
                    globals.li.clear();
                  });
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                      (route) => false);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
