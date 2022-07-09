import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  static TextStyle boxMenuWhite = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold
  );

  static TextStyle boxMenuDark = TextStyle(
      color: Color(0xff5D5D5D),
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
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                      child: Text(
                        "추천 게시글",
                        style: TextStyle(
                          color: Colors.white,
                        )
                  )),
                )
              ]
            ),
            Container(
              color: Colors.blue,
              padding: EdgeInsets.all(8),
              height: MediaQuery.of(context).size.height * 0.15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                      children: [
                        Expanded(child: Image.asset('assets/images/10_300.png')),
                        Text('주류')
                      ]
                  ),
                  Column(
                      children: [
                        Expanded(child: Image.asset('assets/images/11_300.png')),
                        Text('칵테일')
                      ]
                  ),
                  Column(
                      children: [
                        Expanded(child: Image.asset('assets/images/12_300.png')),
                        Text('재료')
                      ]
                  ),
                  Column(
                      children: [
                        Expanded(child: Image.asset('assets/images/13_300.png')),
                        Text('용어')
                      ]
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.55,
              color: Colors.green,
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
                                  shape: RoundedRectangleBorder(
                                      borderRadius: const BorderRadius.all(const Radius.circular(10.0))
                                  ),
                                  elevation: 4.0, // 그림자 깊이
                                  child: Center(
                                    child: Text('나의 술 지식 테스트', style: boxMenuDark),
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
                    child: Text('Top10 순위보기', style: boxMenuDark)),
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
