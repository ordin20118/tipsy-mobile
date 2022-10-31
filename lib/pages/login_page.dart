import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_flutter_sdk_auth/kakao_flutter_sdk_auth.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:kakao_flutter_sdk_talk/kakao_flutter_sdk_talk.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:tipsy_mobile/classes/util.dart';
import 'package:tipsy_mobile/classes/ui_util.dart';
import 'package:tipsy_mobile/classes/user.dart';
import 'package:tipsy_mobile/pages/home.dart';
import 'dart:convert';
import 'package:tipsy_mobile/pages/join_page.dart';

import '../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool _isKakaoTalkInstalled = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/login_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.8),
                BlendMode.dstATop
            )
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(toolbarHeight: 0,),
        body: Container(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Center(
                  child: Text('Tipsy', style: TextStyle(
                      color: Colors.white,
                      fontSize: 60,
                  ),),
                ),
              ),
              //kakao_login_medium_wide
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(0.0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Image.asset('assets/images/login_btn/kakao_login_medium_wide.png'),
                  onPressed: _isKakaoTalkInstalled ? _loginWithKakaoTalk : _loginWithKakaoAccount
                  //onPressed: goToMainPage
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
              )
            ],
          ),
        ),
        bottomNavigationBar: Container(height: 0,),
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
    log("Login Page initState()");
    initKakaoTalkInstalled();


    // TODO: remove under test code ...
    registTestUser();
    _logoutFromKakao();
    _unlinkFromKakao();
  }

  // TODO: remove
  void registTestUser() async {
    final storage = new FlutterSecureStorage();
    await storage.write(key:'accessToken', value:'AUTOmKFxUkmakDV9w8z/yLOxrbm0WwxgbNpsOS6HhoUAGNY=');
    await storage.write(key:'platform', value:USER_PLATFORM_KAKAO.toString());
    //await storage.write(key:'id', value:token.userId.toString());
    await storage.write(key:'email', value:'kimho2018@naver.com');
    goToMainPage(context);
  }

  // 카카오톡 존재 여부 초기화
  void initKakaoTalkInstalled() async {
    final installed = await isKakaoTalkInstalled();
    print('kakao install: '+ installed.toString());
    setState(() {
      _isKakaoTalkInstalled = installed;
    });
  }

  // for test
  // 함수를 하나로 통일해서 파라미터를 받자
  void goToJoinPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => JoinPage(platform: USER_PLATFORM_KAKAO, email: 'kimho2018@naver.com', nickname: '팡호', accessToken: '', refreshToken: '',)),
    );
  }


  // 카카오톡으로 로그인
  void _loginWithKakaoTalk() async {

    try {
      OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
      print('카카오톡으로 로그인 성공 ${token.accessToken}/${token.refreshToken}');

      // 회원 가입 절차
      // 1. 회원 여부 확인
      User user = await UserApi.instance.me();
      String? email = user.kakaoAccount?.email;
      String? nickname = user.kakaoAccount?.profile?.nickname;

      // api로 사용자 계정 유무 확인 - email
      bool isDup =  await checkEmailDuplicate(email);

      if(isDup) {
        print("이미 가입된 이메일 입니다.");

        // 1. 서비스 토큰 발급
        AccessToken token = await requestAccessToken(USER_PLATFORM_KAKAO, email!);

        if(token != null && token.tokenHash.length > 0 && email != null) {

          // 2. 자동 로그인 처리
          bool isLogin = await autoLogin(USER_PLATFORM_KAKAO, email, token.tokenHash);

          if(isLogin) {
            final storage = new FlutterSecureStorage();
            await storage.write(key:'accessToken', value:token.tokenHash);
            await storage.write(key:'platform', value:USER_PLATFORM_KAKAO.toString());
            await storage.write(key:'id', value:token.userId.toString());
            await storage.write(key:'email', value:email);
            goToMainPage(context);
          } else {
            throw Exception('Failed auto login.');
          }
        } else {
          throw Exception('Failed isuue access token.');
        }

      } else {
        print("가입할 수 있는 이메일 입니다.");
        // TODO: 가입 페이지로 이동 => 함수로 빼내기
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => JoinPage(platform: USER_PLATFORM_KAKAO, email: email ?? "", nickname: nickname ?? "", accessToken: token.accessToken, refreshToken: token.refreshToken,)),
        );
      }

    } catch(e) {
      print('카카오톡으로 로그인 실패 $e');
      // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
      // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
      if (e is PlatformException && e.code == 'CANCELED') {
        return;
      }
      // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
      _loginWithKakaoAccount();
    }
  }

  // 카카오계정으로 로그인
  void _loginWithKakaoAccount() async {
    try {
      print('웹에서 카카오톡 로그인');
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
      print('카카오계정으로 로그인 성공 ${token.accessToken}/${token.refreshToken}');

    } catch(e) {
      print('카카오계정으로 로그인 실패 $e');
      Fluttertoast.showToast(
          msg: "카카오톡 로그인 실패",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  // 카카오톡 로그인 연동 해제
  void _logoutFromKakao() async {
    try {
      await UserApi.instance.logout();
      print('로그아웃 성공, SDK에서 토큰 삭제');
    } catch (error) {
      print('로그아웃 실패, SDK에서 토큰 삭제 $error');
    }
  }

  void _unlinkFromKakao() async {
    try {
      await UserApi.instance.unlink();
      print('연결 끊기 성공, SDK에서 토큰 삭제');
    } catch (error) {
      print('연결 끊기 실패 $error');
    }
  }

  // 자동로그인 여부 확인
  void _checkKakaoToken() {
    // TODO
    // keychain에 저장되어 있는 정보가 있는지 확인
    // 플랫폼에 따라서 자동 로그인 절차 진행
    // 1. 카카오 로그인 연동일 경우
    // 1-1.
  }

  Future<bool> checkEmailDuplicate(email) async {
    print("#### [checkEmailDuplicate] ####//email:"+email);
    String chckUrl = "http://www.tipsy.co.kr/svcmgr/api/user/has_dup_email.tipsy";
    final Uri url = Uri.parse(chckUrl);
    
    var bodyData = {
      "email": email
    };

    http.Response response = await http.post(
      url,
      headers: <String, String> {
        'Content-Type': 'application/json',
      },
      body: json.encode(bodyData),
    );

    if (response.statusCode == 200) {

      String resString = response.body.toString();
      var parsed = null;
      try {
        parsed = json.decode(resString);
      } catch(e) {
        print(e);
      }

      var isDuplicated = parsed['state'];

      if(isDuplicated == 0) {
        return true;
      } else if(isDuplicated == 1) {
        return false;
      } else {
        throw Exception('Failed to check email duplication.');
      }

    } else {
      throw Exception('Failed to check email duplication.');
    }
  }

}