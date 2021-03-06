import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as https;
import 'dart:convert';
import 'globals.dart' as globals;
// import 'package:path_provider/path_provider.dart' as pathProvider;
// import 'package:path/path.dart' as path;

// Future<void> download(String _url, String picname) async {
//   final response = await https.get(Uri.parse(_url));

//   final appDir = await pathProvider.getApplicationDocumentsDirectory();

//   final localPath = path.join(appDir.path, picname);

//   final imageFile = File(localPath);
//   await imageFile.writeAsBytes(response.bodyBytes);
// }

// Future<void> downloadl(List url, List picname) async {
//   final response = await Future.wait(url.map((e) => https.get(Uri.parse(e))));

//   final appDir = await pathProvider.getApplicationDocumentsDirectory();

//   final List<String> localPath =
//       picname.map((e) => path.join(appDir.path, e)).toList();

//   final List<File> imageFile = localPath.map((e) => File(e)).toList();
//   for (int i = 0; i < picname.length; i++) {
//     await imageFile[i].writeAsBytes(response[i].bodyBytes);
//   }
//   // await Future.wait(response.map((e) => imageFile.writeAsBytes(e.bodyBytes)));
// }

class MangaBasic {
  String id;
  String title;
  String cover;
  String descm;
  String desc;
  String lang;
  String lastvolume;
  String lastchapter;
  String status;
  List<dynamic> authors;
  List<dynamic> artists;
  String publicationDemographic;
  List<String> genre;
  List<String> genrei;
  List<String> theme;
  MangaBasic({
    required this.id,
    required this.title,
    required this.cover,
    required this.descm,
    required this.desc,
    required this.lang,
    required this.lastvolume,
    required this.lastchapter,
    required this.status,
    required this.authors,
    required this.artists,
    required this.publicationDemographic,
    required this.genre,
    required this.genrei,
    required this.theme,
  });

  factory MangaBasic.fromJson(Map<String, dynamic> json) {
    json["author"] = [];
    json["artist"] = [];
    var dm = (json["attributes"]["description"].toString() == "[]")
        ? ("Read & Find!")
        : (((json["attributes"]["description"]["en"] == null)
                ? (json["attributes"]["description"]
                    [json["attributes"]["description"].entries.toList()[0].key])
                : (json["attributes"]["description"]["en"]))
            .replaceAllMapped(RegExp(r"\[(/)?\w+\]"), (match) => '')
            .replaceAllMapped(RegExp(r"\[url(.+)]"), (match) => ''));
    var d = (json["attributes"]["description"].toString() == "[]")
        ? ("Read & FInd!")
        : (json["attributes"]["description"]
            .values
            .reduce((e, f) => e + "\n\n" + f)
            .replaceAllMapped(RegExp(r"\[(/)?\w+\]"), (match) => '')
            .replaceAllMapped(RegExp(r"\[url(.+)]"), (match) => ''));
    for (var i in json["relationships"]) {
      if (i["type"] == "cover_art")
        // json["cover"] =
        //     "https://uploads.mangadex.org/covers/${json["id"]}/${i["attributes"]["fileName"]}.${(globals.datas == true) ? ('256') : ('512')}.jpg";
        json["cover"] =
            "https://uploads.mangadex.org/covers/${json["id"]}/${i["attributes"]["fileName"]}.256.jpg";
      else {
        if (json[i["type"]] == null) {
          if (i["attributes"] != null)
            json[i["types"]] = [i["attributes"]["name"]];
          else
            json[i["types"]] = [i["attributes"].toString()];
        } else {
          if (i["attributes"] != null)
            json[i["type"]].add(i["attributes"]["name"]);
          else
            json[i["type"]].add(i["attributes"].toString());
        }
      }
    }
    if (json["cover"] == null)
      json["cover"] =
          "https://mangadex.org/_nuxt/img/cover-placeholder.d12c3c5.jpg";
    List<String> g = [];
    List<String> t = [];
    List<String> gi = [];
    for (var i in json["attributes"]["tags"]) {
      var j = i["attributes"];
      if (j["group"] == "genre") {
        gi.add(i["id"]);
        g.add(j["name"]["en"]);
      } else if (j["group"] == "theme") {
        t.add(j["name"]["en"]);
      }
    }
    return MangaBasic(
      id: json["id"],
      title: json["attributes"]["title"]
          [json["attributes"]["title"].entries.toList()[0].key],
      cover: json["cover"],
      descm: dm,
      desc: d,
      lang: json["attributes"]["originalLanguage"],
      lastvolume: json["attributes"]["lastVolume"],
      lastchapter: json["attributes"]["lastChapter"],
      publicationDemographic: json["attributes"]["publicationDemographic"],
      status: json["attributes"]["status"],
      authors: json["author"],
      artists: json["artist"],
      genre: g,
      genrei: gi,
      theme: t,
    );
  }
}

