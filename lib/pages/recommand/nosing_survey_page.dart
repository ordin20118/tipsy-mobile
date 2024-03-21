import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tipsy_mobile/classes/util.dart';
import 'package:http/http.dart' as http;
import 'package:tipsy_mobile/pages/recommand/survey_controller.dart';
import 'dart:convert';
import '../../classes/ui_util.dart';
import '../../classes/styles.dart';

class NosingSurveyPage extends StatefulWidget {
  const NosingSurveyPage({Key? key}) : super(key: key);

  @override
  _NosingSurveyPageState createState() => _NosingSurveyPageState();
}

class _NosingSurveyPageState extends State<NosingSurveyPage> {

  final SurveyController surveyController = Get.find();
  double _progressVal = 0.7;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Obx( () {
          return Column(
            children: [
              Text(
                '좋아하는 향 또는 맛을 선택하시겠나요?',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.1,),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.08,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      surveyController.nosingPageSelectedBtnId.value = 1;
                    });
                  },
                  child: Text(
                    '좋아하는 향을 선택할래요!🤩',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: surveyController.nosingPageSelectedBtnId.value == 1 ? Color(0xFF1DE9B6) : Colors.white,
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
                    setState(() {
                      surveyController.nosingPageSelectedBtnId.value = 2;
                    });
                  },
                  child: Text(
                    '향 선택 없이 추천받을래요',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: surveyController.nosingPageSelectedBtnId.value == 2 ? Color(0xFF1DE9B6) : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // 원하는 둥근 정도로 조절
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.88,),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.07,
                child: ElevatedButton(
                  onPressed: surveyController.nosingPageSelectedBtnId.value > 0 ? () {
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

  void clickNextBtn() async {
    if(surveyController.nosingPageSelectedBtnId.value == 2) {
      surveyController.requestRecommand();
      surveyController.setProgress(1.0);
      surveyController.addPageHistory(3);
      surveyController.goToPage(99);
    } else {
      surveyController.setProgress(_progressVal);
      surveyController.addPageHistory(3);
      surveyController.goToPage(4);
    }
  }

  @override
  void initState() {
    super.initState();
    log("Noising survey page initState()");
  }
}

