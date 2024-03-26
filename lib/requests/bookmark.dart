import 'dart:convert';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../classes/bookmark.dart';
import '../classes/comment.dart';
import '../classes/my_bookmark.dart';
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


Future<List<MyBookmark>> requestMyBookmark(nowPage) async {
  log("#### [requestMyBookmark] ####");
  String reqUrl = "/bookmark/my/bookmarks.tipsy?paging.perPage=5&paging.nowPage=" + nowPage.toString();
  reqUrl += "&sort.field=bookmark_id&sort.sorting=desc";

  final response = await requestGET(reqUrl);

  if(response.statusCode == 200) {
    String resString = response.body.toString();
    var resJson = json.decode(resString);
    var dataJson = resJson['data'];
    MyBookmarkList myBookmarks = MyBookmarkList.fromJson(dataJson);
    return myBookmarks.bookmarks;
  } else {
    throw Exception('Failed to get my bookmarks.');
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
    return true;
  } else {
    throw Exception('Failed to unbookmark.');
  }
}