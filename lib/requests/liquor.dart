import 'dart:convert';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../classes/Liquor.dart';
import '../classes/bookmark.dart';
import '../classes/comment.dart';
import '../classes/my_bookmark.dart';
import '../classes/param/bookmark_param.dart';
import '../classes/param/comment_param.dart';
import '../classes/util.dart';

Future<List<Liquor>> requestLastViewLiquors(nowPage) async {
  log("#### [requestLastViewLiquors] ####");
  String reqUrl = "/liquor/lastViewLiquors.tipsy?paging.perPage=7&paging.nowPage=" + nowPage.toString();

  final response = await requestGET(reqUrl);

  if(response.statusCode == 200) {
    String resString = response.body.toString();
    var resJson = json.decode(resString);
    var dataJson = resJson['data'];
    LiquorList liquorList = LiquorList.fromJson(dataJson);
    return liquorList.liquors;
  } else {
    throw Exception('Failed to get last view liquors.');
  }
}
