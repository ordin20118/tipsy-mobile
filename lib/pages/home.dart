import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import '../classes/ui_util.dart';

class Home extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return buildHomeScreenV2(context);
  }

  Widget buildHomeScreenV2(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 30, 10, 20),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Card(
                color: Color(0x99005766),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              "추천",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14
                              ),
                            ),
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width * 0.5),
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
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: MediaQuery.of(context).size.height * 0.35,
                            child: Image.asset('assets/images/13_300.png'),
                            // Expanded(
                            //     child: Padding(
                            //       padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            //       child: Image.asset('assets/images/13_300.png'),
                            //     )
                            // ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                        child: Row(
                          children: [
                            Text(
                              '위스키',
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
                              '잭다니엘 ',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19
                              ),
                            ),
                            Text(
                              ' Jack Dinel',
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
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 10, 3),
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
                padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(13),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
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
                ),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(15, 20, 10, 0),
                  child: Card(
                    color: Color(0xffC98AFF),
                    shape: RoundedRectangleBorder(
                        borderRadius: const BorderRadius.all(const Radius.circular(10.0))
                    ),
                    elevation: 4.0, // 그림자 깊이
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.08,
                      child: Center(child: Text('나만의 칵테일 등록하기', style: boxMenuWhite)),
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
                                    child: Text('나의 술 지식 테스트', style: boxMenuPupple),
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
                    child: Text('Top10 순위보기', style: boxMenuPupple)),
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
                    child: Text('MBTI', style: boxMenuWhite),
                  )
              )
          ),
        )
      ],
    );
  }

}
