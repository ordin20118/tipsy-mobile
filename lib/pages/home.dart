import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import '../classes/recommand.dart';
import '../classes/ui_util.dart';
import '../classes/util.dart';
import '../classes/word.dart';

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
    return buildHomeScreenV2(context);
  }

  Widget buildHomeScreenV2(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      color: Color(0x33eaeaea),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Card(
                color: Color(0x99005766),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FutureBuilder<Recommand>(
                  future: recommand,
                  builder: (context, snapshot) {
                    if(snapshot.hasData) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    "오늘의 추천 술",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14
                                    ),
                                  ),
                                ),
                                SizedBox(width: MediaQuery.of(context).size.width * 0.3),
                                IconButton(
                                  icon: Icon(Icons.bookmark_border),
                                  //icon: Icon(Icons.bookmark),
                                  onPressed: () {},
                                  color: Colors.white,
                                  iconSize: 30,
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.5,
                                  height: MediaQuery.of(context).size.height * 0.4,
                                  child: makeImgWidget(context, snapshot.data!.liquorList.first.repImgUrl, 300, MediaQuery.of(context).size.height * 0.17),
                                ),
                              ],
                            ),
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
                                  // Text(
                                  //   snapshot.data!.liquorList.first.nameEn,
                                  //   style: TextStyle(
                                  //       color: Colors.white60,
                                  //       fontSize: 13
                                  //   ),
                                  // )
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
                                children: makeStarUi(3),
                              ),
                            )
                          ],
                        ),
                      );
                    } else if(snapshot.hasError) {
                      return Container(height: 0,);
                    }

                    // loading ui
                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  "오늘의 추천 술",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14
                                  ),
                                ),
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width * 0.3),
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
                                child: Center(child: CircularProgressIndicator()),
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
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: makeStarUi(3),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 10, 0),
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
              Padding(
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
              ),
              Padding(
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
                        child: Center(child: Text('나만의 칵테일 등록하기', style: Home.boxMenuWhite)),
                      ),
                    ),
                  ),
              ),
            ]
          ),
        ),
      ),
    );
  }

  Widget buildHomeScreenV1(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
                children: [
                  Container(
                    color: Color(0xffb74093),
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                        child: Text(
                            "추천 게시글",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                            )
                        )),
                  )
                ]
            ),
            Container(
              color: Colors.grey,
              padding: EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height * 0.15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                      children: [
                        Expanded(child: Image.asset('assets/images/10_300.png')),
                        Text(
                          '주류',
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black87
                          ),
                        )
                      ]
                  ),
                  Column(
                      children: [
                        // Expanded(
                        //     child: CircleAvatar(
                        //       backgroundImage: Image.asset('assets/images/11_300.png'),
                        //       radius: 100,
                        //     )
                        // ),
                        Expanded(child: Image.asset('assets/images/11_300.png')),
                        Text(
                          '칵테일',
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black87
                          ),
                        )
                      ]
                  ),
                  Column(
                      children: [
                        Expanded(child: Image.asset('assets/images/12_300.png')),
                        Text(
                          '재료',
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black87
                          ),
                        )
                      ]
                  ),
                  Column(
                      children: [
                        Expanded(child: Image.asset('assets/images/13_300.png')),
                        Text(
                          '용어',
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black87
                          ),)
                      ]
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.55,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      child: buildFirstBoxMenu(context)
                  ),

                  Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: Container(
                                child: Card(
                                  color: Color(0xffFFFFDD),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: const BorderRadius.all(const Radius.circular(10.0))
                                  ),
                                  elevation: 4.0, // 그림자 깊이
                                  child: Center(
                                    child: Text('나의 술 지식 테스트', style: Home.boxMenuPupple),
                                  ),
                                )
                            ),
                          ),
                        ],
                      )
                  )
                ],
              ),
            ),

          ],
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
