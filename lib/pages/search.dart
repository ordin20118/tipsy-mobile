import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tipsy_mobile/classes/liquor.dart';
import 'package:http/http.dart' as http;

class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);

  Future<Liquor> searchhLiquor() async {

    final searchUrl = "http://www.tipsy.co.kr/svcmgr/api/search.tipsy?keyword=레몬&target=all";
    final Uri url = Uri.parse(searchUrl);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // 만약 서버로의 요청이 성공하면, JSON을 파싱합니다.
      return Liquor.fromJson(json.decode(response.body));
    } else {
      // 만약 요청이 실패하면, 에러를 던집니다.
      throw Exception('Failed to load liquor data.');
    }
  }

  static TextStyle boxMenuWhite = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold
  );

  static TextStyle boxMenuDark = TextStyle(
      color: Color(0xff5D5D5D),
      fontWeight: FontWeight.bold
  );


  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // SliverAppBar #1
        SliverAppBar(
          pinned: true,
          backgroundColor: Colors.green,
          expandedHeight: 200.0,
          elevation: 1,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
            color: Colors.deepOrange,
            child: const Center(
            child: Icon(
            Icons.favorite,
            size: 70,
            color: Colors.yellow,
            )),
            ),
            title: const Text(
            'First SliverAppBar',
            style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        // SliverGrid #2 (with dynamic content)
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.0,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Card(
                // generate ambers with random shades
                color: Colors.amber[Random().nextInt(9) * 100],
                child: Container(
                  alignment: Alignment.center,
                  //child: Text(_gridItems[index]),
                  child: Text("!"),
                ),
              );
            },
            //childCount: _gridItems.length,
            childCount: 1,
          ),
        ),
    ]
  );
}


