import 'package:flutter/material.dart';

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
