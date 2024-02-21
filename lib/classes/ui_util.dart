import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tipsy_mobile/classes/param/comment_param.dart';

import '../main.dart';
import '../classes/util.dart';
import '../pages/camera_page.dart';
import '../pages/cocktail/cocktail_regist_page.dart';
import '../pages/liquor_page.dart';
import '../pages/login_page.dart';
import '../pages/join_page.dart';
import '../pages/recommand/recommand_page.dart';
import '../requests/comment.dart';

const List<String> cocktailColors = [
  "#FFFAED7D",
  "#FF584B00",
  "#FFFF0000",
  "#FFFF5E00",
  "#FF662500",
  "#FFF6F6F8",
  "#FF86E57F",
  "#FF2F9D27",
  "#FFFFE400",
  "#FF1E0000",
  "#FF008299",
  "#FFFFB2D9",
  "#FFFAF4C0",
  "#FF80F2CA",
  "#FFDFE182",
];

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}


TextStyle boxMenuWhite = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold
);

TextStyle boxMenuPupple = TextStyle(
    color: Color(0xff8748E1),
    fontWeight: FontWeight.bold
);

List<Widget> makeStarUi(int count, double ratingAvg) {
  List<Widget> res = <Widget>[];
  for(int i=0; i<count; i++) {
    res.add(
        Icon(
          Icons.star,
          size: 18,
          color: Colors.yellow
        )
    );
  }

  res.add(SizedBox(
    width: 5,
  ));

  res.add(Text(
      ratingAvg.toString(),
      style: TextStyle(
        color: Colors.black45,
        fontWeight: FontWeight.bold,
      ),
  ));
  return res;
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

void goToLoginPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => LoginPage()),
  );
}

void goToLoginPageReplace(BuildContext context) {
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      builder: (BuildContext context) => LoginPage()), (route) => false);
}

void goToMainPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => MainPage()),
  );
}

void goToMainPageReplace(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => MainPage()),
  );
}

void goToRecommandPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => RecommandPage()),
  );
}

void goToCocktailRegistPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => CocktailRegistPage()),
  );
}

void goToLiquorDetailPage(BuildContext context, int liquorId) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => LiquorDetail(liquorId: liquorId)),
  );
}

// TODO: For Test
void goToJoinPage(BuildContext context) {
  // Navigator.push(
  //   context,
  //   MaterialPageRoute(builder: (context) => JoinPage(platform: 0, email: '', nickname: ''
  //                                                   ,accessToken: '', refreshToken: '',)),
  // );
}

// TODO
void goToCameraPage(BuildContext context) async {
  final cameras = await availableCameras();
  final firstCamer = cameras.first;
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => CameraPage(camera: firstCamer,)),
  );
}


Image makeImgWidget(context, String fileUrl, int size, height) {
  if(fileUrl.length == 0) {
    return Image.asset(
      'assets/images/default_image.png',
      height: height,
    );
  } else {
    return Image.network(
      fileUrl,
      height: height,
    );
  }
}


Future<void> dialogBuilder(BuildContext context, String title, String content) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(
          content
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('확인'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}


/**
 * 상태에 따른 북마크 아이콘 반환
 */
Widget getBookmarkIcon(bool isBookmark) {
  if(isBookmark) {
    return Icon(Icons.bookmark);
  } else {
    return Icon(Icons.bookmark_border);
  }
}

/**
 * 댓글 모달 띄우기
 */
// void showCommentModal(BuildContext context, TextEditingController commentInputController, int contentId, int contentType) {
//   showModalBottomSheet(
//       isScrollControlled: true,
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height * 0.6,
//           padding: EdgeInsets.only(
//             bottom: MediaQuery
//                 .of(context)
//                 .viewInsets
//                 .bottom,
//           ),
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20),   // 모달 좌상단 라운딩 처리
//               topRight: Radius.circular(20),  // 모달 우상단 라운딩 처리
//             ),
//           ),
//           child: Padding(
//               padding: const EdgeInsets.fromLTRB(0.0, 18.0, 0.0, 18.0),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   // Comment View Top
//                   Flexible(
//                     flex: 4,
//                     child: Padding(
//                       padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "댓글",
//                             style: TextStyle(
//                               fontSize: 20,
//                             ),
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               Navigator.of(context).pop();
//                             },
//                             child: Text(
//                               '닫기',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.redAccent,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Divider(
//                     height: 1,
//                     thickness: 0.5,
//                     color: Colors.grey,
//                   ),
//                   // TODO: Comments List View
//                   Flexible(
//                     flex: 10,
//                     child: Container(
//                       color: Colors.yellow,
//                     ),
//                   ),
//                   Divider(
//                     height: 1,
//                     thickness: 0.5,
//                     color: Colors.grey,
//                   ),
//                   // Comment Input
//                   Flexible(
//                     flex: 2,
//                     child: Container(
//                       constraints: BoxConstraints(
//                         minHeight: MediaQuery.of(context).size.height * 0.1,
//                       ),
//                       padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
//                       color: Colors.white,
//                       child: Padding(
//                         padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//                         child: Row(
//                           children: [
//                             Flexible(
//                                 flex: 9,
//                                 child: TextField(
//                                   controller: commentInputController,
//                                   keyboardType: TextInputType.multiline,
//                                   textInputAction: TextInputAction.newline,
//                                   maxLines: null,
//                                   decoration: InputDecoration(
//                                     hintText: '댓글을 입력해주세요.',
//                                     // border: OutlineInputBorder(),
//                                     // focusedBorder: OutlineInputBorder(),
//                                   ),
//                                   style: TextStyle(
//                                       fontSize: 14
//                                   ),
//                                 )
//                             ),
//                             Flexible(
//                               flex: 1,
//                               child: Container(
//                                 margin: const EdgeInsets.symmetric(horizontal: 1.0),
//                                 child: IconButton(
//                                     icon: Icon(Icons.send),
//                                     onPressed: () => sendComment(context, commentInputController.text, contentId, contentType) // TODO:
//                                 ),
//                               ),
//                             )
//                           ],
//                         ),
//                       )
//
//                     ),
//                   ),
//                 ],
//               )
//           ),
//         );
//       }
//   );
// }

