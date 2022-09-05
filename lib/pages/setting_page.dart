import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
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
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),
          onPressed: () { Navigator.pop(context);},
          color: Colors.black,
          iconSize: 25,
        ),
        title: Text('설정', style: TextStyle(color: Color(0xff005766), fontFamily: 'NanumBarunGothicBold')),
        //backgroundColor: Color(0xff005766),
        backgroundColor: Color(0xffffffff),
        actions: [],
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.07,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Text(
                      "로그아웃",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'NanumBarunGothicUltraLight'
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.6),
                    IconButton(icon: Icon(Icons.arrow_forward_ios),
                      onPressed: () {},
                      color: Colors.black,
                      iconSize: 18,
                    )
                  ],
                ),
              ),
            ),
            Container(
              height:1.0,
              //width:500.0,
              color:Colors.black12,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.07,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Text(
                      "회원탈퇴",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'NanumBarunGothicUltraLight'
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.6),
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
