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

class AbvSurveyPage extends StatefulWidget {
  const AbvSurveyPage({Key? key}) : super(key: key);

  @override
  _AbvSurveyPageState createState() => _AbvSurveyPageState();
}

class _AbvSurveyPageState extends State<AbvSurveyPage> {

  final SurveyController surveyController = Get.find();
  double _progressVal = 0.5;

  @override
  Widget build(BuildContext context) {
    return Container(
        child:Obx( () {
          return Column(
            children: [
              Text(
                '원하는 도수를 선택해주세요.',
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
                      surveyController.abvPageSelectedBtnId.value = 1;
                    });
                  },
                  child: Text(
                    '무알콜',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: surveyController.abvPageSelectedBtnId.value == 1 ? Color(0xFF1DE9B6) : Colors.white,
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
                      surveyController.abvPageSelectedBtnId.value = 2;
                    });
                  },
                  child: Text(
                    '10도 이하',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: surveyController.abvPageSelectedBtnId.value == 2 ? Color(0xFF1DE9B6) : Colors.white,
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
                      surveyController.abvPageSelectedBtnId.value = 3;
                    });
                  },
                  child: Text(
                    '10 ~ 20도 사이',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: surveyController.abvPageSelectedBtnId.value == 3 ? Color(0xFF1DE9B6) : Colors.white,
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
                      surveyController.abvPageSelectedBtnId.value = 4;
                    });
                  },
                  child: Text(
                    '20 ~ 40도 사이',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: surveyController.abvPageSelectedBtnId.value == 4 ? Color(0xFF1DE9B6) : Colors.white,
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
                      surveyController.abvPageSelectedBtnId.value = 5;
                    });
                  },
                  child: Text(
                    '40도 이상',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: surveyController.abvPageSelectedBtnId.value == 5 ? Color(0xFF1DE9B6) : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // 원하는 둥근 정도로 조절
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.2,),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.07,
                child: ElevatedButton(
                  onPressed: surveyController.abvPageSelectedBtnId.value > 0 ? () {
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

  void clickNextBtn() {
    switch(surveyController.abvPageSelectedBtnId.value) {
      case 1:
        surveyController.abvMin = 0.0;
        surveyController.abvMax = 2.0;
        break;
      case 2:
        surveyController.abvMin = 2.0;
        surveyController.abvMax = 10.0;
        break;
      case 3:
        surveyController.abvMin = 10.0;
        surveyController.abvMax = 20.0;
        break;
      case 4:
        surveyController.abvMin = 20.0;
        surveyController.abvMax = 40.0;
        break;
      case 5:
        surveyController.abvMin = 40.0;
        surveyController.abvMax = 100.0;
        break;
    }
    surveyController.setProgress(_progressVal);
    surveyController.addPageHistory(2);
    surveyController.goToPage(3);
  }

  @override
  void initState() {
    super.initState();
    log("Abv survey page initState()");
  }
}

