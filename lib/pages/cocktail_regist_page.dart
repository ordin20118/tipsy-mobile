import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tipsy_mobile/classes/styles.dart';
import 'package:tipsy_mobile/classes/util.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:getwidget/getwidget.dart';

import 'join_page.dart';
import 'package:tipsy_mobile/classes/util.dart';
import 'package:tipsy_mobile/classes/ui_util.dart';

class CocktailRegistPage extends StatefulWidget {
  const CocktailRegistPage({Key? key}) : super(key: key);

  @override
  _CocktailRegistPageState createState() => _CocktailRegistPageState();
}

class _CocktailRegistPageState extends State<CocktailRegistPage> {

  final _formKey = GlobalKey<FormState>();

  bool _canSubmit = false;

  String _nameKr = '';
  String _nameEn = '';
  String _method = '블렌딩';
  int _strength = -1;
  List<String> _methodList = <String>["블렌딩", "스터링", "플로팅", "쉐이크", "빌드"];
  List<bool> _checkedColorList = List.filled(cocktailColors.length, true);
  Map checkedColorMap = Map.fromIterable(cocktailColors, key: (colorCode) => colorCode, value: (colorCode) => false);
  bool isChecked = false;   // for test

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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.width * 0.5,
                        child: Image.asset('assets/images/default_image.png'),
                      )
                    ],
                  ),
                ),
                TextFormField(
                  enabled: true,
                  style: TextStyle(
                      color: Colors.grey
                  ),
                  decoration: InputDecoration(
                    labelText: '한글 이름',
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
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                TextFormField(
                  enabled: true,
                  style: TextStyle(
                      color: Colors.grey
                  ),
                  decoration: InputDecoration(
                    labelText: '영문 이름',
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
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 중복 확인 button
                    Card(
                      color: Color(0xffC98AFF),
                      shape: RoundedRectangleBorder(
                          borderRadius: const BorderRadius.all(const Radius.circular(10.0))
                      ),
                      elevation: 4.0, // 그림자 깊이
                      child: InkWell(
                        onTap: () {

                        },
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: MediaQuery.of(context).size.height * 0.08,
                          child: Center(child: Text('중복 확인', style: boxMenuWhite)),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "알코올 등급",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    // TODO: Add RadioButton for strength

                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "색상 (다중 선택 가능)",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    // Add CheckBox for color
                    makeColorCheckBoxList()
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "제조 방식",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    // TODO: Add DropDownBox for method
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      //height: MediaQuery.of(context).size.height * 0.05,
                      child: DropdownButtonHideUnderline(
                        child: GFDropdown(
                          padding: const EdgeInsets.all(10),
                          borderRadius: BorderRadius.circular(10),
                          border: const BorderSide(
                              color: Colors.black12, width: 1),
                          dropdownButtonColor: Colors.grey[300],
                          onChanged: (newValue) {
                            setState(() {
                              String nv = newValue!.toString();
                              log("newValue:"+nv);
                              _method = newValue as String;
                            });
                          },
                          value: _method,
                          items: _methodList.map((value) => DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          )).toList(),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "재료",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16
                          ),
                        ),
                      ],
                    ),
                    // TODO: Add Button for ingredients

                    // TODO: Add horizontal list view for selected ingredients

                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "레시피",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16
                          ),
                        ),
                      ],
                    ),
                    // TODO: Add vertical list view for recipe

                    // TODO: Add '+' button for input popup

                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                ElevatedButton(
                  onPressed: _canSubmit ? () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      // TODO: 등록 요청
                      //join();

                      // for debug
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(content: Text(_email + '/' + _nickname + '/' + _age.toString() + '/' + _gender.toString())),
                      // );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('입력사항을 다시 확인해주세요.'), backgroundColor: Colors.redAccent,),
                      );
                    }
                  } : null,
                  child: Text('칵테일 등록', style: TextStyle(fontSize: 21),),
                  style: ElevatedButton.styleFrom(
                      primary: Color(0xff005766),
                      minimumSize: const Size.fromHeight(50)
                  ),
                )
              ],
            ),
          )
        ),
      ),
      bottomNavigationBar: Container(height: 0),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // TODO: controller 등록
  }

  // 색상 선택 체크박스 자동 생성
  Column makeColorCheckBoxList() {
    List<Row> rowList = [];
    List<String> tmpColorList = [];

    for(int i=0; i<cocktailColors.length; i++) {

      tmpColorList.add(cocktailColors[i]);
      if(i%5 == 4) {
        List<GFCheckbox> chBoxList = tmpColorList.map((colorCode) => GFCheckbox(
          inactiveBgColor: HexColor(colorCode),
          activeBgColor: HexColor(colorCode),
          onChanged: (value) {
            setState(() {
              print(colorCode + ":" + value.toString());
              print("before:"+checkedColorMap[colorCode].toString());
              checkedColorMap[colorCode] = value;
              print("after:"+checkedColorMap[colorCode].toString());
            });
          },
          value: checkedColorMap[colorCode],
          inactiveIcon: null,
        )).toList();
        rowList.add(Row(children: chBoxList,));
        tmpColorList.clear();
      }
    }

    if(tmpColorList.length > 0) {
      List<GFCheckbox> chBoxList = tmpColorList.map((colorCode) => GFCheckbox(
        inactiveBgColor: HexColor(colorCode),
        activeBgColor: HexColor(colorCode),
        onChanged: (value) {
          setState(() {
            print(colorCode + ":" + value.toString());
            print("before:"+checkedColorMap[colorCode].toString());
            checkedColorMap[colorCode] = value;
            print("after:"+checkedColorMap[colorCode].toString());
          });
        },
        value: checkedColorMap[colorCode],
        inactiveIcon: null,
      )).toList();
      rowList.add(Row(children: chBoxList,));
      tmpColorList.clear();
    }
    return Column(children: rowList);
  }

  // 입력사항 확인
  // 모두 정상 입력 시 '칵테일 등록' 버튼 활성화
  void validateForm() {
    print("validateForm");
    if (_formKey.currentState!.validate()) {
      print("validate ok");
      setState(() {
        _canSubmit = true;
      });
    }
  }
}
