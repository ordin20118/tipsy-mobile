import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:tipsy_mobile/classes/ui_util.dart';
import 'package:tipsy_mobile/classes/util.dart';
import 'package:tipsy_mobile/classes/styles.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('설정', style: TextStyle(color: Color(0xff005766), fontFamily: 'NanumBarunGothicBold')),
        //backgroundColor: Color(0xff005766),
        backgroundColor: Color(0xffffffff),
        actions: [],
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.07,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "내 정보 수정",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'NanumBarunGothicUltraLight'
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.59),
                    IconButton(icon: Icon(Icons.arrow_forward_ios),
                      onPressed: () async {
                        dialogBuilder(context, '알림', '내 정보 수정은 준비중입니다.🥲');
                      },
                      color: Colors.black,
                      iconSize: 18,
                    )
                  ],
                ),
              ),
            ),
            Divider(
              height: 0.1,
              thickness: 0.3,
              color: Colors.grey,
              indent: 3,
              endIndent: 3,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.07,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "로그아웃",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'NanumBarunGothicUltraLight'
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.59),
                    IconButton(icon: Icon(Icons.arrow_forward_ios),
                      onPressed: () async {
                        bool isLogout = await logout(context);
                        if(isLogout) {
                          goToLoginPageReplace(context);
                        }
                      },
                      color: Colors.black,
                      iconSize: 18,
                    )
                  ],
                ),
              ),
            ),
            Divider(
              height: 0.1,
              thickness: 0.3,
              color: Colors.grey,
              indent: 3,
              endIndent: 3,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.07,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "회원탈퇴",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'NanumBarunGothicUltraLight'
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.59),
                    IconButton(icon: Icon(Icons.arrow_forward_ios),
                      onPressed: () {},
                      color: Colors.black,
                      iconSize: 18,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(height: 0,),
    );
  }
}

