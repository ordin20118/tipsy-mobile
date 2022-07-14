import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:tipsy_mobile/classes/liquor.dart';
import 'package:tipsy_mobile/classes/ingredient.dart';
import 'package:tipsy_mobile/classes/response.dart';
import 'package:tipsy_mobile/classes/styles.dart';
import 'package:tipsy_mobile/pages/liquor_page.dart';
import 'package:http/http.dart' as http;


enum SearchTarget {
  all, liquor, ingredient, equipment
}

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}


// search request function
Future<SearchResult> searchRequest(keyword, SearchTarget target, categLv, categId) async {

  print("#### [searchhLiquor] ####");
  String searchUrl = "http://www.tipsy.co.kr/svcmgr/api/search.tipsy?target=";

  if(target == SearchTarget.all) {
    searchUrl += "all";
  } else if(target == SearchTarget.liquor) {
    searchUrl += "liquor";
  } else if(target == SearchTarget.ingredient) {
    searchUrl += "ingredient";
  } else if(target == SearchTarget.equipment) {
    searchUrl += "equipment";
  }

  if(keyword != null && keyword.length > 0) {
    searchUrl += "&keyword=" + keyword;
  }

  if(categLv != null && categLv > 0) {
    searchUrl += "&categLv=" + categLv;
  }

  if(categId != null && categId > 0) {
    searchUrl += "&categId=" + categId;
  }

  final Uri url = Uri.parse(searchUrl);

  print("URL: $url");

  final response = await http.get(url);

  if (response.statusCode == 200) {
    // 만약 서버로의 요청이 성공하면, JSON을 파싱합니다.
    String resString = response.body.toString();

    // response{} => data{} => liquor_list[]
    var parsed = json.decode(resString);

    var parsedData = parsed['data'];
    print("parsed data: $parsedData");

    var liquorListRes = parsedData['liquor_list'];
    var ingdListRes = parsedData['ingredient_list'];

    //print("\n\nliquor list response: $liquorListRes");
    //print("\n\ingredient list response: $ingdListRes");

    SearchResult searchRes = new SearchResult();

    LiquorList liquorList = new LiquorList();
    if(liquorListRes != null) {
      liquorList = LiquorList.fromJson(liquorListRes);
      searchRes.liquorList = liquorList.liquors;
    }

    IngdList ingdList = new IngdList();
    if(ingdListRes != null) {
      ingdList = IngdList.fromJson(ingdListRes);
      searchRes.ingredientList = ingdList.ingredients;
    }

    // print("검색 결과의 주류 개수:" + searchRes.liquorList.length.toString());
    // print("검색 결과의 재료 개수:" + searchRes.ingredientList.length.toString());
    // for(int i=0; i<searchRes.liquorList.length; i++) {
    //   Liquor item = searchRes.liquorList[i];
    //   print("[$i] " + item.nameKr);
    // }
    // for(int i=0; i<searchRes.ingredientList.length; i++) {
    //   Ingredient item = searchRes.ingredientList[i];
    //   print("[$i] " + item.nameKr);
    // }

    return searchRes;
  } else {
    // 만약 요청이 실패하면, 에러를 던집니다.
    throw Exception('Failed to load liquor data.');
  }
}

class _SearchPageState extends State<SearchPage> {

  List<Liquor> gridLiquorList = [];
  List<Ingredient> gridIngdList = [];

  int _searchState = 0;

  // 검색창 내용 controller
  TextEditingController searchTextController = TextEditingController();

  /*
    검색 상태에 따른 페이지 반환 함수
      _searchState:0 => 검색 결과 없음 페이지
      _searchState:1 => 검색 결과 페이지
      _searchState:3 => 자동완성 페이지
   */
  Widget selectWidget() {
    if(_searchState == 0) {
      return NoSearchRes();
    } else if(_searchState == 1) {
      return SearchResTab(gridLiquorList: gridLiquorList, gridIngdList: gridIngdList,);
    } else if(_searchState == 2) {
      return NoSearchRes();
    }
    return NoSearchRes();
  }

  // 검색 실행
  submitSearch(keyword) async {
    print("Search Keyord: " + keyword);
    SearchResult res = await searchRequest(keyword, SearchTarget.all, null, null);
    print("liquor count: " + res.liquorList.length.toString());
    print("ingd count: " + res.ingredientList.length.toString());

    if(res.liquorList.length <= 0 && res.ingredientList.length <= 0 && res.equipmentList.length <= 0) {
      setState(() {
        _searchState = 0;
      });
    } else {
      setState(() {
        _searchState = 1;
      });
    }

    gridLiquorList = [];
    for(int i=0; i<res.liquorList.length; i++) {
      Liquor item = res.liquorList[i];
      gridLiquorList.add(item);
    }
  }

