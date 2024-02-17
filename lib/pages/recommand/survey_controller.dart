import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

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
}