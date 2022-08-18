import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_config/flutter_config.dart';

const USER_NICK_NAME = 'USER_NICK_NAME';
const STATUS_LOGIN = 'STATUS_LOGIN';
const STATUS_LOGOUT = 'STATUS_LOGOUT';

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
  // String apiUrl = FlutterConfig.get('API_URL');
  // String apiSuffix = FlutterConfig.get('API_SUFFIX');
  // print(apiUrl + "/" + apiSuffix);

  List<String> pathArr = filePath.split("/");

  //return 'http://tipsy.co.kr/svcmgr/api/image/1.tipsy';
  //return apiUrl + "/image/" + filePath + "_" + size.toString() + ".png" + apiSuffix;
  return "http://tipsy.co.kr/svcmgr/api" + "/image/" + pathArr.last + ".tipsy?size=" + size.toString();

}
