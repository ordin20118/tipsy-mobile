import 'dart:developer';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:tipsy_mobile/classes/util.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../classes/ui_util.dart';
import '../classes/styles.dart';
import '../classes/user.dart';
import '../requests/user.dart';
import '../ui/tipsy_loading_indicator.dart';
import '../ui/tipsy_refresh_indicator.dart';


class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {

  late Future<User> user;

  @override
  Widget build(BuildContext context) {
    // TODO: custom refresh indicator
    // return CustomRefreshIndicator(
    //   onRefresh: _refreshData,
    //   builder: (BuildContext context, Widget child, IndicatorController controller) {
    //     return CheckMarkIndicator(
    //       child: buildMyPage(context),
    //     );
    //   },
    //   child: buildMyPage(context),
    // );
    return RefreshIndicator(
        onRefresh: _refreshData,
        child: buildMyPage(context),
    );
  }

  Widget buildMyPage(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        color: getCommonBackColor(),
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            BlankView(color: Colors.white, heightRatio: 0.03),
            Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height * 0.2,
              child: Center(
                child: FutureBuilder(
                  future: user,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // 데이터 로딩 중 => TODO: 빈 UI로 변경
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      // 에러 발생
                      return Text(
                        '내 정보를 불러오지 못했습니다.\n앱을 다시 실행해주세요.$snapshot.error',
                        textAlign: TextAlign.center,
                      );
                    } else {
                      // 데이터 성공적으로 가져옴
                      return Column(
                        children: [
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.015
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: Image.asset(
                              'assets/images/default_profile.jpeg',
                              //'assets/images/loading_icon.gif',
                              height: MediaQuery.of(context).size.height * 0.1,
                            ),
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.015
                          ),
                          Text(
                            snapshot.data!.nickname,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
            Divider(
              height: 0.1,
              color: Colors.grey,
              thickness: 0.1,
            ),
            Container(
                width: MediaQuery.of(context).size.width * 1.0,
                height: MediaQuery.of(context).size.height * 0.11,
                child: FutureBuilder(
                  future: user,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting || snapshot.hasError) {
                      return buildMyPageCenterMenu(context, 0, 0, 0);
                    } else {
                      // 데이터 성공적으로 가져옴
                      return buildMyPageCenterMenu(context, 0, snapshot.data!.bookmarkCnt, snapshot.data!.commentCnt);
                    }
                  },
                )
              //child: buildMyPageCenterMenu(context),
            ),
            Divider(
              height: 0.1,
              color: Colors.grey,
              thickness: 0.1,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(13, 10, 13, 0),
                child: Card(
                  color: Color(0xffC98AFF),
                  shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(const Radius.circular(10.0))
                  ),
                  elevation: 4.0, // 그림자 깊이
                  child: InkWell(
                    onTap: () {
                      goToCocktailRegistPage(context);
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: MediaQuery.of(context).size.height * 0.08,
                      child: Center(child: Text('나만의 칵테일 등록하기', style: boxMenuWhite)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 마이페이지의 중간 메뉴 만들기
  Widget buildMyPageCenterMenu(BuildContext context, int ratingCnt, int bookmarkCnt, int commentCnt) {
    return Container(
      color: Colors.white60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Image.asset(
                  //   'assets/images/default_profile.jpeg',
                  //   height: MediaQuery.of(context).size.height * 0.05,
                  // ),
                  Text(
                    ratingCnt.toString(),
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "평가",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 13,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          VerticalDivider(
            width: 1,  // 구분선의 높이 조절
            thickness: 2, // 구분선의 두께 조절
            color: Color(0x33BDBDBD), // 구분선의 색상 설정
            indent: 20, // 시작 부분에서의 여백 조절
            endIndent: 20, // 끝 부분에서의 여백 조절
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    bookmarkCnt.toString(),
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "북마크",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 13,
                    ),
                  )
                ],
              ),
            ),
          ),
          VerticalDivider(
            width: 1,
            thickness: 2,
            color: Color(0x33BDBDBD),
            indent: 20,
            endIndent: 20,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    commentCnt.toString(),
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "댓글",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 13,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildLastViewLiquor(BuildContext context) {
    return Container(
      child: Container(),
    );
  }

  Future<void> _refreshData() async {
    setState(() {
      user = requestUserInfo();
    });
  }

  @override
  void initState() {
    super.initState();
    log("my page initState()");
    user = requestUserInfo();
  }

}