  // x 클릭 시 검색어 삭제
  emptySearchField() {
    searchTextController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 3,
        title: TextFormField(
          cursorHeight: 15,
          controller: searchTextController,
          decoration: InputDecoration(
              hintText: '검색어를 입력해주세요.',
              hintStyle: TextStyle(
                color: Colors.grey
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 2.0),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              filled: false,
              suffixIcon: IconButton(icon: Icon(Icons.clear, color: Colors.blueGrey,),
                  onPressed: emptySearchField)
          ),
          style: TextStyle(
            color: Colors.black87
          ),
          onFieldSubmitted: submitSearch,
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
        child: selectWidget(),
      ),
      bottomNavigationBar: Container(height: 0.0),
    );
  }



  // Widget buildSearchResultScroll(BuildContext context) {
  //   return CustomScrollView(
  //       slivers: [
  //         // SliverAppBar #1 - liquor
  //         SliverAppBar(
  //           automaticallyImplyLeading: false,
  //           elevation: 5,
  //           pinned: true,
  //           backgroundColor: Colors.pink,
  //           expandedHeight: 170.0,
  //           flexibleSpace: FlexibleSpaceBar(
  //             background: Container(
  //               color: Colors.amber,
  //               child: const Center(
  //                   child: Icon(
  //                     Icons.run_circle,
  //                     size: 60,
  //                     color: Colors.white,
  //                   )),
  //             ),
  //             title: const Text(
  //               'Liquor',
  //               style: TextStyle(color: Colors.white),
  //             ),
  //           ),
  //         ),
  //         // SliverGrid #1
  //         SliverGrid(
  //           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //             crossAxisCount: 2,
  //             mainAxisSpacing: 10,
  //             crossAxisSpacing: 10,
  //             childAspectRatio: 2.0,
  //           ),
  //           delegate: SliverChildBuilderDelegate((context, index) {
  //               return Card(
  //                 // generate ambers with random shades
  //                 color: Colors.amber[Random().nextInt(9) * 100],
  //                 child: Container(
  //                   alignment: Alignment.center,
  //                   child: Text(widget.gridLiquorList[index].nameKr),
  //                 ),
  //               );
  //             },
  //             childCount: gridLiquorList.length,
  //           ),
  //         ),
  //         // SliverAppBar #2 - ingredient
  //         SliverAppBar(
  //           automaticallyImplyLeading: false,
  //           elevation: 5,
  //           pinned: true,
  //           backgroundColor: Colors.green,
  //           expandedHeight: 170.0,
  //           flexibleSpace: FlexibleSpaceBar(
  //             background: Container(
  //               color: Colors.lightGreen,
  //               child: const Center(
  //                   child: Icon(
  //                     Icons.run_circle,
  //                     size: 60,
  //                     color: Colors.white,
  //                   )),
  //             ),
  //             title: const Text(
  //               'Ingredient',
  //               style: TextStyle(color: Colors.white),
  //             ),
  //           ),
  //         ),
  //         // SliverGrid #2 - ingredient
  //         SliverGrid(
  //           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //             crossAxisCount: 2,
  //             mainAxisSpacing: 10,
  //             crossAxisSpacing: 10,
  //             childAspectRatio: 2.0,
  //           ),
  //           delegate: SliverChildBuilderDelegate(
  //                 (context, index) {
  //               return Card(
  //                 // generate ambers with random shades
  //                 color: Colors.amber[Random().nextInt(9) * 100],
  //                 child: Container(
  //                   alignment: Alignment.center,
  //                   //child: Text(_gridItems[index]),
  //                   child: Text('!'),
  //                 ),
  //               );
  //             },
  //             //childCount: _gridItems.length,
  //             childCount: 1,
  //           ),
  //         ),
  //       ]
  //   );
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

}

class SearchResTab extends StatefulWidget {
  SearchResTab({Key? key, required this.gridLiquorList, required this.gridIngdList}) : super(key: key);

  List<Liquor> gridLiquorList;
  List<Ingredient> gridIngdList;

  @override
  _SearchResTabState createState() => _SearchResTabState();
}

class _SearchResTabState extends State<SearchResTab> with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 4,
        vsync: this
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  late TabController _tabController;
  TabBar get _tabBar => TabBar(
    labelColor: Color(0xff005766),
    unselectedLabelColor: Colors.grey,
    indicatorColor: Color(0xff005766),
    controller: _tabController,
    tabs: const <Widget>[
      Tab(
        text: '주류',
      ),
      Tab(
        text: '칵테일',
      ),
      Tab(
        text: '재료',
      ),
      Tab(
        text: '용어',
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: _tabBar.preferredSize,
        child: Material(
          color: Color(0xffffffff),
          child: _tabBar,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Center(
            child: LiquorGridView(gridLiquorList: widget.gridLiquorList),
          ),
          Center(
            child: Text("It's rainy here"),
          ),
          Center(
            child: Text("It's sunny here"),
          ),
          Center(
            child: NoSearchRes(),
          ),
        ],
      ),
      bottomNavigationBar: Container(height: 0.0,),
    );
  }

}

//class
class LiquorGridView extends StatefulWidget {
  LiquorGridView({Key? key, required this.gridLiquorList}) : super(key: key);

  List<Liquor> gridLiquorList;

  @override
  _LiquorGridViewState createState() => _LiquorGridViewState();
}

class _LiquorGridViewState extends State<LiquorGridView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget liquorItemBuilder(context, index) {

    // http://tipsy.co.kr/svcmgr/api/image/1.tipsy
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LiquorDetail(liquorId: widget.gridLiquorList[index].liquorId)),
        );
      },
      child: Card(
        // generate ambers with random shades
        color: Colors.amber[Random().nextInt(9) * 100],
        child: Container(
          height: MediaQuery.of(context).size.height * 0.3,
          alignment: Alignment.center,
          child: Column(
            children: [
              Image.network(
                'http://tipsy.co.kr/svcmgr/api/image/1.tipsy',
                width: MediaQuery.of(context).size.width * 0.25,
              ),
              Text(widget.gridLiquorList[index].nameKr)
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20
            ),
            itemCount: widget.gridLiquorList.length,
            itemBuilder: (BuildContext context, index) {
              return liquorItemBuilder(context, index);
            }
        ),
      ),
    );
  }
}



// 검색 결과 없음 Widget
class NoSearchRes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('검색 결과가 없습니다.', style: TextStyle(color: Colors.grey),),
      ),
    );
  }
}
