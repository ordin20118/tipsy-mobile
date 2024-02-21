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