void showCommentModal(BuildContext context, FocusNode focusNode, TextEditingController commentInputController, int contentId, int contentType) {
  showModalBottomSheet(
      //isScrollControlled: false,
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),   // 모달 좌상단 라운딩 처리
              topRight: Radius.circular(20),  // 모달 우상단 라운딩 처리
            ),
          ),
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar:  AppBar(
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("댓글", style: TextStyle(color: Color(0xff005766))),
                ],
              ),
              backgroundColor: Color(0xffffffff),
              actions: [],
              centerTitle: false,
              elevation: 0.1,
            ),
            body: Container(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  child: Column(
                    children: [
                      Divider(
                        height: 1,
                        thickness: 0.5,
                        color: Colors.grey,
                      ),
                      // TODO: Comments List View
                      Flexible(
                        flex: 10,
                        child: GestureDetector(
                          onTap: () {
                            if(focusNode.hasFocus){
                              focusNode.unfocus();
                            } else {
                              print("test");
                            }
                          },
                          child: Container(
                            color: Colors.yellow,
                          ),
                        ),
                      ),
                      Divider(
                        height: 1,
                        thickness: 0.5,
                        color: Colors.grey,
                      ),
                      // Comment Input
                      Flexible(
                        flex: focusNode.hasFocus ? 8 : 3,
                        child: Container(
                            constraints: BoxConstraints(
                              minHeight: MediaQuery.of(context).size.height * 0.5,
                            ),
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                            color: Colors.white,
                            child: Row(
                              children: [
                                // comment input field
                                Flexible(
                                    flex: 9,
                                    child: TextField(
                                      focusNode: focusNode,
                                      controller: commentInputController,
                                      keyboardType: TextInputType.multiline,
                                      textInputAction: TextInputAction.newline,
                                      maxLines: null,
                                      decoration: InputDecoration(
                                        hintText: '댓글을 입력해주세요.',
                                        // border: OutlineInputBorder(),
                                        // focusedBorder: OutlineInputBorder(),
                                      ),
                                      style: TextStyle(
                                        fontSize: 14,
                                        backgroundColor: Colors.white
                                      ),
                                    )
                                ),
                                // send button
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 1.0),
                                    child: IconButton(
                                      icon: Icon(Icons.send),
                                      onPressed: () {
                                        // TODO: bool 결과가 아닌 저장된 댓글 정보를 받아 리스트뷰에 추가해준다.
                                        bool isSaved = sendComment(context, commentInputController.text, contentId, contentType);
                                        if(isSaved) {
                                          focusNode.unfocus();
                                          commentInputController.text = "";
                                        } else {
                                          dialogBuilder(context, "알림", "댓글 작성에 실패했습니다.\n나중에 다시 시도해주세요.");
                                        }
                                      }
                                    ),
                                  ),
                                )
                              ],
                            )
                        ),
                      ),
                    ],
                  )
              ),
            ),
          )
        );
      }
  );
}

bool sendComment(BuildContext context, String? comment, int contentId, int contentType) {
  String? commentTxt = comment;
  if(commentTxt != null && commentTxt.length > 0) {
    CommentParam rParam = CommentParam();
    rParam.contentType = contentType;
    rParam.contentId = contentId;
    rParam.comment = commentTxt;
    print(rParam.toJson().toString());
    requestSendComment(rParam);
    return true;
  } else {
    dialogBuilder(context, "알림", "댓글을 입력해 주세요.");
    return false;
  }
}

/**
 * 공백 박스 만들기
 * Parameter
 * Color color: 박스의 배경이될 색상
 * Float heightRatio: 박스의 세로 비율(기기의 세로 * ratio을 설정해준다.)
 */
class BlankView extends StatefulWidget {
  const BlankView({Key? key, required Color this.color, required this.heightRatio}) : super(key: key);

  final Color color;
  final heightRatio;

  @override
  _BlankViewState createState() => _BlankViewState();
}

class _BlankViewState extends State<BlankView> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * widget.heightRatio,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: widget.color,
        ),
      ),
    );
  }
}

