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

class PriceSurveyPage extends StatefulWidget {
  const PriceSurveyPage({Key? key}) : super(key: key);

  @override
  _PriceSurveyPageState createState() => _PriceSurveyPageState();
}

class _PriceSurveyPageState extends State<PriceSurveyPage> {

  final SurveyController surveyController = Get.find();
  double _progressVal = 0.25;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Obx( () {
          return Column(
            children: [
              Text(
                '희망하는 가격을 선택해주세요.',
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
                      surveyController.pricePageSelectedBtnId.value = 1;
                    });
                  },
                  child: Text(
                    '5만원 미만',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: surveyController.pricePageSelectedBtnId.value == 1 ? Color(0xFF1DE9B6) : Colors.white,
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
                      surveyController.pricePageSelectedBtnId.value = 2;
                    });
                  },
                  child: Text(
                    '5 ~ 10만원',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: surveyController.pricePageSelectedBtnId.value == 2 ? Color(0xFF1DE9B6) : Colors.white,
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
                      surveyController.pricePageSelectedBtnId.value = 3;
                    });
                  },
                  child: Text(
                    '10 ~ 20만원',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: surveyController.pricePageSelectedBtnId.value == 3 ? Color(0xFF1DE9B6) : Colors.white,
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
                      surveyController.pricePageSelectedBtnId.value = 4;
                    });
                  },
                  child: Text(
                    '20만원 이상',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: surveyController.pricePageSelectedBtnId.value == 4 ? Color(0xFF1DE9B6) : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // 원하는 둥근 정도로 조절
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.45,),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.07,
                child: ElevatedButton(
                  onPressed: surveyController.pricePageSelectedBtnId.value > 0 ? () {
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
        }),
    );
  }

  void clickNextBtn() {
    switch(surveyController.pricePageSelectedBtnId.value) {
      case 1:
        surveyController.priceMin = 0.0;

        print(surveyController.priceMax);
        surveyController.priceMax = 50000.0;
        print(surveyController.priceMax);
        break;
      case 2:
        surveyController.priceMin = 50000.0;
        surveyController.priceMax = 100000.0;
        break;
      case 3:
        surveyController.priceMin = 100000.0;
        surveyController.priceMax = 200000.0;
        break;
      case 4:
        surveyController.priceMin = 200000.0;
        surveyController.priceMax = 9000000.0;
        break;
    }
    surveyController.setProgress(_progressVal);
    surveyController.addPageHistory(1);
    surveyController.goToPage(2);
  }

  void resetState() {
    setState(() {
      surveyController.pricePageSelectedBtnId.value = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    log("Price survey page initState()");
  }
}

