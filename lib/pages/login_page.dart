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
    initKakaoTalkInstalled();
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

  // 카카오톡 존재 여부 초기화 - TODO: 카카오 앱이 있음에도 설치되지 않았다고 나옴
  void initKakaoTalkInstalled() async {
    final installed = await isKakaoTalkInstalled();
    log('kakao install: '+ installed.toString());
    setState(() {
      _isKakaoTalkInstalled = installed;
    });
  }

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
      log('카카오톡으로 로그인 성공 ${token.accessToken}/${token.refreshToken}');

      // 회원 가입 절차
      // 1. 회원 여부 확인
      KakaoUser.User user = await UserApi.instance.me();
      log("kakao user id:" + user.id.toString());

      String? email = user.kakaoAccount?.email;
      String? nickname = user.kakaoAccount?.profile?.nickname;

      // 회원 가입 여부 확인 및 로그인 처리
      checkPlatformId(USER_PLATFORM_KAKAO, user.id.toString(), email);

      // bool isDup =  await checkEmailDuplicate(email);
      //
      // if(isDup) {
      //   print("이미 가입된 이메일 입니다.");
      //
      //   // 1. 서비스 토큰 발급
      //   AccessToken token = await requestAccessToken(USER_PLATFORM_KAKAO, email!, '');
      //
      //   print("[액세스 토큰 발급]: $token");
      //
      //   if(token != null && token.tokenHash.length > 0 && email != null) {
      //
      //     // 2. 자동 로그인 처리
      //     bool isLogin = await autoLogin(USER_PLATFORM_KAKAO, email, token.tokenHash);
      //
      //     if(isLogin) {
      //       goToMainPageReplace(context);
      //     } else {
      //       throw Exception('Failed auto login.');
      //     }
      //   } else {
      //     throw Exception('Failed isuue access token.');
      //   }
      //
      // } else {
      //   log("가입할 수 있는 이메일 입니다.");
      //   // TODO: 가입 페이지로 이동 => 함수로 빼내기
      //   // Navigator.push(
      //   //   context,
      //   //   MaterialPageRoute(builder: (context) => JoinPage(platform: USER_PLATFORM_KAKAO, email: email ?? "", nickname: nickname ?? "", accessToken: token.accessToken, refreshToken: token.refreshToken,)),
      //   // );
      //   //goToJoinPage(USER_PLATFORM_KAKAO, decodedToken['sub'], "");
      // }

    } catch(e) {
      log('카카오톡으로 로그인 실패 $e');
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
      log('카카오계정으로 로그인');
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
      log('카카오계정으로 로그인 성공 ${token.accessToken}/${token.refreshToken}');
      KakaoUser.User user = await UserApi.instance.me();
      log("kakao user id:" + user.id.toString());
      String? email = user.kakaoAccount?.email;
      // 회원 가입 여부 확인 및 로그인 처리
      checkPlatformId(USER_PLATFORM_KAKAO, user.id.toString(), email);

    } catch(e) {
      log('카카오계정으로 로그인 실패 $e');
      showErrorToast("카카오톡 로그인 실패");
    }
  }

  // 카카오톡 로그인 연동 해제
  void _logoutFromKakao() async {
    try {
      await UserApi.instance.logout();
      log('로그아웃 성공, SDK에서 토큰 삭제');
    } catch (error) {
      log('로그아웃 실패, SDK에서 토큰 삭제 $error');
    }
  }

  void _unlinkFromKakao() async {
    try {
      await UserApi.instance.unlink();
      log('연결 끊기 성공, SDK에서 토큰 삭제');
    } catch (error) {
      log('연결 끊기 실패 $error');
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

        Map<String, dynamic> decodedToken = JwtDecoder.decode(result.identityToken.toString());

        log('로그인 결과 : sub:${decodedToken['sub']}');

        // 회원 가입 여부 확인 및 로그인 처리
        checkPlatformId(USER_PLATFORM_APPLE, decodedToken['sub'], '');

      } catch (e) {
        // 다른 예외에 대한 처리
        log('Sign in with Apple Error: $e');
        showErrorToast("Apple 로그인 실패. 다시 시도해 주세요.");
      }
    } else {
      log('애플 로그인을 지원하지 않는 기기입니다.');
      showErrorToast("애플 로그인을 지원하지 않는 기기입니다.");
    }
  }

  void checkPlatformId(platform, platformId, email) async {
    try {
      bool hasUser = await checkSocialUser(platform, platformId);
      if(hasUser) {
        log("[이미 소셜 사용자 존재]");

        // 1. 서비스 토큰 발급
        AccessToken token = await requestAccessToken(platform, email, platformId);

        log("[액세스 토큰 발급]: $token");

        if(token != null && token.tokenHash.length > 0 && token.email != null) {

          // 2. 자동 로그인 처리
          bool isLogin = await autoLogin(USER_PLATFORM_APPLE, token.email, token.tokenHash);

          if(isLogin) {
            goToMainPageReplace(context);
          } else {
            showErrorToast("로그인 실패. 다시 시도해 주세요.");
            throw Exception('Failed auto login.');
          }
        } else {
          showErrorToast("로그인 실패. 다시 시도해 주세요.");
          throw Exception('Failed isuue access token.');
        }
      } else {
        // 회원가입 페이지 이동
        log("[회원가입 페이지 이동]");
        goToJoinPage(platform, platformId, "");
      }
    } catch(e) {
      showErrorToast("로그인 실패. 다시 시도해 주세요.");
      throw e;
    }
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
    log("#### [checkSocialUser] #### / platform:"+platform.toString()+"/socialId:"+socialId);

    String chckPath = "/user/social_user.tipsy";

    var bodyData = {
      "platform": platform,
      "social_id": socialId
    };

    http.Response response = await requestPOST(chckPath, bodyData);
    log("" + response.statusCode.toString());
    log("" + response.body.toString());

    if (response.statusCode == 200) {

      String resString = response.body.toString();
      log("[checkSocialUser]:" + resString);
      var parsed = null;
      try {
        parsed = json.decode(resString);
      } catch(e) {
        log("$e");
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

}