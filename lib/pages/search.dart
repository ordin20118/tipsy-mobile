import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:tipsy_mobile/classes/liquor.dart';
import 'package:tipsy_mobile/classes/equipment.dart';
import 'package:tipsy_mobile/classes/ingredient.dart';
import 'package:tipsy_mobile/classes/response.dart';
import 'package:tipsy_mobile/classes/styles.dart';
import 'package:tipsy_mobile/pages/liquor_page.dart';
import 'package:tipsy_mobile/classes/util.dart';
import 'package:tipsy_mobile/pages/collector/equip_view.dart';
import 'package:http/http.dart' as http;

import '../classes/ui_util.dart';
import '../classes/word.dart';
import 'collector/ingredient_view.dart';
import 'collector/word_view.dart';


enum SearchTarget {
  all, liquor, ingredient, equipment, word
}

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  List<Liquor> gridLiquorList = [];
  List<Ingredient> ingdList = [];
  List<Equipment> equipList = [];
  List<Word> wordList = [];

  var searchParam;
  int _searchState = 0;

  // 검색창 내용 controller
  TextEditingController searchTextController = TextEditingController();

  // 검색 결과 controller
  LiquorScrollController liquorScrollController = Get.put<LiquorScrollController>(LiquorScrollController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),
          onPressed: () { Navigator.pop(context);},
          color: Colors.black,
          iconSize: 25,
        ),
        //leadingWidth: MediaQuery.of(context).size.width * 0.1,
        titleSpacing: 3,
        elevation: 0.1,
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
      ),
      body: Container(
        child: selectWidget(),
      ),
      bottomNavigationBar: Container(height: 0.0),
    );
  }


  /*
    검색 상태에 따른 페이지 반환 함수
      _searchState:0 => 검색 결과 없음 페이지
      _searchState:1 => 검색 결과 페이지
      _searchState:2 => 자동완성 페이지
   */
  Widget selectWidget() {
    if(_searchState == 0) {
      return NoSearchRes();
    } else if(_searchState == 1) {
      return SearchResTab(liquorScrollController: liquorScrollController, ingdList: ingdList, equipList: equipList, wordList: wordList,);
    } else if(_searchState == 2) {
      return NoSearchRes();
    }
    return NoSearchRes();
  }

  // 검색 실행
  submitSearch(keyword) async {
    log("submitSearch() - start");
    log("Search Keyord: " + keyword);
    SearchResult res = await searchRequest(keyword, SearchTarget.all, null, null, 1);
    // log("liquor count: " + res.liquorList.length.toString());
    // log("ingd count: " + res.ingredientList.length.toString());
    // log("equip count: " + res.equipmentList.length.toString());
    // log("word count: " + res.wordList.length.toString());

    setState((){
      searchParam = SearchParam.set(keyword: keyword, target: SearchTarget.all.toString(), categLv: null, categId: null, nowPage: 1);
    });

    if(res.liquorList.length <= 0 && res.ingredientList.length <= 0
        && res.equipmentList.length <= 0 && res.wordList.length <= 0) {
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
    setState(() {
      liquorScrollController.setData(gridLiquorList, searchParam);
    });

    ingdList = [];
    for(Ingredient ingd in res.ingredientList) {
      ingdList.add(ingd);
    }

    equipList = [];
    for(Equipment e in res.equipmentList) {
      equipList.add(e);
    }

    wordList = [];
    for(Word w in res.wordList) {
      wordList.add(w);
    }
  }

  // x 클릭 시 검색어 삭제
  emptySearchField() {
    searchTextController.clear();
  }

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
  SearchResTab({Key? key, required this.liquorScrollController, required this.ingdList, required this.equipList, required this.wordList}) : super(key: key);

  LiquorScrollController liquorScrollController;
  //List<Liquor> gridLiquorList;
  List<Ingredient> ingdList;
  List<Equipment> equipList;
  List<Word> wordList;

  @override
  _SearchResTabState createState() => _SearchResTabState();
}

class _SearchResTabState extends State<SearchResTab> with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    log("[[ SearchResTab Init ]]");
    _tabController = TabController(
        length: 2,
        vsync: this
    );
  }

  @override
  void activate() {
    log("[[ SearchResTab - activate() ]]");
    super.activate();
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
      // Tab(
      //   text: '재료',
      // ),
      // Tab(
      //   text: '장비',
      // ),
      // Tab(
      //   text: '용어',
      // ),
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
          Center( // liquor
              child: widget.liquorScrollController.data.length > 0 ? LiquorGridView(liquorController: widget.liquorScrollController) : NoSearchRes()
          ),
          Center( // cocktail
            child: Text("칵테일 검색은 준비중입니다.🥲"),
          ),
          // Center( // ingredient
          //   child: widget.ingdList.length > 0 ? IngdListView(ingdList: widget.ingdList) : NoSearchRes()
          // ),
          // Center( // equipment
          //   child: widget.equipList.length > 0 ? EquipListView(equipList: widget.equipList) : NoSearchRes(),
          // ),
          // Center( // word
          //   child: widget.wordList.length > 0 ? WordListView(wordList: widget.wordList) : NoSearchRes(),
          // )
        ],
      ),
      bottomNavigationBar: Container(height: 0.0,),
    );
  }

}

// list controller class
class LiquorScrollController extends GetxController {
  var scrollController = ScrollController().obs;
  var data = <Liquor>[].obs;
  var keyword = "";
  var nowPage = 1;
  var isLoading = false.obs;
  var hasMore = true.obs;
  var param;

