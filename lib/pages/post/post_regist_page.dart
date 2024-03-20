import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tipsy_mobile/classes/styles.dart';
import 'package:tipsy_mobile/classes/util.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io;

import '../../classes/param/post_param.dart';
import '../../requests/post.dart';
import '../../ui/tipsy_loading_indicator.dart';
import '../cocktail/select_ingd_type_page.dart';
import 'package:tipsy_mobile/classes/util.dart';
import 'package:tipsy_mobile/classes/ui_util.dart';

class PostRegistPage extends StatefulWidget {
  const PostRegistPage({Key? key}) : super(key: key);

  @override
  _PostRegistPageState createState() => _PostRegistPageState();
}

class _PostRegistPageState extends State<PostRegistPage> {

  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final contentController = TextEditingController();

  bool _canSubmit = false;
  bool _isUploading = false;

  String _title = '';
  String _content = '';
  List<XFile> _images = [];
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black,
          iconSize: 25,
        ),
        titleSpacing: 3,
        title: Text(
          '새로운 피드',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontFamily: 'NanumBarunGothic'
          ),
        ),
        backgroundColor: Colors.white,
        //elevation: 0.1,
        actions: [],
      ),
      body: Stack(
        children: [
          makePostPage(context),
          if (_isUploading)
            TipsyLoadingIndicator(),
        ],
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.11,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 35.0),
          child: ElevatedButton(
            // onPressed: () async {
            //   posting();
            // },
            onPressed: _canSubmit ? () {
              if (_formKey.currentState!.validate() && !_isUploading) {
                _isUploading = true;
                _formKey.currentState!.save();
                posting();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('입력사항을 다시 확인해주세요.'), backgroundColor: Colors.redAccent,),
                );
              }
            } : null,
            child: Text(
              '작성 완료',
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.white
              ),
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 16.0), // 가로 패딩 조절
              minimumSize: Size(double.infinity, 48.0), // 최소 크기를 설정하여 화면 가로를 꽉 채움
              backgroundColor: getPrimaryColor(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // 모서리를 0으로 설정하여 직사각형 모양으로 만듦
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget makePostPage(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black54, width: 1.5),
                            borderRadius: const BorderRadius.all(const Radius.circular(10.0))
                        ),
                        elevation: 0.0, // 그림자 깊이
                        child: InkWell(
                          onTap: () {
                            if(_images.length >= 5) {
                              dialogBuilder(context, '', '사진은 최대 5장까지 업로드 가능합니다.');
                            } else {
                              _pickImage();
                            }
                          },
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: MediaQuery.of(context).size.width * 0.2,
                            child: Center(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                          Icons.photo_camera,
                                          size: 30
                                      ),
                                      Text(
                                          _images.length.toString() + '/5'
                                      )
                                    ]
                                )
                            ),
                          ),
                        ),
                      ),
                      ...makeImageItems(context),
                    ]
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "제목",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  TextFormField(
                    controller: titleController,
                    enabled: true,
                    style: TextStyle(
                        color: Colors.black87
                    ),
                    decoration: InputDecoration(
                      hintText:  '제목',
                      hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(width: 1, color: Color(0xff005766)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(width: 1, color: Colors.redAccent),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "내용",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: TextFormField(
                      controller: contentController,
                      enabled: true,
                      maxLines: 20,
                      minLines: 15,
                      style: TextStyle(
                          color: Colors.black87
                      ),
                      decoration: InputDecoration(
                        //labelText: '내용',
                        // labelStyle: TextStyle(
                        //     color: Colors.black87,
                        //     fontSize: 16
                        // ),
                        hintText:  '오늘은 어떤 술을 마셨나요?',
                        hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(width: 1, color: Color(0xff005766)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(width: 1, color: Colors.redAccent),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              // Column(
              //   children: [
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       children: [
              //         Text(
              //           "태그",
              //           style: TextStyle(
              //               color: Colors.black,
              //               fontSize: 16
              //           ),
              //         ),
              //         GFButton(
              //           onPressed: (){
              //             //_navigateAndDisplaySelection(context);
              //           },
              //           text: "태그 추가",
              //           shape: GFButtonShape.square,
              //         ),
              //       ],
              //     ),
              //     // TODO: Add Tag Button
              //
              //     // TODO: Add horizontal list view for added tags
              //
              //   ],
              // ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            ],
          ),
        )
      ),
    );
  }

  List<Widget> makeImageItems(BuildContext context) {
    List<Widget> res = [];
    for(var i=0; i<_images.length; i++) {
      XFile xfile = _images[i];
      var image = Container(
        //padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Image.file(
            io.File(xfile.path),
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width * 0.19,
            height: MediaQuery.of(context).size.width * 0.19,
          ),
        ),
      );
      var imageStack = Stack(
        children: [
          image,
          Positioned(
            bottom: 55,
            right: 10,
            child: GestureDetector(
              onTap: () {
                removeImage(i);
              },
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  //color: Colors.grey[100],
                ),
                child: Icon(
                  Icons.cancel,
                  size: 25,
                  color: Colors.grey[100],
                ),
              ),
            )
            ,
          ),
        ],
      );
      res.add(imageStack);
      var sizedBox = SizedBox(width: MediaQuery.of(context).size.width * 0.01);
      res.add(sizedBox);
    }
    return res;
  }

  void removeImage(idx) {
    setState(() {
      _images.removeAt(idx);
    });
  }

  Future<void> _pickImage() async {
    ImagePicker().pickImage(source: ImageSource.gallery).then((image) {
      if (image != null) {
        setState(() {
          _images.add(image);
        });
      }
    });
  }

  void posting() async {
    setState(() {
      _isUploading = true;
    });
    await Future.delayed(Duration(seconds: 2));
    PostParam pParam = new PostParam();
    pParam.title = titleController.text;
    pParam.content = contentController.text;
    if(_images.length > 0) {
      pParam.images = _images;
    }
    bool isPosted = await requestPosting(pParam);
    if(isPosted) {
      dialogBuilder(context, '알림', '피드 업로드 완료.');
      Navigator.pop(context);
    } else {
      dialogBuilder(context, '알림', '피드 업로드 실패.');
    }
    setState(() {
      _isUploading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    titleController.addListener(validateForm);
    contentController.addListener(validateForm);
  }

  // 입력사항 확인
  // 모두 정상 입력 시 '작성 완료' 버튼 활성화
  void validateForm() {
    //log("validateForm");
    if (_formKey.currentState!.validate()) {
      //log("validate ok");
      setState(() {
        _canSubmit = true;
      });
    }
  }
}
