import 'dart:convert';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../classes/bookmark.dart';
import '../classes/comment.dart';
import '../classes/param/bookmark_param.dart';
import '../classes/param/comment_param.dart';
import '../classes/param/rating_param.dart';
import '../classes/util.dart';

Future<bool> requestRating(RatingParam rParam) async {
  log("#### [requestRating] ####" + rParam.toString());
  String reqUrl = "/rating.tipsy";

  final storage = new FlutterSecureStorage();
  String? userId = await storage.read(key: "userId");
  rParam.userId = int.parse(userId!);

  final response = await requestPOST(reqUrl, rParam.toJson());

  if(response.statusCode == 200) {
    String resString = response.body.toString();
    var resJson = json.decode(resString);
    return true;
  } else {
    throw Exception('Failed to Rating.');
  }
}

// Future<bool> deleteBookmark(BookmarkParam bParam) async {
//   print("#### [deleteBookmark] ####" + bParam.toString());
//   String reqUrl = "/bookmark.tipsy";
//
//   final storage = new FlutterSecureStorage();
//   String? userId = await storage.read(key: "userId");
//
//   bParam.userId = int.parse(userId!);
//
//   final response = await requestDELETE(reqUrl, bParam.toJson());
//
//   if(response.statusCode == 200) {
//     String resString = response.body.toString();
//     var resJson = json.decode(resString);
//     var state = resJson['state'];
//     print(state);
//     return true;
//   } else {
//     throw Exception('Failed to unbookmark.');
//   }
// }