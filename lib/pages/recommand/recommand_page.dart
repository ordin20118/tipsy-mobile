import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/progress_indicator.dart';
import 'package:get/get.dart';
import 'package:tipsy_mobile/pages/recommand/price_survey_page.dart';
import 'package:tipsy_mobile/pages/recommand/tasting_note_survey_page.dart';
import '../../classes/ui_util.dart';
import 'abv_survey_page.dart';
import 'nosing_survey_page.dart';
import 'survey_controller.dart';
import 'survey_result_page.dart';

class RecommandPage extends StatefulWidget {
  const RecommandPage({Key? key}) : super(key: key);

  @override
  _RecommandPageState createState() => _RecommandPageState();
}

class _RecommandPageState extends State<RecommandPage> {

  final SurveyController surveyController = Get.put(SurveyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              if(surveyController.nowSurveyPage.value == 0) {
                surveyController.clearState();
                Navigator.pop(context);
              } else if(surveyController.nowSurveyPage == 99){
                surveyController.clearState();
                Navigator.pop(context);
              } else {
                surveyController.goToPrev();
              }
            },
            color: Colors.black,
            iconSize: 25,
          ),
          title: Text('오늘은 어떤 술?'),
          backgroundColor: Colors.white,
          elevation: 0.1,
        ),
        body: Container(
          child: Column(
            children: [
              Obx(() {
                return LinearProgressIndicator(
                  value: surveyController.progress.value,
                  backgroundColor: Colors.grey,
                  color: Colors.black45,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF004D40)),
                  minHeight: 4.0,
                  semanticsLabel: 'semanticsLabel',
                  semanticsValue: 'semanticsValue',
                );
              }),
              SizedBox(height: MediaQuery.of(context).size.width * 0.1,),
              Obx(
                () {
                  return Expanded(
                    child: Stack(
                      children: [
                        Offstage(
                          offstage: surveyController.nowSurveyPage.value != 0,
                          child: buildStartPage(context),
                        ),
                        Offstage(
                          offstage: surveyController.nowSurveyPage.value != 1,
                          child: const PriceSurveyPage(),
                        ),
                        Offstage(
                          offstage: surveyController.nowSurveyPage.value != 2,
                          child: const AbvSurveyPage(),
                        ),
                        Offstage(
                          offstage: surveyController.nowSurveyPage.value != 3,
                          child: const NosingSurveyPage(),
                        ),
                        Offstage(
                          offstage: surveyController.nowSurveyPage.value != 4,
                          child: const TastingNoteSurveyPage(),
                        ),
                        Offstage(
                          offstage: surveyController.nowSurveyPage.value != 99,
                          child: const SurveyResultPage(),
                        ),
                      ],
                    ),
                  );
                }
              )
            ],
          ),
        ),
        bottomNavigationBar: Container(height: 0,)
    );
  }

  Widget buildStartPage(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.08,
          child: ElevatedButton(
            onPressed: () {
              surveyController.clearState();
              surveyController.goToPage(1);
            },
            child: Text(
              '시작하기',
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
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    log("my page initState()");
  }
}

