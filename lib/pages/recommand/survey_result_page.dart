import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tipsy_mobile/classes/util.dart';
import 'package:http/http.dart' as http;
import 'package:tipsy_mobile/pages/recommand/survey_controller.dart';
import 'dart:convert';
import '../../classes/liquor.dart';
import '../../classes/ui_util.dart';
import '../../classes/styles.dart';
import '../../ui/tipsy_loading_indicator.dart';
import '../liquor_page.dart';

class SurveyResultPage extends StatefulWidget {
  const SurveyResultPage({Key? key}) : super(key: key);

  @override
  _SurveyResultPageState createState() => _SurveyResultPageState();
}

class _SurveyResultPageState extends State<SurveyResultPage> {

  final SurveyController surveyController = Get.find();
  int _selectedBtnId = 0;
  double _progressVal = 1.0;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
          child: Column(
            children: [
              buildResultText(),
              SizedBox(height: MediaQuery.of(context).size.width * 0.06,),
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                child: buildRecommendedLiquors(),
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.3,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: ElevatedButton(
                      onPressed: () {
                        surveyController.clearState();
                        surveyController.goToPage(0);
                      },
                      child: Text(
                        '다시 하기',
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: ElevatedButton(
                      onPressed: () {
                        surveyController.clearState();
                        Navigator.pop(context);
                      },
                      child: Text(
                        '닫기',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0), // 원하는 둥근 정도로 조절
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          )
      );
    });
  }

  Widget buildResultText() {
    // 추천 결과가 없다면 상단 텍스트 없음
    if(!surveyController.hasLiquors) {
      return Text('');
    }

    if(surveyController.recommandedLiquors.length <= 0) {
      return Text(
        '추천해드릴 술을 찾고있어요!\n잠시만 기다려주세요 🙂',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      );
    } else {
      return Text(
        '추천 결과가 나왔어요!',
        style: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }

  Widget buildRecommendedLiquors() {
    List<Liquor> liquorList = surveyController.recommandedLiquors;
    if(liquorList.length == 0 && surveyController.hasLiquors) { // 추천 데이터를 조회중
      return Center(child: TipsyLoadingIndicator(),);
    } else if(!surveyController.hasLiquors) {                   // 추천 결과가 없는 경우 출력
      return Center(child: Text(
        '추천 할만한 술을 찾지 못했어요..🥲',
        style: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),);
    }

    List<Widget> liquorCardList = <Widget>[];

    int limit = 4;
    if(liquorList.length < 3) {
      limit = liquorList.length;
    }

    for(int i=0; i<limit; i++) {
      Liquor liquor = liquorList[i];
      liquorCardList.add(
        Expanded(
            child: Card(
              color: Colors.white,
              //elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LiquorDetail(liquorId: liquor.liquorId)),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: makeImgWidget(context, liquor.repImgUrl, 300, MediaQuery.of(context).size.height * 0.17),
                      ),
                      Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                      overflow: TextOverflow.ellipsis,
                                      strutStyle: StrutStyle(fontSize: 8.0),
                                      text: TextSpan(
                                        text: liquor.nameKr,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Color(0xCC000000),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                  ),
                                  RichText(
                                      overflow: TextOverflow.ellipsis,
                                      strutStyle: StrutStyle(fontSize: 8.0),
                                      text: TextSpan(
                                        text: liquor.nameEn,
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          color: Colors.black54,
                                        ),
                                      )
                                  ),
                                  RichText(
                                      overflow: TextOverflow.ellipsis,
                                      strutStyle: StrutStyle(fontSize: 8.0),
                                      text: TextSpan(
                                        text: makeCategString(liquor),
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          color: Colors.black54,
                                        ),
                                      )
                                  )
                                ],
                              ),
                            ),
                          )
                      )
                    ],
                  ),
                ),
              ),
            ),
        )
      );
    }

    return Column(
      children: liquorCardList,
    );
  }

  @override
  void initState() {
    super.initState();
    log("Noising survey page initState()");
  }
}