Future<MangaBasic> getmanga(var id) async {
  var url = Uri.http("api.mangadex.org", "/manga/$id", {
    "includes[]": ["author", "artist", "cover_art"],
  });
  var response = await https.get(url);
  if (response.statusCode == 200) {
    var jsonR = json.decode(response.body);
    return MangaBasic.fromJson(jsonR);
  } else {
    throw Exception("Error Code : ${response.statusCode}");
  }
}

Future<List<MangaBasic>> getmangalist(List<String> ids, var limit) async {
  var url = Uri.http("api.mangadex.org", "/manga", {
    "ids[]": ids,
    "limit": limit,
    "includes[]": ["author", "artist", "cover_art"],
  });
  var response = await https.get(url);
  if (response.statusCode == 200) {
    var jsonR = json.decode(response.body);
    List<MangaBasic> sedata = [];
    for (var i in jsonR["data"]) {
      sedata.add(MangaBasic.fromJson(i));
    }
    return sedata;
  } else {
    throw Exception("Error Code : ${response.statusCode}");
  }
}

Future<List<MangaBasic>> getmangalisttag(
    List<String> ids, var demo, var limit) async {
  var url;
  if (demo != null) {
    url = Uri.http("api.mangadex.org", "/manga", {
      "includedTags[]": ids,
      "publicationDemographic[]": demo,
      "limit": limit,
      "includes[]": ["author", "artist", "cover_art"],
    });
  } else {
    url = Uri.http("api.mangadex.org", "/manga", {
      "includedTags[]": ids,
      "limit": limit,
      "includes[]": ["author", "artist", "cover_art"],
    });
  }
  var response = await https.get(url);
  if (response.statusCode == 200) {
    var jsonR = json.decode(response.body);
    List<MangaBasic> sedata = [];
    for (var i in jsonR["data"]) {
      sedata.add(MangaBasic.fromJson(i));
    }
    return sedata;
  } else {
    throw Exception("Error Code : ${response.statusCode}");
  }
}

Future<List<MangaBasic>> searchmanga(var title, var limit, var offset) async {
  List a = [
    (globals.csafe) ? ("safe") : (null),
    (globals.csugs) ? ("suggestive") : (null),
    (globals.cpor) ? ("pornographic") : (null),
    (globals.cero) ? ("erotica") : (null),
  ];
  a.removeWhere((element) => element == null);
  var url = Uri.http("api.mangadex.org", "/manga", {
    "title": title,
    "limit": limit.toString(),
    "offset": offset.toString(),
    "includes[]": ["author", "artist", "cover_art"],
    "contentRating[]": a,
  });
  var response = await https.get(url);
  if (response.statusCode == 200) {
    var jsonR = json.decode(response.body);
    List<MangaBasic> sedata = [];
    for (var i in jsonR["data"]) {
      sedata.add(MangaBasic.fromJson(i));
    }
    return sedata;
  } else {
    throw Exception("Error Code : ${response.statusCode}");
  }
}