  void setData(List<Liquor> data, SearchParam param) {
    this.data = data.obs;
    this.param = param;
  }

  @override
  void onInit() {
    // set listener
    scrollController.value.addListener(() async {
      // more load data
      //log("[${scrollController.value.position.pixels}][${scrollController.value.position.maxScrollExtent}]");
      if(scrollController.value.position.pixels ==
          scrollController.value.position.maxScrollExtent && hasMore.value) {

        log("[리스트의 끝입니다.] - keyword:[" + param.keyword+"]");

        SearchResult res = await searchRequest(param.keyword, SearchTarget.all, null, null, ++nowPage);

        log("[추가 로드된 개수]: ${res.liquorList.length}");

        if(res.liquorList.length > 0) {
          data.addAll(res.liquorList);
          if(res.liquorList.length >= 10) {
            hasMore = true.obs;
          } else {
            hasMore = false.obs;
          }
        } else {
          hasMore = false.obs;
        }
      }
    });
    super.onInit();
  }
}

class LiquorGridView extends StatefulWidget {
  LiquorGridView({Key? key, required this.liquorController}) : super(key: key);

  LiquorScrollController liquorController;

  @override
  _LiquorGridViewState createState() => _LiquorGridViewState();
}

class _LiquorGridViewState extends State<LiquorGridView> {
  @override
  Widget build(BuildContext context) {
    return Obx(
        () => Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    //childAspectRatio: 3 / 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 7,
                    mainAxisSpacing: 7
                ),
                controller: widget.liquorController.scrollController.value,
                itemCount: widget.liquorController.data.length,
                itemBuilder: (BuildContext context, index) {
                  return liquorItemBuilder(context, index);
                }
            ),
          ),
        )
    );
  }

  Widget liquorItemBuilder(context, index) {
    return Card(
        // generate ambers with random shades
        //color: Colors.amber[Random().nextInt(9) * 100],
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height * 0.4,
          child: Column(
            children: [
              GestureDetector(
                child: makeImgWidget(context, widget.liquorController.data[index].repImgUrl, 300, MediaQuery.of(context).size.height * 0.17),
                onTap: () {
                  goToLiquorDetailPage(context, widget.liquorController.data[index].liquorId);
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
                child: Row(
                  children: [
                    Flexible(
                      child: RichText(
                          overflow: TextOverflow.ellipsis,
                          //maxLines: 1,
                          strutStyle: StrutStyle(fontSize: 8.0),
                          text: TextSpan(
                            text: widget.liquorController.data[index].nameKr,
                            style: TextStyle(
                              fontSize: 13.0,
                              color: Colors.black,
                              fontFamily: 'NanumBarunGothicBold',
                            ),
                          )
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 3, 0, 0),
                child: Row(
                  children: [
                    Flexible(
                        child: RichText(
                            overflow: TextOverflow.ellipsis,
                            //maxLines: 1,
                            strutStyle: StrutStyle(fontSize: 8.0),
                            text: TextSpan(
                              text: widget.liquorController.data[index].nameEn,
                              style: TextStyle(
                                fontSize: 11.0,
                                color: Colors.grey,
                                fontFamily: 'NanumBarunGothicLight',
                              ),
                            )
                        ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 13, // 아이콘 크기 조절
                    ),
                    Text(
                        widget.liquorController.data[index].ratingAvg.toString(),
                        style: TextStyle(
                          fontSize: 10, // 텍스트 크기 조절
                          // 추가적인 텍스트 스타일 속성들을 설정할 수 있습니다.
                        )
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

}



// search request function
Future<SearchResult> searchRequest(keyword, SearchTarget target, categLv, categId, nowPage) async {

  log("#### [searchhLiquor] ####");
  String searchUrl = "/search.tipsy?target=";

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

  if(nowPage != null && nowPage > 0) {
    searchUrl += "&paging.nowPage=" + nowPage.toString();
  }

  final response = await requestGET(searchUrl);

  if (response.statusCode == 200) {

    String resString = response.body.toString();
    var parsed = json.decode(resString);
    var parsedData = parsed['data'];
    var liquorListRes = parsedData['liquor_list'];
    var ingdListRes = parsedData['ingredient_list'];
    var equipListRes = parsedData['equipment_list'];
    var wordListRes = parsedData['word_list'];

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

    EquipList equipList = new EquipList();
    if(equipListRes != null) {
      equipList = EquipList.fromJson(equipListRes);
      searchRes.equipmentList = equipList.equips;
    }

    WordList wordList = new WordList();
    if(wordListRes != null) {
      wordList = WordList.fromJson(wordListRes);
      searchRes.wordList = wordList.words;
    }

    return searchRes;
  } else {
    throw Exception('Failed to search data.');
  }
}

class SearchParam {
  var keyword;
  var target;
  var categLv;
  var categId;
  var nowPage;

  SearchParam.set({
    required String keyword,
    required String target,
    categLv,
    categId,
    nowPage,
  }) : this.keyword = keyword, this.target = target, this.categLv = categLv,
       this.categId = categId, this.nowPage = nowPage;

  factory SearchParam.fromJson(Map<String, dynamic> json) {
    SearchParam obj = SearchParam.set(
      keyword: json['keyword'],
      target: json['target'],
      categLv: json['categ_lv'],
      categId: json['categ_id'],
      nowPage: json['now_page'],
    );
    return obj;
  }

}

// TODO: 최근 검색어 위젯 추가
// 검색 입력 창 아래에 divider 추가

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
