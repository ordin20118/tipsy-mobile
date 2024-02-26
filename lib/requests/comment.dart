import 'dart:convert';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../classes/comment.dart';
import '../classes/param/comment_param.dart';
import '../classes/util.dart';

Future<Comment> requestSendComment(CommentParam rParam) async {
  print("#### [sendComment] ####" + rParam.toString());
  String reqUrl = "/comment.tipsy";

  final storage = new FlutterSecureStorage();
  String? userId = await storage.read(key: "userId");

  rParam.userId = int.parse(userId!);

  final response = await requestPOST(reqUrl, rParam.toJson());

  if(response.statusCode == 200) {
    String resString = response.body.toString();
    var resJson = json.decode(resString);
    var dataJson = resJson['data'];

    print(resJson);

    Comment comment = new Comment.fromJson(dataJson);
    return comment;
  } else {
    throw Exception('Failed to send comment.');
  }
}


Future<List<Comment>> loadCommentInfo(int contentId, int contentType, int nowPage, int perPage) async {
  print("#### [loadCommentInfo] ####" + contentId.toString());
  String reqUrl = "/comments.tipsy?contentId=" + contentId.toString()
      + "&contentType=" + contentType.toString() + "&state=0&paging.nowPage=" + nowPage.toString() + "&paging.perPage=" + perPage.toString()
      + "&sort.field=reg_date&sort.sorting=desc";
  final response = await requestGET(reqUrl);

  if(response.statusCode == 200) {
    String resString = response.body.toString();
    var resJson = json.decode(resString);
    var commentListJson = resJson['data'];

    List<Comment> tmp = [];
    try{
      tmp = CommentList.fromJson(commentListJson).comments;
    } catch(e) {
      log("" + e.toString());
    }
    print("return comments");
    return tmp;
  } else {
    throw Exception('Failed to load liquor comments data.');
  }
}