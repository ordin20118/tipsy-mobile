import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/progress_indicator.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:tipsy_mobile/classes/util.dart';
import 'package:http/http.dart' as http;
import 'package:tipsy_mobile/pages/recommand/tasting_note_survey_page.dart';
import 'dart:convert';
import '../../classes/ui_util.dart';
import '../../classes/styles.dart';
import 'abv_survey_page.dart';
import 'price_survey_page.dart';
import 'nosing_survey_page.dart';
import 'survey_controller.dart';

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
                  return Stack(
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
                        child: const AbvSurveyPage(),
                      ),
                    ],
                  );
                }
              )
            ],
          ),
        ),
        bottomNavigationBar: Container(height: 0,)
    );
  }

  @override
  void initState() {
    super.initState();
    log("my page initState()");
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
              surveyController.goToPage(1);
            },
            child: Text(
              '시작하기',
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              ),
            ),
            style: ElevatedButton.styleFrom(
              //backgroundColor: Color(0x99005766),
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.0), // 원하는 둥근 정도로 조절
              ),
            ),
          ),
        ),
      ),
    );
  }
}
