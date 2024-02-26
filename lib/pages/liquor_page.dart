import 'package:flutter/material.dart';
import 'package:tipsy_mobile/classes/liquor.dart';
import 'package:tipsy_mobile/classes/comment.dart';
import 'package:tipsy_mobile/classes/util.dart';
import 'package:tipsy_mobile/classes/ui_util.dart';
import 'package:tipsy_mobile/pages/collector/comment_view.dart';
import 'package:tipsy_mobile/pages/rating/rating_page.dart';
import 'dart:convert';

import '../classes/bookmark.dart';
import '../classes/param/bookmark_param.dart';
import '../requests/bookmark.dart';
import '../requests/comment.dart';
import '../ui/tipsy_loading_indicator.dart';

class LiquorDetail extends StatefulWidget {
  const LiquorDetail({Key? key, required this.liquorId}) : super(key: key);

  final int liquorId;

  @override
  _LiquorDetailState createState() => _LiquorDetailState();
}

class _LiquorDetailState extends State<LiquorDetail> {

  FocusNode _focusNode = FocusNode();
  TextEditingController _commentInputController = TextEditingController();
  late Future<Liquor> liquor;

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
          FutureBuilder<Liquor>(
            future: liquor,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  child: IconButton(icon: getBookmarkIcon(snapshot.data!.bookmark),
                    onPressed: () async {
                      //Navigator.pop(context);
                      // 북마크
                      BookmarkParam bParam = BookmarkParam();
                      bParam.contentId = snapshot.data!.liquorId;
                      bParam.contentType = 100;

                      if(snapshot.data!.bookmark) {
                        Future<bool> bookmarkFuture = deleteBookmark(bParam);
                        bool isDeleted = await bookmarkFuture;
                        if(isDeleted != null && isDeleted) {
                          setState(() {
                            snapshot.data!.bookmark = false;
                          });
                        } else {
                          dialogBuilder(context, "알림", "북마크 제거에 실패했습니다.\n나중에 다시 시도해주세요.");
                        }
                      } else {
                        Future<Bookmark> bookmarkFuture = requestBookmark(bParam);
                        Bookmark bookmark = await bookmarkFuture;
                        if(bookmark != null) {
                          setState(() {
                            snapshot.data!.bookmark = true;
                          });
                        } else {
                          dialogBuilder(context, "알림", "북마크에 실패했습니다.\n나중에 다시 시도해주세요.");
                        }
                      }
                    },
                    color: Colors.black,
                    iconSize: 27,
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  child: IconButton(icon: Icon(Icons.bookmark_border),
                    onPressed: () { Navigator.pop(context);},
                    color: Colors.black,
                    iconSize: 27,
                  ),
                );
              }
            }
          ),
          // TODO: 공유하기 기능 구현 필요
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
          //   child: IconButton(icon: Icon(Icons.share),
          //     onPressed: () { Navigator.pop(context);},
          //     color: Colors.black,
          //     iconSize: 27,
          //   ),
          // )
        ],
      ),
      body: Container(
        color: Color(0x33eaeaea),
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
                                ],
                              ),
                            ),
                            BlankView(color: Color(0x33eaeaea), heightRatio: 0.02),
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
                                          "분류 | ",
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontFamily: 'NanumBarunGothicLight',
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(6, 0, 6, 8),
                                        child: Text(
                                          getLastCategName(snapshot.data!),
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
                                  // rating avg
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
                                          snapshot.data!.ratingAvg.toString(),
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontFamily: 'NanumBarunGothicLight',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  makeRateBtnWidget(snapshot.data!),
                                ],
                              ),
                            ),
                            BlankView(color: Colors.white, heightRatio: 0.02),
                            BlankView(color: Color(0x33eaeaea), heightRatio: 0.02),
                            BlankView(color: Colors.white, heightRatio: 0.02),
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
                            child: TipsyLoadingIndicator()
                        ),
                      );
                    }
                  ),
                ],
              ),
              BlankView(color: Color(0x33eaeaea), heightRatio: 0.02),
              // Comments
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: FutureBuilder<Liquor>(
                    future: liquor,
                    builder: (context, snapshot) {
                      if(snapshot.hasData) {
                        return GestureDetector(
                          onTap: () {
                            showCommentModal(context, _focusNode, _commentInputController, widget.liquorId, 100);
                          },
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "댓글",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    "댓글 " + snapshot.data!.commentCnt.toString() + "개 >",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "댓글",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  "댓글 0개 >",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                    }
                  ),
                ),
              ),
              // TODO: add comment preview view
              CommentPreView(
                  contentId: widget.liquorId,
                  contentType: 100
              ),
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


  Widget makeRateBtnWidget(Liquor liquor) {
    if(liquor.rate) {
      return Container();
    } else {
      return Row(
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
                //dialogBuilder(context, "알림", "평가하기는 아직 준비중입니다.");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RatingPage(contentId: liquor.liquorId,
                      contentType: 100,
                      categoryName: makeCategString(liquor),
                      contentName: liquor.nameKr,
                      imageUrl: liquor.repImgUrl
                  )),
                );
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.07,
                child: Center(child: Text('평가하기', style: boxMenuWhite)),
              ),
            ),
          )
        ],
      );
    }
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
  const CommentPreView({Key? key, required this.contentId, required this.contentType}) : super(key: key);

  final contentId;
  final contentType;

  @override
  _CommentPreViewState createState() => _CommentPreViewState();
}

class _CommentPreViewState extends State<CommentPreView> {

  FocusNode _focusNode = FocusNode();
  TextEditingController _commentInputController = TextEditingController();

  late Future<List<Comment>> commentList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: FutureBuilder<List<Comment>>(
            future: commentList,
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      width: MediaQuery.of(context).size.width,
                      //height: MediaQuery.of(context).size.height * 0.42,
                      color: Colors.white,
                      child: Column(
                        children: [
                          // Comment ListView
                          printCommentListView(context, snapshot.data!),
                          BlankView(color: Colors.white, heightRatio: 0.01),
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
              } else {
                return Container();
              }
            }
          ),
        ),
      ],
    );
  }

  Widget printCommentListView(BuildContext context, List<Comment> commentList) {
    if(commentList.length > 0) {
      return Padding(
        padding: const EdgeInsets.all(0.0),
        child: CommentListView(commentList: commentList, commentScrollController: null,),
      );
    } else {
      return Container(
        height: MediaQuery.of(context).size.height * 0.2,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '아직 댓글이 없어요.\n첫 댓글을 작성해 보시겠어요?',
                textAlign: TextAlign.center,
              ),
              TextButton(
                onPressed: () {
                  showCommentModal(context, _focusNode, _commentInputController, widget.contentId, widget.contentType);
                },
                child: Text(
                  '댓글 쓰기 >',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                )
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    print("주류 상세 댓글 페이지 - liquorId:" + widget.contentId.toString());
    commentList = loadCommentInfo(widget.contentId, widget.contentType, 1, 3);
  }

  @override
  void dispose() {
    _commentInputController.dispose();
    super.dispose();
  }

}
