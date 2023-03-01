import 'dart:developer';
//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;
import 'package:tipsy_mobile/classes/recommand.dart';
import 'dart:convert';
import 'package:tipsy_mobile/classes/user.dart';
import 'package:tipsy_mobile/classes/ui_util.dart';
import 'package:tipsy_mobile/classes/word.dart';
import '../main.dart';
import 'comment.dart';

bool isLocal = true;
const String API_URL_LOCAL = "http://192.168.219.106:8080/svcmgr/api";
const String API_URL_SERVER = "http://www.tipsy.co.kr/svcmgr/api";


void setTestToken() async {
  final storage = new FlutterSecureStorage();
  await storage.write(key:'accessToken', value: 'AUTOmKFxUkmakDV9w8z/yLOxrbm0WwxgbNpsOS6HhoUAGNY=');
  await storage.write(key:'platform', value: '1');
  await storage.write(key:'id', value: '10');
  await storage.write(key:'email', value:'kimho2018@naver.com');
}

String makeText(String text) {
  StringBuffer sb = new StringBuffer();
  List textArr = text.split("\\n");
  for (String line in textArr) {
    line = line.trim();
    sb.write(line + "\n");
  }
  return sb.toString();
}

String getApiUrl() {
  return isLocal ? API_URL_LOCAL : API_URL_SERVER;
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




Future<http.Response> requestGET(path) async {

  // get access token
  final storage = new FlutterSecureStorage();
  String? accessToken = await storage.read(key: "accessToken");

  //log("[AccessToken]:"+accessToken!);

  String reqUrl = getApiUrl() + path;
  log("[Request GET URL]:" + reqUrl);
  final Uri url = Uri.parse(reqUrl);
  final response = await http.get(
    url,
    headers: <String, String> {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken!
    },
  );
  return response;
}

Future<http.Response> requestPOST(path, data) async {

  final storage = new FlutterSecureStorage();
  String? accessToken = await storage.read(key: "accessToken");

  String reqUrl = getApiUrl() + path;
  log("[Request POST URL]:" + reqUrl);
  final Uri url = Uri.parse(reqUrl);
  final response = await http.post(
    url,
    headers: <String, String> {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken!
    },
    body: json.encode(data),
  );
  return response;
}

// request access token
Future<AccessToken> requestAccessToken(int platform, String email) async {

  print("#### [requestAccessToken] ####");
  String reqUrl = "/user/issueToken.tipsy";
  var bodyData = {
    "platform": platform,
    "email": email
  };

  final response = await requestPOST(reqUrl, bodyData);

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
  String loginUrl = "/user/login.tipsy";
  var bodyData = {
    "platform": platform,
    "email": email,
    "access_token": accessToken
  };

  final response = await requestPOST(loginUrl, bodyData);

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


// request today word
Future<Word> requestTodayWord() async {

  print("#### [requestTodayWord] ####");
  final response = await requestGET("/word/random.tipsy");

  if (response.statusCode == 200) {
    String resString = response.body.toString();
    var parsed = json.decode(resString);
    var listData = parsed['list'];
    WordList wordList = new WordList.fromJson(listData);
    return wordList.words.first;
  } else {
    throw Exception('Failed get today word.');
  }
}

// request today recommand
Future<Recommand> requestTodayRecommand() async {

  print("#### [requestTodayRecommand] ####");
  final response = await requestGET("/recommand/today.tipsy");

  if (response.statusCode == 200) {
    String resString = response.body.toString();
    var parsed = json.decode(resString);
    var data = parsed['data'];
    Recommand recomm = new Recommand.fromJson(data);
    return recomm;
  } else {
    throw Exception('Failed get today recommand.');
  }
}

Future<List<Comment>> loadCommentInfo(int contentId, int contentType) async {
  print("#### [loadCommentInfo] ####" + contentId.toString());
  String reqUrl = "/comments.tipsy?contentId=" + contentId.toString()
                  + "&contentType=" + contentType.toString() + "&state=0&paging.perPage=3";
  final response = await requestGET(reqUrl);

  if(response.statusCode == 200) {
    String resString = response.body.toString();
    var resJson = json.decode(resString);
    var commentListJson = resJson['list'];

    List<Comment> tmp = [];
    try{
      tmp = CommentList.fromJson(commentListJson).comments;
    } catch(e) {
      log("" + e.toString());
    }

    return tmp;
  } else {
    throw Exception('Failed to load liquor comments data.');
  }
}

