import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tipsy_mobile/classes/param/recommand_param.dart';
import 'package:tipsy_mobile/classes/recommand.dart';
import 'dart:convert';
import 'package:tipsy_mobile/classes/user.dart';
import 'package:tipsy_mobile/classes/word.dart';
import 'liquor.dart';

bool isLocal = true;
const String API_URL_LOCAL = "http://192.168.219.101:8080/svcmgr/api";
const String API_URL_SERVER = "https://www.tipsy.co.kr/svcmgr/api";

String getAPIHost() {
  String url = "";
  if(isLocal) {
    url = API_URL_LOCAL;
  } else {
    url = API_URL_SERVER;
  }
  return url;
}

void setTestToken() async {
  final storage = new FlutterSecureStorage();
  await storage.write(key:'accessToken', value: 'AUTOmKFxUkmakDV9w8z/yLOxrbm0WwxgbNpsOS6HhoUAGNY=');
  await storage.write(key:'platform', value: '1');
  await storage.write(key:'userId', value: '10');
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

String makeCategString(Liquor liquor) {
  String categString = "";

  if(liquor.category1Name != null) {
    categString += liquor.category1Name;
  }
  if(liquor.category2Name != null && liquor.category2Name.length > 0) {
    categString += " > " + liquor.category2Name;
  }
  if(liquor.category3Name != null && liquor.category3Name.length > 0) {
    categString += " > " + liquor.category3Name;
  }
  if(liquor.category4Name != null && liquor.category4Name.length > 0) {
    categString += " > " + liquor.category4Name;
  }

  return categString;
}

String getLastCategName(Liquor liquor) {
  String categString = "";

  if(liquor.category4Name != null && liquor.category4Name.length > 0) {
    return liquor.category4Name;
  }
  if(liquor.category3Name != null && liquor.category3Name.length > 0) {
    return liquor.category3Name;
  }
  if(liquor.category2Name != null && liquor.category2Name.length > 0) {
    return liquor.category2Name;
  }
  if(liquor.category1Name != null) {
    return liquor.category1Name;
  }

  return categString;
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
  if(accessToken == null) {
    accessToken = "";
  }

  String reqUrl = getApiUrl() + path;
  log("[Request POST URL]:" + reqUrl);
  final Uri url = Uri.parse(reqUrl);

  final response = await http.post(
    url,
    headers: <String, String> {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken
    },
    body: json.encode(data),
  );

  return response;
}

Future<http.Response> requestDELETE(path, data) async {

  final storage = new FlutterSecureStorage();
  String? accessToken = await storage.read(key: "accessToken");
  if(accessToken == null) {
    accessToken = "";
  }

  String reqUrl = getApiUrl() + path;
  log("[Request DELETE URL]:" + reqUrl);
  final Uri url = Uri.parse(reqUrl);

  final response = await http.delete(
    url,
    headers: <String, String> {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken
    },
    body: json.encode(data),
  );

  return response;
}

// request access token
Future<AccessToken> requestAccessToken(int platform, String email, String socialId) async {

  log("#### [requestAccessToken] ####");
  String reqUrl = "/user/issueToken.tipsy";
  var bodyData = {
    "platform": platform,
    "email": email,
    "social_id": socialId
  };

  log("[request access token] data:$bodyData");

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
        await storage.write(key:'userId', value:token.userId.toString());
        await storage.write(key:'email', value:email);
      }
      return true;
    } else {
      return false;
    }
  } else {
    return false;
    //throw Exception('Failed auto login.');
  }
}

Future<bool> logout(BuildContext context) async {
  print("#### [logout] ####");
  final storage = new FlutterSecureStorage();
  await storage.deleteAll();
  return true;
}


// request today word
Future<Word> requestTodayWord() async {
  print("#### [requestTodayWord] ####");
  final response = await requestGET("/word/random.tipsy");

  if (response.statusCode == 200) {
    String resString = response.body.toString();
    var parsed = json.decode(resString);
    var listData = parsed['data'];
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
    //print(data.toString());
    Recommand recomm = new Recommand.fromJson(data);
    return recomm;
  } else {
    throw Exception('Failed get today recommand.');
  }
}

Future<List<Liquor>> loadRecommandLiquors(RecommandParam rParam) async {
  print("#### [loadRecommandLiquors] ####" + rParam.toString());
  String reqUrl = "/recommand/liquor.tipsy?tipsy=true&";

  if(rParam.abvMin != rParam.abvMax) {
    reqUrl += "&abvMin=" + rParam.abvMin.toString() + "&abvMax=" + rParam.abvMax.toString();
  }

  if(rParam.priceMin != rParam.priceMax) {
    reqUrl += "&priceMin=" + rParam.priceMin.toString() + "&priceMax=" + rParam.priceMax.toString();
  }

  if(rParam.tastingNotes.length > 0) {
    reqUrl += "&tastingNotes=" + rParam.tastingNotes;
  }

  final response = await requestGET(reqUrl);

  if(response.statusCode == 200) {
    String resString = response.body.toString();
    var resJson = json.decode(resString);
    var dataJson = resJson['data'];
    Recommand recomm = new Recommand.fromJson(dataJson);
    return recomm.liquorList;
  } else {
    throw Exception('Failed to load recommand liquors.');
  }
}

