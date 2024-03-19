import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get_connect/http/src/multipart/multipart_file.dart';
import 'package:mime/mime.dart';

import '../classes/param/post_param.dart';
import '../classes/post.dart';
import '../classes/util.dart';

Future<bool> requestPosting(PostParam pParam) async {
  log("#### [requestPosting] ####" + pParam.toString());
  String reqUrl = "/post.tipsy";

  final storage = new FlutterSecureStorage();
  String? accessToken = await storage.read(key: "accessToken");
  String? userId = await storage.read(key: "userId");
  pParam.userId = int.parse(userId!);

  try{
    String hostUrl = getAPIHost();
    var client = http.Client();
    var url = Uri.parse(hostUrl + '/post.tipsy');
    var request = http.MultipartRequest('POST', url);

    request.headers['Content-Type'] = 'multipart/form-data';
    request.headers['Accept'] = 'application/json';
    request.headers['Authorization'] = 'Bearer ' + accessToken!;

    request.fields['title'] = pParam.title!;
    request.fields['content'] = pParam.content!;
    request.fields['userId'] = pParam.userId.toString();

    // 파일 추가
    if(pParam.images != null) {
      for(var i=0; i<pParam.images!.length; i++) {
        File file = File(pParam.images![i].path);
        http.MultipartFile multipartFile = await http.MultipartFile.fromBytes(
          'images', // 필드 이름
          file.readAsBytesSync(), // 파일의 바이트 데이터
          filename: file.path.split('/').last, // 파일 이름
          contentType: MediaType.parse(lookupMimeType(file.path)!), // 컨텐츠 타입 설정 (이미지인 경우 image/jpeg 등)
        );
        request.files.add(await multipartFile);
        //request.files.add(await http.MultipartFile.fromPath('multipartFile', file.path));
      }
    }

    // 요청 보내기
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    log("result code:" + response.statusCode.toString());

    // 응답 확인
    var data = null;
    if (response.statusCode == 200) {
      log('게시물 작성 성공: ${response.body}');
      var parsed = json.decode(response.body);
      data = parsed['data'];
    } else {
      log('게시물 작성 실패: ${response.reasonPhrase}');
      return false;
      //throw Exception('Failed to Posting.');
    }
    client.close();
    return true;
  } catch(e) {
    log(e.toString());
    return false;
  }
}

// Future<bool> deleteBookmark(BookmarkParam bParam) async {
//   print("#### [deleteBookmark] ####" + bParam.toString());
//   String reqUrl = "/bookmark.tipsy";
//
//   final storage = new FlutterSecureStorage();
//   String? userId = await storage.read(key: "userId");
//
//   bParam.userId = int.parse(userId!);
//
//   final response = await requestDELETE(reqUrl, bParam.toJson());
//
//   if(response.statusCode == 200) {
//     String resString = response.body.toString();
//     var resJson = json.decode(resString);
//     var state = resJson['state'];
//     print(state);
//     return true;
//   } else {
//     throw Exception('Failed to unbookmark.');
//   }
// }