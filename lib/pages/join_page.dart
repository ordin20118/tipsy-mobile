import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tipsy_mobile/ui/form.dart';
import 'package:tipsy_mobile/classes/user.dart';

class JoinPage extends StatefulWidget {
  JoinPage({Key? key, required this.platform, required this.email, required this.nickname,
                            required this.accessToken, required this.refreshToken}) : super(key: key);

  final int platform;
  final String email;
  final String nickname;
  final String accessToken;
  final String refreshToken;

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

  bool _canSubmit = false;

  final nickController = TextEditingController();
  final ageController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 3,
        title: Text(
          '회원가입',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        actions: [],
        leading: GestureDetector(
          child: Icon( Icons.arrow_back_ios, color: Colors.black, ),
          onTap: () {
            Navigator.pop(context);
          } ,
        ),
        leadingWidth: MediaQuery.of(context).size.width * 0.1,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        color: Colors.white,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(25),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  enabled: false,
                  initialValue: _email,
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
                  onSaved: (value) {
                    setState(() {
                      _nickname = value as String;
                    });
                  },
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return '닉네임을 입력해주세요.';
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
                  onPressed: _canSubmit ? () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      join();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(_email + '/' + _nickname + '/' + _age.toString() + '/' + _gender.toString())),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('입력사항을 다시 확인해주세요.'), backgroundColor: Colors.redAccent,),
                      );
                    }
                  } : null,
                  child: Text('가입하기', style: TextStyle(fontSize: 21),),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff005766),
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
    nickController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _email = widget.email;
    _nickname = widget.nickname;

    nickController.addListener(validateForm);
    ageController.addListener(validateForm);
    nickController.text = _nickname;
    ageController.text = _age;

    print("회원가입 화면" + widget.email + "/" + widget.nickname);
    print("회원가입 화면" + widget.accessToken + "/" + widget.refreshToken);
  }

  // 입력사항 확인
  // 모두 정상 입력 시 '가입하기' 버튼 활성화
  void validateForm() {
    print("validateForm");
    if (_formKey.currentState!.validate()) {
      print("validate ok");
      setState(() {
        _canSubmit = true;
      });
    }
  }

  // 가입 요청
  void join() async {

    print("[[Enter join function]]");

    // request post
    String chckUrl = "http://www.tipsy.co.kr/svcmgr/api/user/join.tipsy";
    final Uri url = Uri.parse(chckUrl);

    int gender = 0;
    if(_gender == Gender.male) {
      gender = 1;
    } else {
      gender = 2;
    }

    var bodyData = {
      "platform": widget.platform,
      "email": _email,
      "nickname": _nickname,
      "age": _age,
      "gender": gender,
      "access_token": widget.accessToken,
      "refresh_token": widget.refreshToken
    };

    http.Response response = await http.post(
      url,
      headers: <String, String> {
        'Content-Type': 'application/json',
      },
      body: json.encode(bodyData),
    );

    if (response.statusCode == 200) {

      // TODO
      // 1.로그인 처리
      // 1-1.로그인 요청 (플랫폼의 엑세스 토큰으로)
      // 1-2.서비스 내부 엑세스 토큰 발급 받음
      // 1-3. 로컬 저장소에 로그인 정보 저장
      //  - 자동로그인 여부
      //  - 자동로그인 플랫폼
      //  - 계정ID => 대신에 서비스 내의 토큰
      // 2.메인 페이지로 이동

      // TODO: Add loading icon

    } else {
      // TODO: toast
      print("" + response.body);
      throw Exception('Failed to join.');
    }

  }

}