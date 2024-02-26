import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_flutter_sdk_auth/kakao_flutter_sdk_auth.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as KakaoUser;
import 'package:kakao_flutter_sdk_talk/kakao_flutter_sdk_talk.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import 'package:tipsy_mobile/classes/util.dart';
import 'package:tipsy_mobile/classes/ui_util.dart';
import 'package:tipsy_mobile/classes/user.dart';
import 'package:tipsy_mobile/pages/home.dart';
import 'dart:convert';
import 'package:tipsy_mobile/pages/join_page.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart' as AppleScope;

import '../classes/user.dart';
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
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Colors.black,
    // ));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/login_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.6),
                BlendMode.dstATop
            )
        ),
      ),
      child: Container(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.23,
            ),
            Container(
              //height: MediaQuery.of(context).size.height * 0.5,
              child: Center(
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(2.0, 2.0),
                        blurRadius: 8.0,
                        color: Colors.black.withOpacity(0.9),
                      ),
                    ],
                  ), child: Text('Tipsy'),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Container(
              child: Center(
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(2.0, 2.0),
                        blurRadius: 8.0,
                        color: Colors.black.withOpacity(1.0),
                      ),
                    ],
                  ), child: Text(
                    '팁씨와 함께 건강한\n음주 문화를 만들어 보세요!',
                    textAlign: TextAlign.center,
                ),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.8,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.yellow,
                    padding: EdgeInsets.all(0.0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                          'assets/images/logo/kakaotalk_logo_small_ov.png',
                          width: 50.0,
                          height: 50.0
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        '카카오 로그인',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black
                        ),
                      )
                    ],
                  ),
                  onPressed: _isKakaoTalkInstalled ? _loginWithKakaoTalk : _loginWithKakaoAccount
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.8,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.all(0.0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                          'assets/images/logo/apple_logo_white_1x.png',
                          width: 50.0,
                          height: 50.0
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        'Sign in with Apple',
                        style: TextStyle(fontSize: 18.0),
                      )
                    ],
                  ),
                  onPressed: () async {
                    await appleLogin();
                  }
              ),
            ),
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
    log("Login Page initState()");

    // initKakaoTalkInstalled();
    checkAutoLogin();
    // TODO: remove under test code ...
    // registTestUser();
    // _logoutFromKakao();
    // _unlinkFromKakao();
  }

  // 자동 로그인 데이터 확인
  void checkAutoLogin() async {
    final storage = new FlutterSecureStorage();
    String? platform = await storage.read(key: 'platform');
    String? accessToken = await storage.read(key: 'accessToken');
    String? email = await storage.read(key: 'email');

    if(accessToken != null && platform != null && email != null) {
      bool isLogin = await autoLogin(int.parse(platform), email, accessToken);
      if(isLogin) {
        goToMainPageReplace(context);
      }
    }
  }

  // TODO: remove
  void registTestUser() async {
    final storage = new FlutterSecureStorage();
    await storage.write(key:'accessToken', value:'AUTOmKFxUkmakDV9w8z/yLOxrbm0WwxgbNpsOS6HhoUAGNY=');
    await storage.write(key:'platform', value:USER_PLATFORM_KAKAO.toString());
    //await storage.write(key:'id', value:token.userId.toString());
    await storage.write(key:'email', value:'kimho2018@naver.com');
    goToMainPageReplace(context);
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
  void goToJoinPage(int platform, String socialId, String email) {
    log("[goToJoinPage] platform:${platform}/socialId:${socialId}/email:${email}");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => JoinPage(platform: platform, socialId: socialId, email: email)),
    );
  }


  // 카카오톡으로 로그인
  void _loginWithKakaoTalk() async {

    try {
      OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
      print('카카오톡으로 로그인 성공 ${token.accessToken}/${token.refreshToken}');

      // 회원 가입 절차
      // 1. 회원 여부 확인
      KakaoUser.User user = await UserApi.instance.me();
      String? email = user.kakaoAccount?.email;
      String? nickname = user.kakaoAccount?.profile?.nickname;

      // api로 사용자 계정 유무 확인 - email
      bool isDup =  await checkEmailDuplicate(email);

      if(isDup) {
        print("이미 가입된 이메일 입니다.");

        // 1. 서비스 토큰 발급
        AccessToken token = await requestAccessToken(USER_PLATFORM_KAKAO, email!, '');

        print("[액세스 토큰 발급]: $token");

        if(token != null && token.tokenHash.length > 0 && email != null) {

          // 2. 자동 로그인 처리
          bool isLogin = await autoLogin(USER_PLATFORM_KAKAO, email, token.tokenHash);

          if(isLogin) {
            goToMainPageReplace(context);
          } else {
            throw Exception('Failed auto login.');
          }
        } else {
          throw Exception('Failed isuue access token.');
        }

      } else {
        print("가입할 수 있는 이메일 입니다.");
        // TODO: 가입 페이지로 이동 => 함수로 빼내기
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => JoinPage(platform: USER_PLATFORM_KAKAO, email: email ?? "", nickname: nickname ?? "", accessToken: token.accessToken, refreshToken: token.refreshToken,)),
        // );
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

      // 카카오톡 설치 유무 확인
      if(await isKakaoTalkInstalled()) {  // 카카오톡 설치됨
        // 카카오로 로그인: 웹
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공 ${token.accessToken}/${token.refreshToken}');
      } else {                            // 카카오톡 설치 안됨
        // 카카오 계정으로 로그인
        // OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        // print('카카오계정으로 로그인 성공 ${token.accessToken}/${token.refreshToken}');
      }

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


  Future<bool> checkSocialUser(platform, socialId) async {
    print("#### [checkSocialUser] #### / platform:"+platform.toString()+"/socialId:"+socialId);
    String host = getAPIHost();
    String chckUrl = host + "/user/social_user.tipsy";
    final Uri url = Uri.parse(chckUrl);

    var bodyData = {
      "platform": platform,
      "social_id": socialId
    };

    // http.Response response = await http.post(
    //   url,
    //   headers: <String, String> {
    //     'Content-Type': 'application/json',
    //   },
    //   body: json.encode(bodyData),
    // );

    http.Response response = await requestPOST(url, bodyData);

    if (response.statusCode == 200) {

      String resString = response.body.toString();
      print("[checkSocialUser]:" + resString);
      var parsed = null;
      try {
        parsed = json.decode(resString);
      } catch(e) {
        print(e);
      }

      var data = parsed['data'];

      if(data != null) {
        return data;
      } else {
        throw Exception('Failed to check social user.');
      }

    } else {
      throw Exception('Failed to check social user.');
    }
  }


  Future<void> appleLogin() async {
    if(await SignInWithApple.isAvailable()) {

      try {
        final result = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );

        // # 테스트 필요
        // String redirectURL = dotenv.env['APPLE_REDIRECT_URI'].toString();
        // print(redirectURL);
        // String? clientID = dotenv.env['APPLE_CLIENT_ID'];
        // final appleIdCredential = await SignInWithApple.getAppleIDCredential(
        //     scopes: [
        //       AppleIDAuthorizationScopes.email,
        //       AppleIDAuthorizationScopes.fullName,
        //     ],
        //     webAuthenticationOptions: WebAuthenticationOptions(
        //       clientId: clientID!,
        //       redirectUri: Uri.parse(redirectURL),
        //
        //     ));
        // print(appleIdCredential.authorizationCode);
        // this.socialLogin(appleIdCredential.authorizationCode, "apple");

        // print('로그인 결과 : state:${result.state}');
        // print('로그인 결과 : email:${result.email}');
        // print('로그인 결과 : familyName:${result.familyName}');
        // print('로그인 결과 : givenName:${result.givenName}');
        // print('로그인 결과 : authorizationCode:${result.authorizationCode}');
        // print('로그인 결과 : identityToken:${result.identityToken}');

        Map<String, dynamic> decodedToken = JwtDecoder.decode(result.identityToken.toString());

        log('로그인 결과 : sub:${decodedToken['sub']}');


        // 회원 가입 여부 확인
        bool hasUser = await checkSocialUser(USER_PLATFORM_APPLE, decodedToken['sub']);
        if(hasUser) {
          log("[이미 소셜 사용자 존재]");

          // 1. 서비스 토큰 발급
          AccessToken token = await requestAccessToken(USER_PLATFORM_APPLE, '', decodedToken['sub']);

          print("[액세스 토큰 발급]: $token");

          if(token != null && token.tokenHash.length > 0 && token.email != null) {

            // 2. 자동 로그인 처리
            bool isLogin = await autoLogin(USER_PLATFORM_APPLE, token.email, token.tokenHash);

            if(isLogin) {
              goToMainPageReplace(context);
            } else {
              throw Exception('Failed auto login.');
            }
          } else {
            throw Exception('Failed isuue access token.');
          }
        } else {
          log("[회원가입 페이지 이동]");
          // 회원가입 페이지 이동
          goToJoinPage(USER_PLATFORM_APPLE, decodedToken['sub'], "");
        }
      } catch (e) {
        // 다른 예외에 대한 처리
        log('Sign in with Apple Error: $e');
      }
    } else {
      log('애플 로그인을 지원하지 않는 기기입니다.');
    }
  }
}