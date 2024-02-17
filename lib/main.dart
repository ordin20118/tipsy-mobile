import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
//import 'package:kakao_flutter_sdk_link/kakao_flutter_sdk_link.dart';
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
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
  String _title = "";
  String _subTitle = "";

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
      theme: ThemeData(
        primaryColor: Colors.teal,
        primarySwatch: Colors.teal,
        // primarySwatch: MaterialColor(0xFF009688, {
        //   50: Color(0xFFE0F2F1),
        //   100: Color(0xFFB2DFDB),
        //   200: Color(0xFF80CBC4),
        //   300: Color(0xFF4DB6AC),
        //   400: Color(0xFF26A69A),
        //   500: Color(0xFF009688),
        //   600: Color(0xFF00897B),
        //   700: Color(0xFF00796B),
        //   800: Color(0xFF00695C),
        //   900: Color(0xFF004D40),
        // }),
        fontFamily: 'NanumBarunGothic',
        appBarTheme: AppBarTheme(
          shadowColor: Colors.black
        )
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(_title, style: TextStyle(color: Color(0xff005766), fontFamily: 'NanumBarunGothicBold')),
              SizedBox(width: MediaQuery.of(context).size.width * 0.015,),
              Text(
                _subTitle,
                style: TextStyle(
                  color: Color(0xff005766),
                  fontFamily: 'NanumBarunGothicBold',
                  fontSize: 13
                )
              )
            ],
          ),
          backgroundColor: Color(0xffffffff),
          actions: getAppBarIcons(_selectedPageIndex),
          centerTitle: false,
          elevation: 0.1,
        ),
        body: Stack(
          children: [
            Offstage(
              offstage: _selectedPageIndex != 0,
              child: const Home(),
            ),
            Offstage(
              offstage: _selectedPageIndex != 1,
              child: CreateMenuPage(),
            ),
            Offstage(
              offstage: _selectedPageIndex != 2,
              child: const MyPage(),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Color(0xffEAEAEA), width: 1.0)), // 라인효과
          ),
          child: BottomNavigationBar(
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
                  _subTitle = "";
                } else {
                  _title = "Tipsy";
                  _subTitle = "건강한 술 생활";
                }
              });
            },
          ),
        )
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
    print("Main Page dispose()");
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
                  color: Color.fromRGBO(246, 246, 246, 1.0),
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