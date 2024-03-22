import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tipsy_mobile/ui/form.dart';
import 'package:tipsy_mobile/classes/user.dart';
import 'package:tipsy_mobile/classes/util.dart';
import 'package:tipsy_mobile/classes/ui_util.dart';

import '../requests/user.dart';

class JoinPage extends StatefulWidget {
  JoinPage({Key? key, required this.platform, required this.socialId, required this.email}) : super(key: key);

  final int platform;
  final String socialId;
  final String email;

  bool isAge = false;
  bool isNick = false;

  @override
  _JoinPageState createState() => _JoinPageState();
}


class _JoinPageState extends State<JoinPage> {

  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _nickname = '';
  String _age = '';
  Gender _gender = Gender.male;

  bool _nicknameDupChck = false;
  bool _nicknameDup = false;
  bool _canSubmit = false;

  final emailController = TextEditingController();
  final nickController = TextEditingController();
  final ageController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),
          onPressed: () { Navigator.pop(context);},
          color: Colors.black,
          iconSize: 25,
        ),
        titleSpacing: 3,
        title: Text(
          '회원가입',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        actions: [],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        color: Colors.white,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(25),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  enabled: true,
                  controller: emailController,
                  //initialValue: _email,
                  autovalidateMode: AutovalidateMode.always,
                  onSaved: (value) {
                    setState(() {
                      _email = value as String;
                    });
                  },
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return '이메일을 입력해주세요.';
                    }
                    return null;
                  },
                  style: TextStyle(
                      color: Colors.grey
                  ),
                  decoration: InputDecoration(
                    labelText: '이메일',
                    labelStyle: TextStyle(
                        color: Colors.black87,
                        fontSize: 16
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(width: 1, color: Color(0xff005766)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(width: 1, color: Colors.redAccent),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
                SizedBox(height: 50),
                TextFormField(
                  enabled: true,
                  controller: nickController,
                  //initialValue: _nickname,
                  autovalidateMode: AutovalidateMode.always,
                  onChanged: (value) {
                    _nicknameDupChck = false;
                    _nicknameDup = false;
                  },
                  onSaved: (value) {
                    setState(() {
                      _nickname = value as String;
                    });
                  },
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return '닉네임을 입력해주세요.';
                    }

                    if(!_nicknameDupChck) {
                      return '닉네임 중복을 확인해 주세요.';
                    }

                    if(_nicknameDup) {
                      return '중복된 닉네임 입니다.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    //filled: true,
                    //fillColor: Color(0xffff005766)
                    labelText: '닉네임',
                    labelStyle: TextStyle(
                        color: Colors.black87,
                        fontSize: 16
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(width: 1, color: Color(0xff005766)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(width: 1, color: Colors.black54),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                  style: TextStyle(
                      color: Colors.black87
                  ),
                ),
                GFButton(
                  onPressed: () async {
                    _nicknameDup = await requestNicknameDupChck(nickController.text);
                    setState(() {
                      _nicknameDupChck = true;
                      log("$_nicknameDup");
                    });
                  },
                  text: "중복 확인",
                  shape: GFButtonShape.square,
                ),
                SizedBox(height: 50),
                TextFormField(
                  enabled: true,
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.always,
                  onSaved: (value) {
                    setState(() {
                      _age = value as String;
                    });
                  },
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return '나이를 입력해주세요.';
                    }
                    return null;
                  },
                  style: TextStyle(
                      color: Colors.black87
                  ),
                  decoration: InputDecoration(
                      labelText: '나이',
                      labelStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 16
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(width: 1, color: Color(0xff005766)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(width: 1, color: Colors.black54),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      suffixIcon: IconButton(icon: Icon(Icons.info),
                        onPressed: () {},
                        color: Colors.black45,
                        iconSize: 25,
                        tooltip: '나이와 성별은 추천 기능에 사용됩니다.',
                      )
                  ),
                ),
                SizedBox(height: 50),
                Row(
                  children: [
                    Text(
                      '성별',
                      style: TextStyle(
                          fontFamily: 'NanumBarunGothicLight',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87
                      ),
                    ),
                  ],
                ),
                RadioListTile(
                  title: Text('남자'),
                  value: Gender.male,
                  groupValue: _gender,
                  onChanged: (value) {
                    setState(() {
                      _gender = value as Gender;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('여자'),
                  value: Gender.female,
                  groupValue: _gender,
                  onChanged: (value) {
                    setState(() {
                      _gender = value as Gender;
                    });
                  },
                ),
                SizedBox(height: 50),
                ElevatedButton(
                  onPressed: _canSubmit && !_nicknameDup ? () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      join();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('입력사항을 다시 확인해주세요.'), backgroundColor: Colors.redAccent,),
                      );
                    }
                  } : null,
                  child: Text('가입하기', style: TextStyle(fontSize: 21),),
                  style: ElevatedButton.styleFrom(
                    //primary: Color(0xff005766),
                    minimumSize: const Size.fromHeight(50)
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(height: 0.0, color: Colors.white,),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    nickController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _email = widget.email;

    emailController.addListener(validateForm);
    nickController.addListener(validateForm);
    ageController.addListener(validateForm);
    emailController.text = _email;
    nickController.text = _nickname;
    ageController.text = _age;

    // print("회원가입 화면" + widget.email + "/" + widget.nickname);
    // print("회원가입 화면" + widget.accessToken + "/" + widget.refreshToken!);
  }

  // 입력사항 확인
  // 모두 정상 입력 시 '가입하기' 버튼 활성화
  void validateForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _canSubmit = true;
      });
    }
  }

  // 가입 요청
  void join() async {
    // request post
    String joinUrl = "";
    String apiHost = getAPIHost();
    joinUrl = apiHost + "/user/join.tipsy";

    final Uri url = Uri.parse(joinUrl);

    int gender = 0;
    if(_gender == Gender.male) {
      gender = 1;
    } else {
      gender = 2;
    }

    var bodyData = {
      "platform": widget.platform,
      "social_id": widget.socialId,
      "email": emailController.text,
      "nickname": nickController.text,
      "age": ageController.text,
      "gender": gender
    };

    log("Join Body Data:[${bodyData}]");
    http.Response response = await http.post(
      url,
      headers: <String, String> {
        'Content-Type': 'application/json',
      },
      body: json.encode(bodyData),
    );

    if (response.statusCode == 200) {

      // 회원가입 결과 데이터 확인
      String resString = response.body.toString();
      var parsed = json.decode(resString);
      var parsedData = parsed['data'];
      log("parsed join result data: $parsedData");

      dialogBuilder(context, "환영합니다!", parsedData['nickname'] + " 님 회원가입을 완료했습니다.");

      // 1. 토큰 발급
      AccessToken? token = null;
      try {
        token = await requestAccessToken(widget.platform, _email, '');
      } catch(e) {
        token = null;
      }
      
      if(token != null && token.tokenHash.length > 0) {

        // 2. 자동 로그인 처리
        bool isLogin = await autoLogin(widget.platform, widget.email, token.tokenHash);

        if(isLogin) {
          final storage = new FlutterSecureStorage();
          await storage.write(key:'accessToken', value:token.tokenHash);
          await storage.write(key:'platform', value:widget.platform.toString());
          await storage.write(key:'id', value:token.userId.toString());
          await storage.write(key:'email', value:widget.email);
          goToMainPage(context);
        } else {
          throw Exception('Failed auto login.');
        }
      } else {
        throw Exception('Failed isuue access token.');
      }

      // TODO: Add loading logo

    } else {
      // 회원가입 실패에 대한 메시지
      showErrorToast("회원가입에 실패했습니다. 다시 시도해 주세요.");
      throw Exception('Failed to join.');
    }

  }

}