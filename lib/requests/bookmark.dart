import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../classes/bookmark.dart';
import '../classes/comment.dart';
import '../classes/param/bookmark_param.dart';
import '../classes/param/comment_param.dart';
import '../classes/util.dart';

Future<Bookmark> requestBookmark(BookmarkParam bParam) async {
  print("#### [requestBookmark] ####" + bParam.toString());
  String reqUrl = "/bookmark.tipsy";

  final storage = new FlutterSecureStorage();
  String? userId = await storage.read(key: "userId");
  bParam.userId = int.parse(userId!);

  final response = await requestPOST(reqUrl, bParam.toJson());

  if(response.statusCode == 200) {
    String resString = response.body.toString();
    var resJson = json.decode(resString);
    var dataJson = resJson['data'];

    print(resJson);

    Bookmark bookmark = new Bookmark.fromJson(dataJson);
    return bookmark;
  } else {
    throw Exception('Failed to bookmark.');
  }
}

Future<bool> deleteBookmark(BookmarkParam bParam) async {
  print("#### [deleteBookmark] ####" + bParam.toString());
  String reqUrl = "/bookmark.tipsy";

  final storage = new FlutterSecureStorage();
  String? userId = await storage.read(key: "userId");

  bParam.userId = int.parse(userId!);

  final response = await requestDELETE(reqUrl, bParam.toJson());

  if(response.statusCode == 200) {
    String resString = response.body.toString();
    var resJson = json.decode(resString);
    var state = resJson['state'];
    print(state);
    return true;
  } else {
    throw Exception('Failed to unbookmark.');
  }
}