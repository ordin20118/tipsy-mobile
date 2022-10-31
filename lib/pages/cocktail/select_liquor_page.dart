
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tipsy_mobile/classes/liquor.dart';
import 'package:tipsy_mobile/classes/util.dart';
import 'package:tipsy_mobile/classes/ui_util.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SelectLiquorPage extends StatefulWidget {
  const SelectLiquorPage({Key? key}) : super(key: key);

  @override
  _SelectLiquorPageState createState() => _SelectLiquorPageState();
}

class _SelectLiquorPageState extends State<SelectLiquorPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.transparent,
      body:
      BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child:
          Center(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black45,
                  width:1,
                ),
                borderRadius: BorderRadius.circular(0),
                color: Colors.white,
              ),
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.8,
              child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Card(
                        color: Color(0x99005766),
                        shape: RoundedRectangleBorder(
                            borderRadius: const BorderRadius.all(const Radius.circular(10.0))
                        ),
                        elevation: 4.0, // 그림자 깊이
                        child: InkWell(
                          onTap: () {
                          },
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.25,
                            height: MediaQuery.of(context).size.width * 0.25,
                            child: Center(child: Text('주류', style: boxMenuWhite)),
                          ),
                        ),
                      ),
                      Card(
                        color: Color(0xffffbb00),
                        shape: RoundedRectangleBorder(
                            borderRadius: const BorderRadius.all(const Radius.circular(10.0))
                        ),
                        elevation: 4.0, // 그림자 깊이
                        child: InkWell(
                          onTap: () {
                            // TODO: open select ingredient screen
                          },
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.25,
                            height: MediaQuery.of(context).size.width * 0.25,
                            child: Center(child: Text('재료', style: boxMenuWhite)),
                          ),
                        ),
                      ),
                      Card(
                        color: Color(0xff783712),
                        shape: RoundedRectangleBorder(
                            borderRadius: const BorderRadius.all(const Radius.circular(10.0))
                        ),
                        elevation: 4.0, // 그림자 깊이
                        child: InkWell(
                          onTap: () {
                            // TODO: open select equipment screen
                          },
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.25,
                            height: MediaQuery.of(context).size.width * 0.25,
                            child: Center(child: Text('장비', style: boxMenuWhite)),
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: RaisedButton(
                      //     onPressed: () {
                      //       Navigator.pop(context, 'Yep!');
                      //     },
                      //     child: Text('Yep!'),
                      //   ),
                      // ),
                    ],
                  )
              ),
            ),
          )
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
    print("[[ 칵테일 재료 선택 페이지 ]]");
  }


}