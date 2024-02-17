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

class TastingNoteSurveyPage extends StatefulWidget {
  const TastingNoteSurveyPage({Key? key}) : super(key: key);

  @override
  _TastingNoteSurveyPageState createState() => _TastingNoteSurveyPageState();
}

class _TastingNoteSurveyPageState extends State<TastingNoteSurveyPage> {

  final SurveyController surveyController = Get.find();
  int _selectedBtnId = 0;
  double _progressVal = 1.0;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: [
            Text(
              '어떤 향을 좋아하시나요?',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.06,),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.08,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedBtnId = 1;
                  });
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
                  backgroundColor: _selectedBtnId == 1 ? Color(0xFF1DE9B6) : Colors.white,
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
                    _selectedBtnId = 2;
                  });
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
                  backgroundColor: _selectedBtnId == 2 ? Color(0xFF1DE9B6) : Colors.white,
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
                    _selectedBtnId = 3;
                  });
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
                  backgroundColor: _selectedBtnId == 3 ? Color(0xFF1DE9B6) : Colors.white,
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
                    _selectedBtnId = 4;
                  });
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
                  backgroundColor: _selectedBtnId == 4 ? Color(0xFF1DE9B6) : Colors.white,
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
                    _selectedBtnId = 5;
                  });
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
                  backgroundColor: _selectedBtnId == 5 ? Color(0xFF1DE9B6) : Colors.white,
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
                    _selectedBtnId = 6;
                  });
                },
                child: Text(
                  '🍊시트러스 향',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedBtnId == 6 ? Color(0xFF1DE9B6) : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // 원하는 둥근 정도로 조절
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.1,),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.07,
              child: ElevatedButton(
                onPressed: _selectedBtnId > 0 ? () {
                  surveyController.setProgress(_progressVal);
                  surveyController.addPageHistory(4);
                  surveyController.goToPage(99);
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
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0), // 원하는 둥근 정도로 조절
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }

  @override
  void initState() {
    super.initState();
    log("Noising survey page initState()");
  }
}

