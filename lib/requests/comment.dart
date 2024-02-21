import 'dart:convert';

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