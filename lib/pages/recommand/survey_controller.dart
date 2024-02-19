import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:tipsy_mobile/classes/param/recommandParam.dart';
import 'package:tipsy_mobile/classes/util.dart';
import 'package:tipsy_mobile/pages/recommand/price_survey_page.dart';

import '../../classes/liquor.dart';

class SurveyController extends GetxController {

  // survey page id
  // 0: 시작 페이지
  // 1: 가격 선택
  // 2: 도수 선택
  // 3: 향 유무 선택
  // 4: 향미 선택
  // 99: 결과 페이지

  List<int> pageHistory = [];
  List<double> progressHistory = [];

  RxInt nowSurveyPage = 0.obs;
  RxDouble progress = 0.0.obs;

  // 페이지 초기화 관리
  RxInt pricePageSelectedBtnId = 0.obs;
  RxInt abvPageSelectedBtnId = 0.obs;
  RxInt nosingPageSelectedBtnId = 0.obs;
  RxList<int> tastingPageSelectedBtnIdList = [0].obs;

  // 추천 옵션 설정
  late double priceMin, priceMax;
  late double abvMin, abvMax;
  late String tastingNotes;

  // 추천 결과
  bool hasLiquors = true;
  RxList<Liquor> recommandedLiquors = <Liquor>[].obs;

  void goToPrev() {
    nowSurveyPage.value = getPrevPage();
    print("[goToPrev]" + nowSurveyPage.value.toString());
    if(nowSurveyPage.value <= 1) {
      progress.value = 0.0;
    } else {
      progressHistory.removeLast();
      progress.value = progressHistory.last;
    }
  }

  void clearState() {
    // clear progress state
    pageHistory.clear();
    progressHistory.clear();
    nowSurveyPage.value = 0;
    progress.value = 0.0;

    // clear recommand option state
    priceMin = 0.0; priceMax = 0.0;
    abvMin = 0.0; abvMax = 0.0;
    tastingNotes = "";

    // clear page state
    resetPricePage();
    resetAbvPage();
    resetNosingPage();
    resetTastingPage();

    // clear recommended result
    recommandedLiquors.clear();
  }

  void goToPage(int pageId) {
    nowSurveyPage.value = pageId;
  }

  void setProgress(double value) {
    progress.value = value;
    progressHistory.add(value);
  }

  void addPageHistory(int pageId) {
    pageHistory.add(pageId);
  }

  int getPrevPage() {
    if(pageHistory.length == 0) {
      return 0;
    } else {
      return pageHistory.removeLast();
    }
  }

  void resetPricePage() {
    pricePageSelectedBtnId.value = 0;
  }

  void resetAbvPage() {
    abvPageSelectedBtnId.value = 0;
  }

  void resetNosingPage() {
    nosingPageSelectedBtnId.value = 0;
  }

  void resetTastingPage() {
    tastingPageSelectedBtnIdList.clear();
  }

  void requestRecommand() async {
    print("[requestRecommand]");
    hasLiquors = true;
    RecommandParam param = RecommandParam();
    param.abvMin = abvMin;
    param.abvMax = abvMax;
    param.priceMin = priceMin;
    param.priceMax = priceMax;
    param.tastingNotes = tastingNotes;
    await Future.delayed(Duration(seconds: 1)); // for test
    List<Liquor> res = await loadRecommandLiquors(param);
    res.length == 0 ? hasLiquors = false : hasLiquors = true;
    recommandedLiquors.clear();
    for(int i=0; i<res.length; i++){
      recommandedLiquors.add(res[i]);
    }
  }
}