Future<MangaBasic> randommanga() async {
  var url = Uri.http("api.mangadex.org", "/manga/random", {
    "includes[]": ["author", "artist", "cover_art"],
  });
  var response = await https.get(url);
  if (response.statusCode == 200) {
    return MangaBasic.fromJson(json.decode(response.body)["data"]);
  } else {
    throw Exception("Error code : ${response.statusCode}");
  }
}

Future<String> getcover(var id) async {
  var url = Uri.http("api.mangadex.org", "/cover/$id");
  var response = await https.get(url);
  if (response.statusCode == 200) {
    var jsonR = json.decode(response.body);
    for (var i in jsonR["relationships"]) {
      if (i["type"] == "manga") {
        return "https://uploads.mangadex.org/covers/${i["id"]}/${jsonR["data"]["attributes"]["fileName"]}";
      }
    }
    throw Exception("Cover Relation Not Found!");
  } else {
    throw Exception("Error Code : ${response.statusCode}");
  }
}

class MangaChapterData {
  String id;
  String title;
  String hash;
  String lang;
  String chapter;
  String volume;
  String scg;
  MangaChapterData(
      {required this.id,
      required this.title,
      required this.hash,
      required this.lang,
      required this.chapter,
      required this.volume,
      required this.scg});

  factory MangaChapterData.fromJson(Map<String, dynamic> json) {
    String scg = "";
    for (var i in json["relationships"]) {
      if (i["type"] == "scanlation_group") {
        scg = i["attributes"]["name"];
      }
    }
    return MangaChapterData(
        id: json['id'],
        title: json['attributes']['title'],
        hash: json['attributes']['hash'],
        lang: json['attributes']['translatedLanguage'],
        chapter: json['attributes']['chapter'],
        volume: json['attributes']['volume'],
        scg: scg);
  }
}

class GetChapterImg {
  final String baseUrl;
  final List<dynamic> images;
  final List<dynamic> simages;
  GetChapterImg(this.baseUrl, this.images, this.simages);
}

Future<GetChapterImg> getchapterimage(String id) async {
  var url = Uri.http("api.mangadex.org", "/chapter/$id");
  var surl = Uri.http("api.mangadex.org", "/at-home/server/$id");
  var response = await https.get(url);
  var sresponse = await https.get(surl);
  if (response.statusCode == 200) {
    var jsondata = jsonDecode(response.body)["data"]["attributes"];
    var baseUrl = jsonDecode(sresponse.body)["baseUrl"];
    return GetChapterImg(baseUrl, jsondata["data"], jsondata["dataSaver"]);
  } else {
    throw Exception("Not Able to Load Images");
  }
}

Future<List<List<MangaBasic>>> homeload() async {
  List<String> a = [
    '32d76d19-8a05-4db0-9fc2-e0b0648fe9d0',
    'c80873ba-a29c-4285-9e3b-9b2b03be3d65',
    '6e3553b9-ddb5-4d37-b7a3-99998044774e',
    '02f0f46c-3c5e-4338-b20b-ee782cc11932',
    'e4429b48-f543-47cd-ad2d-39e73ab264e5',
    'be6e00ba-27da-4d7c-8489-8518935e9ad4',
    '922d3987-3cb9-4c42-a510-db10795cafc0',
    'd8a959f7-648e-4c8d-8f23-f1f3f8e129f3',
    '1caae7cb-9e28-48c4-96a2-9a24ead822ff',
    '5bbc4409-59eb-4388-8c35-149b19b468f1',
    'c5e951db-57fa-4caf-abea-6624b98c4716',
    'bbaa17c4-0f36-4bbb-9861-34fc8fdf20fc',
    '4c86f38a-cead-4575-a9c3-acf7261a58ff',
  ];
  var s = Uri.http("api.mangadex.org", "/manga", {
    "ids[]": a,
    "limit": "100",
    "includes[]": ["author", "artist", "cover_art"],
  });
  var top = Uri.http("api.mangadex.org", "/manga", {
    "limit": '50',
    "offset": '0',
    "includes[]": ["author", "artist", "cover_art"],
  });
  var newm = Uri.http("api.mangadex.org", "/manga", {
    "limit": '50',
    "offset": '0',
    "order[createdAt]": "desc",
    "includes[]": ["author", "artist", "cover_art"],
  });
  var responses =
      await Future.wait([https.get(top), https.get(newm), https.get(s)]);
  if (responses[0].statusCode == 200 && responses[1].statusCode == 200) {
    var jsonT = jsonDecode(responses[0].body);
    var jsons = jsonDecode(responses[2].body);
    var jsonN = jsonDecode(responses[1].body);
    List<MangaBasic> tdata = [];
    List<MangaBasic> sdata = [];
    List<MangaBasic> ndata = [];
    for (var i in jsons["data"]) {
      sdata.add(MangaBasic.fromJson(i));
    }
    for (var i in jsonT["data"]) {
      tdata.add(MangaBasic.fromJson(i));
    }
    for (var i in jsonN["data"]) {
      ndata.add(MangaBasic.fromJson(i));
    }
    return [tdata, ndata, sdata];
  } else {
    throw Exception(
        "Error Code : ${responses[0].statusCode}/${responses[1].statusCode}");
  }
}

