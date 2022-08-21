import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tipsy_mobile/classes/user.dart';

bool isLocal = true;
const String API_URL_LOCAL = "http://192.168.0.45:8080/svcmgr/api";
const String API_URL_SERVER = "http://www.tipsy.co.kr/svcmgr/api";

void showToast(String message) {
  Fluttertoast.showToast(
    fontSize: 13,
    msg: '   $message   ',
    backgroundColor: Colors.black,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
  );
}

String makeImgUrl(String filePath, int size) {

  print(FlutterConfig.get('API_URL'));
  print(FlutterConfig.get('API_SUFFIX'));
  // String apiUrl = FlutterConfig.get('API_URL');
  // String apiSuffix = FlutterConfig.get('API_SUFFIX');
  // print(apiUrl + "/" + apiSuffix);

  List<String> pathArr = filePath.split("/");

  //return 'http://tipsy.co.kr/svcmgr/api/image/1.tipsy';
  //return apiUrl + "/image/" + filePath + "_" + size.toString() + ".png" + apiSuffix;
  return "http://tipsy.co.kr/svcmgr/api" + "/image/" + pathArr.last + ".tipsy?size=" + size.toString();
}



// request access token
Future<AccessToken> requestAccessToken(int platform, String email) async {

  print("#### [requestAccessToken] ####");
  String reqUrl = "";
  if(isLocal) {
    reqUrl = API_URL_LOCAL;
  } else {
    reqUrl = API_URL_SERVER;
  }
  reqUrl = reqUrl + "/user/issueToken.tipsy";

  log("[Request acess token URL]:" + reqUrl);

  final Uri url = Uri.parse(reqUrl);

  var bodyData = {
    "platform": platform,
    "email": email
  };

  http.Response response = await http.post(
    url,
    headers: <String, String> {
      'Content-Type': 'application/json',
    },
    body: json.encode(bodyData),
  );

  if (response.statusCode == 200) {

    String resString = response.body.toString();
    var parsed = json.decode(resString);
    var tokenObj = parsed['data'];

    AccessToken token = new AccessToken.fromJson(tokenObj);
    return token;

  } else {
    throw Exception('Failed issue login token.');
  }


}



// request auto login
Future<bool> autoLogin(int platform, String email, String accessToken) async {

  print("#### [autoLogin] ####");

  print(FlutterConfig.get('API_URL'));

  String loginUrl = "";
  if(isLocal) {
    loginUrl = API_URL_LOCAL;
  } else {
    loginUrl = API_URL_SERVER;
  }
  loginUrl = loginUrl + "/user/login.tipsy";

  log("[Auto login URL]:" + loginUrl);

  final Uri url = Uri.parse(loginUrl);

  print("URL: $url");

  var bodyData = {
    "platform": platform,
    "email": email,
    "access_token": accessToken
  };

  http.Response response = await http.post(
    url,
    headers: <String, String> {
      'Content-Type': 'application/json',
    },
    body: json.encode(bodyData),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception('Failed auto login.');
  }
}

