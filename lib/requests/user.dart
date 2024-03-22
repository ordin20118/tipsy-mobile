import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../classes/user.dart';
import '../classes/util.dart';

Future<User> requestUserInfo() async {
  print("#### [requestUserInfo] ####");
  String reqUrl = "/user.tipsy";

  final response = await requestGET(reqUrl);

  if(response.statusCode == 200) {
    String resString = response.body.toString();
    var resJson = json.decode(resString);
    var dataJson = resJson['data'];
    print(resJson);

    User user = new User.fromJson(dataJson);
    return user;
  } else {
    throw Exception('Failed to get user info.');
  }
}

/**
 * 닉네임 중복 확인
 * return true: 중복
 * return false: 중복 아님
 */
Future<bool> requestNicknameDupChck(String nickname) async {
  print("#### [requestNicknameDupChck] ####" + nickname);
  String reqUrl = "/user/has_dup_nickname.tipsy";

  var bodyData = {
    "nickname": nickname
  };

  final response = await requestPOST(reqUrl, bodyData);

  if(response.statusCode == 200) {
    String resString = response.body.toString();
    var resJson = json.decode(resString);
    var isDuplication = resJson['state'];
    if(isDuplication == 0) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
    //throw Excepation('Failed to send comment.');
  }
}