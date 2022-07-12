import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_link/kakao_flutter_sdk_link.dart';
import 'package:tipsy_mobile/pages/home.dart';
import 'package:tipsy_mobile/pages/search.dart';
//import 'package:tipsy_mobile/classes/liquor.dart';

void main() {
  KakaoSdk.init(nativeAppKey: '87257d8db7512fd56ca5157564988776');
  runApp(
    MaterialApp(
      title: 'Main',
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'NanumBarunGothicBold'
      ),
      home:MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  int _selectedPageIndex = 0; // 선택된 페이지의 인덱스 번호

  List<Widget> _pageChildren = <Widget>[
    Home(),
    SecondRoute2(),
    SecondRoute2()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  // main widget
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'NanumBarunGothic'),
      home: Scaffold(
        appBar: AppBar(
            title: Text('TIPSY', style: TextStyle(color: Color(0xff005766), fontFamily: 'NanumBarunGothicBold')),
            //backgroundColor: Color(0xff005766),
            backgroundColor: Color(0xffffffff),
            actions: [
              IconButton(icon: Icon(Icons.search),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchPage()),
                  );
                },
                color: Color(0xff005766),
                iconSize: 30,
              )
            ]
        ),
        body: _pageChildren.elementAt(_selectedPageIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            new BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "홈",
            ),
            new BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              label: "new",
            ),
            new BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "마이페이지",
            ),
          ],
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 11),
          selectedItemColor: Color(0xdd005766),
          onTap: _onItemTapped,
          // onTap: (int index) {
          //   print("INDEX is $index");
          //   _selectedPageIndex = index;
          //   switch (index) {
          //     case 0:
          //       // Navigator.push(
          //       //   context,
          //       //   MaterialPageRoute(builder: (context) => SecondRoute()),
          //       // );
          //       break;
          //     case 1:
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (context) => SecondRoute()),
          //       );
          //       break;
          //     case 2:
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (context) => SecondRoute()),
          //       );
          //       break;
          //   }
          // },

        ),
      ),
    );
  }

  @override
  void initState() {
    // 해당 클래스가 호출되었을 때
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

}



class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            // 눌렀을 때 첫 번째 route로 되돌아 갑니다.
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}

class SecondRoute2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [Text("This is second page.")],
        ),
      ),
    );
  }
}