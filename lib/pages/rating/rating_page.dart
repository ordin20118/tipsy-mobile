import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:tipsy_mobile/classes/ui_util.dart';
import 'package:tipsy_mobile/classes/util.dart';
import 'package:tipsy_mobile/classes/styles.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../classes/param/rating_param.dart';
import '../../requests/rating.dart';
import '../../ui/star_rating.dart';


class RatingPage extends StatefulWidget {
  const RatingPage({Key? key, required this.contentId,
                              required this.contentType,
                              required this.categoryName,
                              required this.contentName,
                              required this.imageUrl
                            }) : super(key: key);

  final int contentId;
  final int contentType;
  final String categoryName;
  final String contentName;
  final String imageUrl;

  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {

  TextEditingController _commentInputController = TextEditingController();

  StarRatingController totalRateCtr = StarRatingController();
  StarRatingController tasteRateCtr = StarRatingController();
  StarRatingController nosingRateCtr = StarRatingController();
  StarRatingController priceRateCtr = StarRatingController();
  StarRatingController designRateCtr = StarRatingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('평가 등록', style: TextStyle(color: Color(0xff005766), fontFamily: 'NanumBarunGothicBold')),
        backgroundColor: Color(0xffffffff),
        actions: [],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            //height: MediaQuery.of(context).size.height,
            color: getCommonBackColor(),
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 주류 정보
                getContentInfoWidget(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                //getTotalRateWidget(),
                makeRateWidget('술의 전체적인 점수를 선택해 주세요.', totalRateCtr),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                getRateCommentWidget(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                makeRateWidget('술의 맛 또는 향은 어땠나요?', tasteRateCtr),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                makeRateWidget('술의 가격에 대한 점수를 선택해 주세요.', priceRateCtr),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                makeRateWidget('술의 패키지 또는 술병의 디자인은 어땠나요?', designRateCtr),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                ElevatedButton(
                  onPressed: () async {

                    if(totalRateCtr.rate.value == 0) {
                      dialogBuilder(context, "알림", "전체 평점을 선택해 주세요.");
                      return;
                    }

                    if(_commentInputController.text == null || _commentInputController.text.length <= 0) {
                      dialogBuilder(context, "알림", "평가 내용을 작성해 주세요.");
                      return;
                    }

                    RatingParam rParam = RatingParam();
                    rParam.contentId = widget.contentId;
                    rParam.contentType = widget.contentType;
                    rParam.comment = _commentInputController.text;
                    rParam.rating = totalRateCtr.rate.value;
                    rParam.tasteRating = tasteRateCtr.rate.value;
                    rParam.nosingRating = tasteRateCtr.rate.value;
                    rParam.priceRating = priceRateCtr.rate.value;
                    rParam.designRating = designRateCtr.rate.value;
                    bool reqRes = await requestRating(rParam);

                    if(reqRes)
                      Navigator.pop(context);

                  },
                  child: Text(
                    '평가하기',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 16.0), // 가로 패딩 조절
                    minimumSize: Size(double.infinity, 48.0), // 최소 크기를 설정하여 화면 가로를 꽉 채움
                    backgroundColor: Color(0xff005766),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0), // 모서리를 0으로 설정하여 직사각형 모양으로 만듦
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      )
    );
  }

  Widget getContentInfoWidget() {
    return Card(
        color: Color(0xAA005766),
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(const Radius.circular(0.0))
        ),
        child:Container(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.1,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  makeImgWidget(context, widget.imageUrl, 300, MediaQuery.of(context).size.height * 0.1),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.68,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.categoryName,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              // fontWeight: FontWeight.bold,
                            )
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                          RichText(
                            overflow: TextOverflow.ellipsis,
                            strutStyle: StrutStyle(fontSize: 8.0),
                            text: TextSpan(
                              text: widget.contentName,
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.white,
                                // fontWeight: FontWeight.bold
                              ),
                            )
                          ),
                        ],
                      ),
                    )
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }

  Widget makeRateWidget(String title, StarRatingController controller) {
    return Card(
        color: Color(0xFFFFFFFF),
        elevation: 0.5,
        shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(const Radius.circular(10.0))
        ),
        child:Container(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.2,
            child: Container(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04,),
                  Text(
                      title,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      )
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                  StarRating(controller: controller),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                ],
              ),
            ),
          ),
        )
    );
  }

  Widget getRateCommentWidget() {
    return Card(
      color: Color(0xFFFFFFFF),
      elevation: 0.5,
      shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(const Radius.circular(10.0))
      ),
      child:Container(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.3,
          child: Container(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.04,),
                Text(
                    '상세한 평가를 작성해 주세요.',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    )
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                Flexible(
                    flex: 9,
                    child: TextField(
                      //focusNode: focusNode,
                      controller: _commentInputController,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: '술에 대한 맛, 가격 등에 대해서 자유롭게 작성해주세요.',
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                          fontSize: 14,
                          backgroundColor: Colors.yellow
                      ),
                    )
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
              ],
            ),
          ),
        ),
      )
    );
  }

  @override
  void initState() {
    super.initState();
    print("평가하기 페이지 - contentId:" + widget.contentId.toString());
  }

  @override
  void dispose() {
    super.dispose();
  }
}