Future<List<MangaChapterData>> getChapters(String id, int limit, int offset,
    String orderc, String orderv, String lang) async {
  var url;
  if (lang == 'any') {
    url = Uri.https("api.mangadex.org", "/manga/$id/feed", {
      "limit": limit.toString(),
      "offset": offset.toString(),
      "order[volume]": orderv,
      "order[chapter]": orderc,
      "includes[]": "scanlation_group"
    });
  } else {
    url = Uri.https("api.mangadex.org", "/manga/$id/feed", {
      "limit": limit.toString(),
      "offset": offset.toString(),
      "order[volume]": orderv,
      "order[chapter]": orderc,
      "translatedLanguage[]": lang,
      "includes[]": "scanlation_group"
    });
  }
  var response = await https.get(url);
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    return (jsonResponse["data"] as List).map((e) {
      return MangaChapterData.fromJson(e);
    }).toList();
  } else {
    throw Exception("Can't Load Chapters!");
  }
}

Future<Map<String, Set<MangaBasic>>> expl(int off) async {
  int a = Random().nextInt(10000 - 200);
  int b = Random().nextInt(10000 - 200);
  b = (a == b) ? (a + 100) : (b);
  var url = Uri.http("api.mangadex.org", "/manga", {
    "limit": '100',
    "offset": a.toString(),
    "includes[]": ["author", "artist", "cover_art"],
  });
  var urla = Uri.http("api.mangadex.org", "/manga", {
    "limit": '100',
    "offset": b.toString(),
    "includes[]": ["author", "artist", "cover_art"],
  });
  var response = await Future.wait([https.get(url), https.get(urla)]);
  if (response[0].statusCode == 200 && response[1].statusCode == 200) {
    var jsona = jsonDecode(response[0].body);
    var jsonb = jsonDecode(response[1].body);
    Map<String, Set<MangaBasic>> maind = {};
    for (var i in jsona["data"]) {
      var e = MangaBasic.fromJson(i);
      for (var j in e.genrei) {
        if (maind[j] != null) {
          maind[j]!.add(e);
        } else {
          maind[j] = {e};
        }
      }
    }
    for (var i in jsonb["data"]) {
      var e = MangaBasic.fromJson(i);
      for (var j in e.genrei) {
        if (maind[j] != null)
          maind[j]!.add(e);
        else
          maind[j] = {e};
      }
    }
    return maind;
  } else {
    throw Exception("Error!");
  }
}

