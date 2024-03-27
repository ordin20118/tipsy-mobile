import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marquee/marquee.dart';
import '../classes/bookmark.dart';
import '../classes/param/bookmark_param.dart';
import '../classes/recommand.dart';
import '../classes/ui_util.dart';
import '../classes/util.dart';
import '../classes/word.dart';
import '../requests/bookmark.dart';
import '../ui/tipsy_loading_indicator.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  static TextStyle boxMenuWhite = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold
  );

  static TextStyle boxMenuPupple = TextStyle(
      color: Color(0xff8748E1),
      fontWeight: FontWeight.bold
  );

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late Future<Recommand> recommand;
  late Future<Word> word;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
    return buildHomeScreenV2(context);
  }

  Widget buildHomeScreenV2(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      //color: getCommonBackColor(),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              buildRecommBox(context),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
              buildTodayLiquorCard(context),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
              // 오늘의 용어
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 10, 0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '오늘의 용어',
                          style: TextStyle(
                              fontSize: 20
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              buildTodayWordCard(context),
            ]
          ),
        ),
      ),
    );
  }

  // 메인의 상단 박스 메뉴
  Widget buildFirstBoxMenu(BuildContext context) {
    var boxMenuStyle = TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.height * 0.2,
          child: Container(
              child: Card(
                color: Color(0xffFFE8FF),
                shape: RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(const Radius.circular(10.0))
                ),
                elevation: 4.0, // 그림자 깊이
                child: Center(
                    child: Text('Top10 순위보기', style: Home.boxMenuPupple)),
              )
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.height * 0.2,
          child: Container(
              child: Card(
                  color: Color(0xffDEDEFF),
                  shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(const Radius.circular(10.0))
                  ),
                  elevation: 4.0, // 그림자 깊이
                  child: Center(
                    child: Text('MBTI', style: Home.boxMenuWhite),
                  )
              )
          ),
        )
      ],
    );
  }

  Widget buildTodayLiquorCard(BuildContext context) {
    return Card(
      //color: Color(0x99005766),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4CAF50), Color(0xFF2196F3)], // 시작 및 끝 색상 지정
            begin: Alignment.topLeft, // 그라데이션 시작 위치
            end: Alignment.bottomRight, // 그라데이션 끝 위치
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: FutureBuilder<Recommand>(
            future: recommand,
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                return GestureDetector(
                  onTap: () {
                    goToLiquorDetailPage(context, snapshot.data!.liquorList.first.liquorId);
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                "오늘의 추천 술",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15
                                ),
                              ),
                            ),
                            IconButton(
                              icon: getBookmarkIcon(snapshot.data!.liquorList.first.bookmark),
                              onPressed: () async {
                                // 북마크
                                BookmarkParam bParam = BookmarkParam();
                                bParam.contentId = snapshot.data!.liquorList.first.liquorId;
                                bParam.contentType = 100;

                                if(snapshot.data!.liquorList.first.bookmark) {
                                  Future<bool> bookmarkFuture = deleteBookmark(bParam);
                                  bool isDeleted = await bookmarkFuture;
                                  if(isDeleted != null && isDeleted) {
                                    setState(() {
                                      snapshot.data!.liquorList.first.bookmark = false;
                                    });
                                  } else {
                                    dialogBuilder(context, "알림", "북마크 제거에 실패했습니다.\n나중에 다시 시도해주세요.");
                                  }
                                } else {
                                  Future<Bookmark> bookmarkFuture = requestBookmark(bParam);
                                  Bookmark bookmark = await bookmarkFuture;
                                  if(bookmark != null) {
                                    setState(() {
                                      snapshot.data!.liquorList.first.bookmark = true;
                                    });
                                  } else {
                                    dialogBuilder(context, "알림", "북마크에 실패했습니다.\n나중에 다시 시도해주세요.");
                                  }
                                }
                              },
                              color: Colors.white,
                              iconSize: 30,
                            )
                          ],
                        ),
                        // Liquor Image Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.3,
                              child: makeImgWidget(context, snapshot.data!.liquorList.first.repImgUrl, 300, MediaQuery.of(context).size.height * 0.17),
                            ),
                          ],
                        ),
                        // Liquor Category Row
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                          child: Row(
                            children: [
                              Text(
                                snapshot.data!.liquorList.first.getLastCategoryName(),
                                style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 12
                                ),
                              )
                            ],
                          ),
                        ),
                        // Liquor Name_KR Row
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 7),
                          child: Row(
                            children: [
                              Flexible(
                                child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    strutStyle: StrutStyle(fontSize: 8.0),
                                    text: TextSpan(
                                      text: snapshot.data!.liquorList.first.nameKr,
                                      style: TextStyle(
                                        fontSize: 17.0,
                                        color: Colors.white,
                                      ),
                                    )
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 7),
                          child: Row(
                            children: [
                              Flexible(
                                child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    strutStyle: StrutStyle(fontSize: 8.0),
                                    text: TextSpan(
                                      text: snapshot.data!.liquorList.first.nameEn,
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.white60,
                                      ),
                                    )
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: makeStarUi(1, snapshot.data!.liquorList.first.ratingAvg),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              } else if(snapshot.hasError) {
                return Container(height: 0,);
              }
              // loading ui
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.91,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            "오늘의 추천 술",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.bookmark_border),
                          //icon: Icon(Icons.bookmark),
                          onPressed: () {
                          },
                          color: Colors.white,
                          iconSize: 30,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          //width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.height * 0.35,
                          child: Center(child: TipsyLoadingIndicator()),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                      child: Row(
                        children: [
                          Text(
                            '',
                            style: TextStyle(
                                color: Colors.white60,
                                fontSize: 15
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 7),
                      child: Row(
                        children: [
                          Text(
                            " ",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 19
                            ),
                          ),
                          Text(
                            " ",
                            style: TextStyle(
                                color: Colors.white60,
                                fontSize: 15
                            ),
                          )
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     children: makeStarUi(1, 0.0),
                    //   ),
                    // )
                  ],
                ),
              );
            }
        ),
      ),
    );
  }

  Widget buildRecommBox(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(13, 0, 13, 0),
        child: Card(
          color: Color(0xff9EBBF5),
          elevation: 4.0,
          shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(const Radius.circular(10.0))
          ),
          child: InkWell(
            onTap: () {
              goToRecommandPage(context);
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.2,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      'assets/images/liquor_collection.png',
                      width: MediaQuery.of(context).size.width * 0.4,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            SizedBox(height: MediaQuery.of(context).size.height * 0.04,),
                            Text(
                                //'간편하게 술 찾기            ',
                                '오늘은 어떤 술?            ',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                            Text(
                                '나에게 어울리는 술을 쉽고 간단하게 찾아보세요.',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                )
                            ),
                          ],
                        ),
                      )
                    ),
                  ],
                )
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTodayWordCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(13, 0, 13, 13),
      child: FutureBuilder<Word> (
        future: word,
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(13),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: Row(
                    children: [
                      Text(
                        snapshot.data!.nameKr,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      Expanded(
                          child: Container(
                            //width: MediaQuery.of(context).size.width * 0.5,
                            height: 20,
                            child: Marquee(
                              text: snapshot.data!.description,
                              blankSpace: 100.0,
                              scrollAxis: Axis.horizontal,
                              velocity: 27.0,
                              accelerationDuration: Duration(seconds: 1),
                            ),
                          )
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if(snapshot.hasError) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(13),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: Row(
                    children: [
                      Text(
                        '체이서',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 20,
                        child: Marquee(
                          text: '독한 술이나 칵테일 뒤에 마시는 물이나 음료를 말한다.',
                          blankSpace: 100.0,
                          scrollAxis: Axis.horizontal,
                          velocity: 27.0,
                          accelerationDuration: Duration(seconds: 1),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(13),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Row(
                  children: [
                    Text(
                      ' ',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: 20,
                      child: Marquee(
                        text: '               ',
                        blankSpace: 100.0,
                        scrollAxis: Axis.horizontal,
                        velocity: 27.0,
                        accelerationDuration: Duration(seconds: 1),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  @override
  void dispose() {
    super.dispose();
    log("home page dispose()");
  }

  @override
  void initState() {
    super.initState();
    log("home page initState()");

    recommand = requestTodayRecommand();
    word = requestTodayWord();
  }
}
