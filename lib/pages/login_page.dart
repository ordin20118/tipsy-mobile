import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_flutter_sdk_auth/kakao_flutter_sdk_auth.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:kakao_flutter_sdk_talk/kakao_flutter_sdk_talk.dart';
import 'package:flutter/services.dart';


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
    print("Login Page initState()");
    initKakaoTalkInstalled();
  }

  // 카카오톡 존재 여부 초기화
  void initKakaoTalkInstalled() async {
    final installed = await isKakaoTalkInstalled();
    print('kakao install: '+ installed.toString());
    setState(() {
      _isKakaoTalkInstalled = installed;
    });
  }

  // 카카오톡으로 로그인
  void _loginWithKakaoTalk() async {
    try {
      OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
      print('카카오톡으로 로그인 성공 ${token.accessToken}/${token.refreshToken}');
      // 회원 가입 절차
    } catch(e) {
      print('카카오톡으로 로그인 실패 $e');
      // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
      // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
      if (e is PlatformException && e.code == 'CANCELED') {
        return;
      }
      // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
      try {
        await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공');
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  }

  // 카카오계정으로 로그인
  void _loginWithKakaoAccount() async {
    try {
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
      print('카카오계정으로 로그인 성공 ${token.accessToken}/${token.refreshToken}');
    } catch(e) {
      print('카카오계정으로 로그인 실패 $e');
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

  // 자동로그인 여부 확인
  void _checkKakaoToken() {
    // keychain에 저장되어 있는 정보가 있는지 확인
    // 플랫폼에 따라서 자동 로그인 절차 진행
    // 1. 카카오 로그인 연동일 경우
    // 1-1.
  }

}