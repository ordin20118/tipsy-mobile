import 'package:flutter/material.dart';
import 'package:tipsy_mobile/ui/form.dart';
import 'package:tipsy_mobile/classes/user.dart';

class JoinPage extends StatefulWidget {
  const JoinPage({Key? key, required this.platform, required this.email, required this.nickname,
                            required this.accessToken, required this.refreshToken}) : super(key: key);

  final int platform;
  final String email;
  final String nickname;
  final String accessToken;
  final String refreshToken;

  @override
  _JoinPageState createState() => _JoinPageState();
}


class _JoinPageState extends State<JoinPage> {

  Gender _gender = Gender.male;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 3,
        title: Text('회원가입'),
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
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    '이메일',
                    style: TextStyle(
                        fontFamily: 'NanumBarunGothicLight',
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey
                    ),
                  ),
                ],
              ),
              TextFormField(
                enabled: false,
                initialValue: widget.email,
                style: TextStyle(
                  color: Colors.grey
                ),
              ),
              SizedBox(height: 50),
              Row(
                children: [
                  Text(
                    '닉네임',
                    style: TextStyle(
                        fontFamily: 'NanumBarunGothicLight',
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey
                    ),
                  ),
                ],
              ),
              TextFormField(
                enabled: true,
                initialValue: widget.nickname,
                style: TextStyle(
                    color: Colors.grey
                ),
              ),
              SizedBox(height: 50),
              Row(
                children: [
                  Text(
                    '나이',
                    style: TextStyle(
                        fontFamily: 'NanumBarunGothicLight',
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey
                    ),
                  ),
                  Tooltip(
                    triggerMode: TooltipTriggerMode.tap,
                    showDuration: const Duration(seconds: 1),
                    message: '나이와 성별은 추천 기능에 사용됩니다.',
                    child: const Text(
                      ' ⓘ',
                      style: TextStyle(
                          fontFamily: 'NanumBarunGothicLight',
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey
                      ),),
                  ),
                ],
              ),
              TextFormField(
                enabled: true,
                style: TextStyle(
                    color: Colors.grey
                ),
              ),
              SizedBox(height: 50),
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



            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(height: 0.0),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    print("회원가입 화면" + widget.email + "/" + widget.nickname);
    print("회원가입 화면" + widget.accessToken + "/" + widget.refreshToken);
  }
}