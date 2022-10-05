import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_link/kakao_flutter_sdk_link.dart';
import 'package:tipsy_mobile/pages/home.dart';
import 'package:tipsy_mobile/pages/search.dart';
import 'package:tipsy_mobile/pages/splash_page.dart';
import 'package:tipsy_mobile/pages/my_page.dart';
import 'package:tipsy_mobile/pages/setting_page.dart';
import 'package:flutter_config/flutter_config.dart';

import 'classes/ui_util.dart';

void main() async {
  KakaoSdk.init(nativeAppKey: '87257d8db7512fd56ca5157564988776');

  // set config data
  WidgetsFlutterBinding.ensureInitialized(); // Required by FlutterConfig
  await FlutterConfig.loadEnvVariables();
  print(FlutterConfig.get('API_URL'));

  final cameras = await availableCameras();
  log(cameras.toString());

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
      home:SplashPage(),
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
  String _title = "TIPSY";

  List<Widget> _pageChildren = <Widget>[
    Home(),
    CreateMenuPage(),
    MyPage()
  ];

  // test
  List<Widget> getAppBarIcons(index) {
    List<Widget> res = <Widget>[];
    if(index == 2) {
      res.add(
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingPage()),
              );
            },
            color: Color(0xff005766),
            iconSize: 22,
          )
      );
    } else {
      res.add(
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
            color: Color(0xff005766),
            iconSize: 30,
          )
      );
    }
    return res;
  }

  // main widget
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'NanumBarunGothic'),
      home: Scaffold(
        appBar: AppBar(
            title: Text(_title, style: TextStyle(color: Color(0xff005766), fontFamily: 'NanumBarunGothicBold')),
            //backgroundColor: Color(0xff005766),
            backgroundColor: Color(0xffffffff),
            actions: getAppBarIcons(_selectedPageIndex),
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
          selectedLabelStyle: TextStyle(fontSize: 13),
          selectedItemColor: Color(0xdd005766),
          //unselectedItemColor: Colors.grey,
          currentIndex: _selectedPageIndex,
          onTap: (int index) {
            setState(() {
              _selectedPageIndex = index;
              if(index == 2) {
                _title = "마이페이지";
              } else {
                _title = "TIPSY";
              }
            });
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    print("Main Page initState()");

    chekStorageData();
  }

  void chekStorageData() async {
    final storage = new FlutterSecureStorage();
    String accessToken = await storage.read(key: "accessToken") ?? "";
    String email = await storage.read(key: "email") ?? "";
    log("[AccessToken]:" + accessToken + "/[Email]:" + email);
  }

  @override
  void dispose() {
    super.dispose();
  }

}

class CreateMenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
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
                      goToCameraPage(context);
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.height * 0.08,
                      child: Center(child: Text('사진으로 주류 찾기', style: Home.boxMenuWhite)),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
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
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.height * 0.08,
                      child: Center(child: Text('나만의 칵테일 등록하기', style: Home.boxMenuWhite)),
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),
    );
  }
}