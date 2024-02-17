import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:tipsy_mobile/classes/liquor.dart';
import 'package:tipsy_mobile/classes/comment.dart';
import 'package:tipsy_mobile/classes/util.dart';
import 'package:tipsy_mobile/classes/ui_util.dart';
import 'package:tipsy_mobile/pages/collector/comment_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:getwidget/getwidget.dart';

class LiquorDetail extends StatefulWidget {
  const LiquorDetail({Key? key, required this.liquorId}) : super(key: key);

  final int liquorId;

  @override
  _LiquorDetailState createState() => _LiquorDetailState();
}

class _LiquorDetailState extends State<LiquorDetail> {

  late Future<Liquor> liquor;
  late Future<List<Comment>> commentList;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),
          onPressed: () { Navigator.pop(context);},
          color: Colors.black,
          iconSize: 25,
        ),
        titleSpacing: 3,
        title: Text(''),
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            child: IconButton(icon: Icon(Icons.bookmark_border),
              onPressed: () { Navigator.pop(context);},
              color: Colors.black,
              iconSize: 27,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
            child: IconButton(icon: Icon(Icons.share),
              onPressed: () { Navigator.pop(context);},
              color: Colors.black,
              iconSize: 27,
            ),
          )
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            children: [
              Row(
                children: [
                  FutureBuilder<Liquor>(
                    future: liquor,
                    builder: (context, snapshot) {
                      if(snapshot.hasData) {
                        return Column(
                          children: [
                            Container(  // image
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  makeImgWidget(context, snapshot.data!.repImgUrl, 300, MediaQuery.of(context).size.height * 0.3),
                                  // Image.network(
                                  //   makeImgUrl(snapshot.data!.repImg, 300),
                                  //   height: MediaQuery.of(context).size.height * 0.3,
                                  // ),
                                ],
                              ),
                            ),
                            Container( // title, rating, abv ...
                              padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
                              width: MediaQuery.of(context).size.width,
                              color: Colors.white,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Text(
                                          snapshot.data!.nameKr,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'NanumBarunGothicLight',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(6, 0, 6, 8),
                                        child: Text(
                                          snapshot.data!.nameEn,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey,
                                            fontFamily: 'NanumBarunGothicLight',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(6, 0, 6, 8),
                                        child: Text(
                                          "국가 | ",
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontFamily: 'NanumBarunGothicLight',
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(6, 0, 6, 8),
                                        child: Text(
                                          snapshot.data!.countryName,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontFamily: 'NanumBarunGothicLight',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(6, 0, 6, 8),
                                        child: Text(
                                          "도수 | ",
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontFamily: 'NanumBarunGothicLight',
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(6, 0, 6, 8),
                                        child: Text(
                                          snapshot.data!.abv.toString() + "%",
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontFamily: 'NanumBarunGothicLight',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(6, 0, 0, 8),
                                        child: Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                          size: 13,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(6, 0, 6, 8),
                                        child: Text(
                                          "평점 나오는 곳",
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontFamily: 'NanumBarunGothicLight',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Card(
                                        color: Color(0xff005766),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: const BorderRadius.all(const Radius.circular(10.0))
                                        ),
                                        elevation: 4.0, // 그림자 깊이
                                        child: InkWell(
                                          onTap: () {
                                            goToCocktailRegistPage(context);
                                          },
                                          child: SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.8,
                                            height: MediaQuery.of(context).size.height * 0.07,
                                            child: Center(child: Text('평가하기', style: boxMenuWhite)),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            BlankView(color: Colors.white, heightRatio: 0.05),

                            Container(  // description
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(15),
                              color: Colors.white,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        snapshot.data!.description.trim().length > 0 ? "Description" : "",
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                  snapshot.data!.description.trim().length > 0 ? CustomTextView(historyText: snapshot.data!.description) : BlankView(color: Colors.white, heightRatio: 0.05),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        snapshot.data!.history.trim().length > 0 ? "History" : "",
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                  snapshot.data!.history.trim().length > 0 ? CustomTextView(historyText: snapshot.data!.history) : BlankView(color: Colors.white, heightRatio: 0.05),
                                ],
                              ),
                            )
                          ],
                        );
                      } else if(snapshot.hasError) {
                        return Text('데이터를 불러오지 못했습니다.${snapshot.error}');
                      }
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: Center(
                            child: CircularProgressIndicator()
                        ),
                      );
                    }
                  ),
                ],
              ),
              // TODO: add comment preview view
              CommentPreView(commentList: commentList, contentId: widget.liquorId, contentType: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(height: 0.0),
    );
  }

  // request liquor get API
  Future<Liquor> loadLiquorInfo(int liquorId) async {
    print("#### [getLiquorInfo] ####" + liquorId.toString());
    String reqUrl = "/liquor.tipsy?liquorId=" + liquorId.toString();
    final response = await requestGET(reqUrl);

    if(response.statusCode == 200) {
      String resString = response.body.toString();
      var resJson = json.decode(resString);
      var liquorJson = resJson['data']['item'];

      Liquor tmp = Liquor.fromJson(liquorJson);

      print("[getLiquorInfo] desc:" + tmp.description);
      print("[getLiquorInfo] history:" + tmp.history);
      print("[getLiquorInfo] history lenth:" + tmp.history.length.toString());
      // TODO: null check
      if(tmp.description != null) {
        tmp.description = makeText(tmp.description);
      }

      if(tmp.history != null) {
        tmp.history = makeText(tmp.history);
      }

      return tmp;
    } else {
      throw Exception('Failed to load liquor data.');
    }
  }


  // request comments of liquor get API
  Future<List<Comment>> loadLiquorComment(int liquorId) async {
    return loadCommentInfo(liquorId, 100);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    print("주류 상세 페이지 - liquorId:" + widget.liquorId.toString());
    liquor = loadLiquorInfo(widget.liquorId);
    commentList = loadLiquorComment(widget.liquorId);
  }

}


// 동적 UI 생성
class CustomTextView extends StatefulWidget {
  const CustomTextView({Key? key, required this.historyText}) : super(key: key);

  final String historyText;

  @override
  _CustomTextViewState createState() => _CustomTextViewState();
}

class _CustomTextViewState extends State<CustomTextView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(
          widget.historyText,
          style: TextStyle(
              color: Colors.black54
          ),
        ),
      ),
    );
  }
}


