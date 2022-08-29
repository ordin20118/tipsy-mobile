import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tipsy_mobile/classes/styles.dart';
import 'package:tipsy_mobile/classes/util.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'join_page.dart';

class CocktailRegistPage extends StatefulWidget {
  const CocktailRegistPage({Key? key}) : super(key: key);

  @override
  _CocktailRegistPageState createState() => _CocktailRegistPageState();
}

class _CocktailRegistPageState extends State<CocktailRegistPage> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),
          onPressed: () { Navigator.pop(context);},
          color: Colors.black,
          iconSize: 25,
        ),
        titleSpacing: 3,
        title: Text(
          '나만의 칵테일 등록',
          style: boldTextBlack,
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.bolt),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => JoinPage(platform:1, email:'111', nickname: '222', accessToken: '333', refreshToken: '444')),
              );
            },
            color: Color(0xff005766),
            iconSize: 22,
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.width * 0.5,
                      child: Image.asset('assets/images/default_image.png'),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(

                      //width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.width * 0.5,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text('재료 추가'),
                      ),
                    )
                  ],
                ),

              ],
            ),
          )
        ),
      ),
      bottomNavigationBar: Container(height: 0),
    );
  }
}
