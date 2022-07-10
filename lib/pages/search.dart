import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tipsy_mobile/classes/liquor.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  // search function
  Future<Liquor> searchhLiquor() async {
    print("#### [searchhLiquor] ####");

    final searchUrl = "http://www.tipsy.co.kr/svcmgr/api/search.tipsy?keyword=잭다니엘&target=all";
    final Uri url = Uri.parse(searchUrl);

    print("URL: $url");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      // 만약 서버로의 요청이 성공하면, JSON을 파싱합니다.
      String resString = response.body.toString();
      print("api result is $resString");

      // response{} => data{} => liquor_list[]
      var parsed = json.decode(resString);

      var parsedData = parsed['data'];
      print("parsed data: $parsedData");

      var liquorListRes = parsedData['liquor_list'];
      var ingredientList = parsedData['ingredient_list'];
      print("parsed liquorList: $liquorListRes");
      print("parsed ingredientList: $ingredientList");
      if(ingredientList == null) {
        print("재료는 검색된게 없네요");
      }

      LiquorList liquorList = LiquorList.fromJson(liquorListRes);

      // for(int i=0; i<liquorList.liquors.length; i++) {
      //   Liquor item = liquorList.liquors[i];
      //   print("[$i] " + item.nameKr);
      // }

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

  @override
  void initState() {
    super.initState();
    searchhLiquor();
  }

  @override
  void dispose() {
    super.dispose();
  }

}
