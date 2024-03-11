import 'dart:developer';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tipsy_mobile/classes/util.dart';
import 'package:http/http.dart' as http;
import 'package:tipsy_mobile/pages/recommand/survey_controller.dart';
import 'dart:convert';
import '../../classes/ui_util.dart';
import '../../classes/styles.dart';

class TastingNoteSurveyPage extends StatefulWidget {
  const TastingNoteSurveyPage({Key? key}) : super(key: key);

  @override
  _TastingNoteSurveyPageState createState() => _TastingNoteSurveyPageState();
}

class _TastingNoteSurveyPageState extends State<TastingNoteSurveyPage> {

  final SurveyController surveyController = Get.find();
  double _progressVal = 1.0;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Obx( () {
          return Column(
            children: [
              Text(
                '어떤 향을 좋아하시나요?',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
              Text(
                '2개까지 선택할 수 있어요',
                style: TextStyle(
                  //color: Colors.black87,
                  color: Colors.black54,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.06,),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.08,
                child: ElevatedButton(
                  onPressed: () {
                    setBtnState(1);
                  },
                  child: Text(
                    '🍒과일 향',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: surveyController.tastingPageSelectedBtnIdList.contains(1)? Color(0xFF1DE9B6) : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // 원하는 둥근 정도로 조절
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.05,),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.08,
                child: ElevatedButton(
                  onPressed: () {
                    setBtnState(2);
                  },
                  child: Text(
                    '🌸꽃 향',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: surveyController.tastingPageSelectedBtnIdList.contains(2) ? Color(0xFF1DE9B6) : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // 원하는 둥근 정도로 조절
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.05,),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.08,
                child: ElevatedButton(
                  onPressed: () {
                    setBtnState(3);
                  },
                  child: Text(
                    '🌿허브 향',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: surveyController.tastingPageSelectedBtnIdList.contains(3) ? Color(0xFF1DE9B6) : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // 원하는 둥근 정도로 조절
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.05,),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.08,
                child: ElevatedButton(
                  onPressed: () {
                    setBtnState(4);
                  },
                  child: Text(
                    '🧂스파이스 향',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: surveyController.tastingPageSelectedBtnIdList.contains(4) ? Color(0xFF1DE9B6) : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // 원하는 둥근 정도로 조절
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.05,),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.08,
                child: ElevatedButton(
                  onPressed: () {
                    setBtnState(5);
                  },
                  child: Text(
                    '🍯달콤한 향',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: surveyController.tastingPageSelectedBtnIdList.contains(5) ? Color(0xFF1DE9B6) : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // 원하는 둥근 정도로 조절
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.05,),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.08,
                child: ElevatedButton(
                  onPressed: () {
                    setBtnState(6);
                  },
                  child: Text(
                    '🪵우디 향',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: surveyController.tastingPageSelectedBtnIdList.contains(6) ? Color(0xFF1DE9B6) : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // 원하는 둥근 정도로 조절
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.07,),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.07,
                child: ElevatedButton(
                  onPressed: surveyController.tastingPageSelectedBtnIdList.length > 0 ? () {
                    clickNextBtn();
                  } : null,
                  child: Text(
                    '다음',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: getPrimaryColor(),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0), // 원하는 둥근 정도로 조절
                    ),
                  ),
                ),
              ),
            ],
          );
        })

    );
  }

  void setBtnState(int btnIdx) {
    // 이미 선택된 버튼이라면 제거
    if(surveyController.tastingPageSelectedBtnIdList.contains(btnIdx)) {
      surveyController.tastingPageSelectedBtnIdList.remove(btnIdx);
    } else if(surveyController.tastingPageSelectedBtnIdList.length < 2) {
      // 선택되지 않고 리스트가 비어있다면 추가
      surveyController.tastingPageSelectedBtnIdList.add(btnIdx);
    }
  }

  void clickNextBtn() {
    for(int i=0; i<surveyController.tastingPageSelectedBtnIdList.length; i++) {
      int selectedId = surveyController.tastingPageSelectedBtnIdList[i];
      switch(selectedId) {
        case 1:
          surveyController.tastingNotes += ",과일";
          break;
        case 2:
          surveyController.tastingNotes += ",꽃";
          break;
        case 3:
          surveyController.tastingNotes += ",허브";
          break;
        case 4:
          surveyController.tastingNotes += ",향신료";
          break;
        case 5:
          surveyController.tastingNotes += ",달콤";
          break;
        case 6:
          surveyController.tastingNotes += ",나무";
          break;
      }
    }
    surveyController.setProgress(_progressVal);
    surveyController.addPageHistory(4);
    surveyController.requestRecommand();
    surveyController.goToPage(99);
  }

  @override
  void initState() {
    super.initState();
    log("Noising survey page initState()");
  }
}