Future<String> follow(String id, String token, String refresh) async {
  var url = Uri.https("api.mangadex.org", "/manga/$id/follow");
  var response = await https
      .post(url, headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
  if (response.statusCode == 200) {
    return "OK";
  } else if (globals.prefs.getBool("login") == true) {
    var newt = await refresht(refresh);
    globals.prefs.setString("session", newt["session"]);
    globals.prefs.setString("refresh", newt["refresh"]);
    return await follow(id, newt["session"], newt["refresh"]);
  } else {
    throw Exception("Error Code : ${response.statusCode}");
  }
}

Future<Map<String, dynamic>> login(var username, var password) async {
  var url = Uri.https("api.mangadex.org", "auth/login");
  var response = await https.post(url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode({
        "username": username,
        "password": password,
      }));
  if (response.statusCode == 200) {
    var jsonR = json.decode(response.body);
    return jsonR["token"];
  } else {
    throw Exception("Error code : ${response.statusCode}");
  }
}

Future<bool> logout(var token) async {
  var url = Uri.https("api.mangadex.org", "auth/logout");
  var response = await https
      .post(url, headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception("Error code : ${response.statusCode}");
  }
}

Future<Map<String, dynamic>> refresht(var token) async {
  var url = Uri.https("api.mangadex.org", "/auth/refresh");
  var response = await https.post(url,
      headers: {HttpHeaders.contentTypeHeader: "application/json"},
      body: jsonEncode({"token": token}));
  if (response.statusCode == 200) {
    var jsonR = json.decode(response.body);
    return jsonR["token"];
  } else {
    throw Exception("Error code : ${response.statusCode}");
  }
}

Future<Map<String, dynamic>> getalls(String token, String refresh) async {
  var url = Uri.https("api.mangadex.org", "/manga/status");
  var response = await https
      .get(url, headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
  if (response.statusCode == 200) {
    return jsonDecode(response.body)["statuses"];
  } else if (globals.prefs.getBool("login") == true) {
    var newt = await refresht(refresh);
    globals.prefs.setString("session", newt["session"]);
    globals.prefs.setString("refresh", newt["refresh"]);
    return await getalls(newt["session"], newt["refresh"]);
  } else {
    throw Exception("Error Code : ${response.statusCode}");
  }
}

Future<String> following(String id, token, refresh) async {
  var url = Uri.https("api.mangadex.org", "user/follows/manga/$id");
  var response = await https
      .get(url, headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
  if (response.statusCode == 200) {
    return "OK";
  } else if (response.statusCode == 404) {
    return "Error";
  } else if (response.statusCode == 401) {
    var newt = await refresht(refresh);
    globals.prefs.setString("session", newt["session"]);
    globals.prefs.setString("refresh", newt["refresh"]);
    return await following(id, newt["session"], newt["refresh"]);
  } else {
    throw Exception("ERROR!");
  }
}

Future<String> unfollow(String id, token, refresh) async {
  var url = Uri.https("api.mangadex.org", "/manga/$id/follow");
  var response = await https
      .delete(url, headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
  if (response.statusCode == 200) {
    return "OK";
  } else if (globals.prefs.getBool("login") == true) {
    var newt = await refresht(refresh);
    globals.prefs.setString("session", newt["session"]);
    globals.prefs.setString("refresh", newt["refresh"]);
    return await follow(id, newt["session"], newt["refresh"]);
  } else {
    throw Exception("Error Code : ${response.statusCode}");
  }
}

Future<String> upst(String id, status, token, refresh) async {
  var url = Uri.https("api.mangadex.org", "/manga/$id/status");
  var response = await https.post(url,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
        HttpHeaders.contentTypeHeader: "application/json"
      },
      body: jsonEncode({"status": (status == "none") ? (null) : (status)}));
  if (response.statusCode == 200) {
    return "OK";
  } else if (response.statusCode == 401) {
    var newt = await refresht(refresh);
    globals.prefs.setString("session", newt["session"]);
    globals.prefs.setString("refresh", newt["refresh"]);
    return await follow(id, newt["session"], newt["refresh"]);
  } else {
    throw Exception("Error Code : ${response.statusCode}");
  }
}
