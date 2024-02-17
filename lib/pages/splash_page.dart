import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:tipsy_mobile/classes/ui_util.dart';
import 'package:tipsy_mobile/main.dart';
import 'package:tipsy_mobile/pages/login_page.dart';
import 'package:tipsy_mobile/classes/util.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  static final storage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/login_background.jpg'),
            fit: BoxFit.cover
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [

          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    log("Splash Page initState()");

    //setTestToken(); // just use test
    checkAutoLogin();
  }

  void checkAutoLogin() async {
    final storage = new FlutterSecureStorage();

    //await storage.deleteAll();
    //await storage.write(key:'is_auto_login', value:'true');

    String? accessToken = await storage.read(key: "accessToken");
    if(accessToken != null) {

      // request auto login
      String? platformStr = await storage.read(key: "platform");
      String? email = await storage.read(key: "email");

      if(platformStr == null || email == null) {
        log("[Splash Page]: 자동 로그인 정보 없음");
        goToLoginPage(context);
      }

      int platform = int.parse(platformStr!);

      bool isLogin = false;
      try{
        isLogin = await autoLogin(platform, email!, accessToken);
      } catch(e) {
        goToLoginPage(context);
      }

      if(isLogin) {
        // 메인 페이지로
        log("[Splash Page]: 자동 로그인 성공");
        goToMainPage(context);
      } else {
        // 로그인 페이지로
        log("[Splash Page]: 자동 로그인 실패");
        goToLoginPage(context);
      }

    } else {
      log("[Splash Page]: 자동 로그인 정보 없음");
      // 로그인 페이지로
      goToLoginPage(context);
    }
  }


}