/**
 * Comment UI
 */
class CommentPreView extends StatefulWidget {
  const CommentPreView({Key? key, required this.commentList, required this.contentId, required this.contentType}) : super(key: key);

  final commentList;
  final contentId;
  final contentType;


  @override
  _CommentPreViewState createState() => _CommentPreViewState();
}

class _CommentPreViewState extends State<CommentPreView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // TODO: 총 댓글 수 + 댓글 리스트 페이지 이동 버튼 추가
        Container(
          child: FutureBuilder<List<Comment>>(
            future: widget.commentList,
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                return Column(
                  children: [
                    Container(  // description
                      padding: EdgeInsets.all(0),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.42,
                      color: Colors.white,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Comments",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          BlankView(color: Colors.white, heightRatio: 0.03),
                          // TODO: ListView
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: CommentListView(commentList:snapshot.data),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.07,
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            color: Colors.white,
                            child: // TODO: 댓글 입력란 추가
                            // TextField(
                            //   keyboardType: TextInputType.multiline,
                            //   minLines: 1,
                            //   maxLines: null,
                            //   decoration: InputDecoration(
                            //     labelText: '댓글',
                            //     hintText: '댓글을 입력해주세요.',
                            //   ),
                            // ),
                            Row(
                              children: [
                                Flexible(
                                  child: TextField(
                                    keyboardType: TextInputType.multiline,
                                    minLines: 1,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      //labelText: '댓글',
                                      hintText: '댓글을 입력해주세요.',
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(),
                                    ),
                                    style: TextStyle(
                                      fontSize: 13
                                    ),
                                  )
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 1.0),
                                  child: IconButton(
                                      icon: Icon(Icons.send),
                                      onPressed: () => print("ayy")
                                  ),
                                ),
                              ],
                            )
                          ),
                        ],
                      ),
                    )
                  ],
                );
              } else if(snapshot.hasError) {
                return Text(
                  '데이터를 불러오지 못했습니다.${snapshot.error}',
                  style: TextStyle(
                      fontSize: 7
                  ),
                );
              }
              return Container(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Center(
                    child: CircularProgressIndicator()
                ),
              );
            }
            ),
        ),
      ],
    );
  }
}
