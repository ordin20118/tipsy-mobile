import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:tipsy_mobile/classes/util.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../classes/ui_util.dart';
import '../classes/styles.dart';


class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      color: Color(0x33eaeaea),
      child: SingleChildScrollView(
        child:Column(
          children: [
            Container(
              //width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.25,
              child: Center(
                child: FutureBuilder(
                  future: fetchUserData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // 데이터 로딩 중 => TODO: 빈 UI로 변경
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      // 에러 발생
                      return Text('내 정보를 불러오지 못했습니다.\n앱을 다시 실행해주세요.');
                    } else {
                      // 데이터 성공적으로 가져옴
                      return Column(
                        children: [
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.015
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: Image.asset(
                              'assets/images/default_profile.jpeg',
                              height: MediaQuery.of(context).size.height * 0.15,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.015
                          ),
                          Text(
                            "닉네임 님",
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
            Container(
              width: MediaQuery.of(context).size.width * 1.0,
              height: MediaQuery.of(context).size.height * 0.11,
              child: buildMyPageCenterMenu(context),
            ),
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

  @override
  void initState() {
    super.initState();
    log("my page initState()");
  }

  Future<String> fetchUserData() async {
    log("[fetchUserData]");
    await Future.delayed(Duration(seconds: 1));
    return "Hello, Flutter!";
  }

  // 마이페이지의 중간 메뉴 만들기
  Widget buildMyPageCenterMenu(BuildContext context) {
    return Card(
      color: Color(0x88005766),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
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
                  Image.asset(
                    'assets/images/default_profile.jpeg',
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Text(
                    "내 정보 수정",
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  )
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
                  Image.asset(
                    'assets/images/default_profile.jpeg',
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Text(
                    "나의 셀러",
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  )
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
                  Image.asset(
                    'assets/images/default_profile.jpeg',
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Text(
                    "내 활동",
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
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
}

