import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tipsy_mobile/classes/user.dart';
import 'package:tipsy_mobile/classes/ui_util.dart';
import '../main.dart';

bool isLocal = true;
const String API_URL_LOCAL = "http://192.168.0.13:8080/svcmgr/api";
const String API_URL_SERVER = "http://www.tipsy.co.kr/svcmgr/api";

void setTestToken() async {
  final storage = new FlutterSecureStorage();
  await storage.write(key:'accessToken', value: 'AUTOmKFxUkmakDV9w8z/yLOxrbm0WwxgbNpsOS6HhoUAGNY=');
  await storage.write(key:'platform', value: '1');
  await storage.write(key:'id', value: '10');
  await storage.write(key:'email', value:'kimho2018@naver.com');
}

String getApiUrl() {
  return isLocal ? API_URL_LOCAL : API_URL_SERVER;
}

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

  //print(FlutterConfig.get('API_URL'));
  //print(FlutterConfig.get('API_SUFFIX'));
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
  String reqUrl = getApiUrl() + "/user/issueToken.tipsy";
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
    log("[REQ AccessToken RES]:" + resString);
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

  String loginUrl = getApiUrl() + "/user/login.tipsy";
  log("[Auto login URL]:" + loginUrl);
  final Uri url = Uri.parse(loginUrl);

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

    String bodyString = response.body.toString();

    log("[AutoLogin RES]:" + bodyString);

    var res = json.decode(bodyString);
    var stateCode = res['state'];
    if(stateCode == 0) {
      var data = res['data'];
      if(data != null) {
        AccessToken token = new AccessToken.fromJson(data);
        final storage = new FlutterSecureStorage();
        await storage.write(key:'accessToken', value:token.tokenHash);
        await storage.write(key:'platform', value:platform.toString());
        await storage.write(key:'id', value:token.userId.toString());
        await storage.write(key:'email', value:email);
      }
      return true;
    } else {
      return false;
    }
  } else {
    throw Exception('Failed auto login.');
  }
}

