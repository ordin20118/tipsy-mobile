import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tipsy_mobile/classes/util.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'dart:convert';


import '../classes/styles.dart';


class CameraPage extends StatefulWidget {
  const CameraPage({Key? key, required this.camera,}) : super(key: key);

  final CameraDescription camera;

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {

  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // 카메라의 현재 출력물을 보여주기 위해
    // CameraController를 생성
    _controller = CameraController(
      widget.camera,            // 이용 가능한 카메라 목록에서 특정 카메라를 선택
      ResolutionPreset.veryHigh,  // 해상도 지정
    );

    _initializeControllerFuture = _controller.initialize(); // controller 초기화
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // Future가 완료되면, 프리뷰를 보여줍니다.
                  return CameraPreview(_controller);
                } else {
                  // Otherwise, display a loading indicator.
                  // 그렇지 않다면, 진행 표시기를 보여줍니다.
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  heroTag: 'cancel',
                  backgroundColor: Colors.redAccent,
                  child: Icon(Icons.close),
                  onPressed: () async {
                    if (!mounted) return;
                    Navigator.pop(context);
                  },
                ),
                FloatingActionButton(
                  heroTag: 'pick',
                  backgroundColor: Color(0xff005766),
                  child: Icon(Icons.camera_alt),
                  onPressed: () async {
                    // try / catch 블럭에서 사진을 촬영합니다.
                    // 만약 뭔가 잘못된다면 에러에 대응할 수 있습니다.
                    try {
                      // 카메라 초기화가 완료됐는지 확인합니다.
                      await _initializeControllerFuture;

                      // 사진 촬영을 시도하고 저장되는 경로를 로그로 남깁니다.
                      final image = await _controller.takePicture();

                      if (!mounted) return;

                      // 사진을 촬영하면, 새로운 화면으로 넘어갑니다.
                      await Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => DisplayPictureScreen(
                                imagePath: image.path,
                              )
                          )
                      );

                    } catch (e) {
                      // 만약 에러가 발생하면, 콘솔에 에러 로그를 남깁니다.
                      print(e);
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class DisplayPictureScreen extends StatefulWidget {
  const DisplayPictureScreen({Key? key, required this.imagePath}) : super(key: key);

  final String imagePath;

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('촬영 결과'),),
      body: Image.file(File(widget.imagePath)),
    );
  }


  @override
  void dispose() {
    File imgFile = File(widget.imagePath);
    imgFile.delete();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    File imgFile = File(widget.imagePath);
    Future<dynamic> ocrRes = reqOcr();
    log(ocrRes.toString());
  }

  Future<dynamic> reqOcr() async {
    log("[[ OCR 분석을 위한 이미지 파일 전송 시작 ]]");

    // 이미지 전송
    var formData = FormData.fromMap({'multipartFile': await MultipartFile.fromFile(widget.imagePath)});
    // 분석 결과 state로 저장
    var dio = new Dio();
    try{

      dio.options.contentType = 'multipart/form-data';
      dio.options.maxRedirects.isFinite;

      //dio.options.headers = {'token', token};
      var response = await dio.post(
        'http://192.168.219.101:8080/svcmgr/api/test/ocr/file.tipsy',
        data: formData,
      );

      log("[[ OCR 분석 완료 ]]");
      log(response.data.toString());
      return response.data;
    } catch(e) {
      log(e.toString());
    }

    // build에서는 FutureBuilder로 결과 보여줌
    // 사용자에게 나의 셀러에 등록 여부 확인

  }
}


