import 'dart:developer';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tipsy_mobile/classes/common_code.dart';
import 'package:tipsy_mobile/classes/util.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../classes/my_comment.dart';
import '../../classes/ui_util.dart';
import '../../classes/styles.dart';
import '../../classes/user.dart';
import '../../requests/comment.dart';
import '../../requests/user.dart';
import '../../ui/tipsy_loading_indicator.dart';
import '../../ui/tipsy_refresh_indicator.dart';
import '../collector/comment_view.dart';


class MyCommentPage extends StatefulWidget {
  const MyCommentPage({Key? key}) : super(key: key);

  @override
  _MyCommentPageState createState() => _MyCommentPageState();
}

class _MyCommentPageState extends State<MyCommentPage> {

  MyCommentScrollController _myCommentScrollController = Get.put<MyCommentScrollController>(MyCommentScrollController(), tag: "MyCommentList",);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: _refreshData,
        child: buildMyCommentPage(context),
    );
  }

  Widget buildMyCommentPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('내가 쓴 댓글', style: TextStyle(color: Color(0xff005766), fontFamily: 'NanumBarunGothicBold')),
        //backgroundColor: Color(0xff005766),
        backgroundColor: Color(0xffffffff),
        actions: [],
      ),
      body: Container(
        color: getCommonBackColor(),
        height: MediaQuery.of(context).size.height * 0.86,
        child: Obx(() =>
            Padding(
              padding: EdgeInsets.all(0.0),
              child: ListView.separated(
                shrinkWrap: true,
                controller: _myCommentScrollController.scrollController.value,
                itemCount: _myCommentScrollController.data.length,
                itemBuilder: (BuildContext context, index) {
                  return MyCommentItemBuilder(context, index);
                },
                separatorBuilder: (BuildContext context, int index) => const Divider(
                    height: 10,
                    color: Colors.transparent
                ),
              ),
            )
        ),
      ),
      bottomNavigationBar: Container(height: 0,),
    );
  }

  Widget MyCommentItemBuilder(context, index) {
    return Container(
      color: Colors.white,
      child: makeCommentListItem(context, _myCommentScrollController.data[index]),
    );
  }

  Widget makeCommentListItem(BuildContext context, MyComment comment) {

    String contentTitle = "";
    if(comment.contentType == CommonCode.CONTENT_TYPE_LIQUOR) {
      contentTitle += "주류 정보에서 작성 - ${comment.contentTitle}";
    } else if(comment.contentType == CommonCode.CONTENT_TYPE_POST) {
      contentTitle += "커뮤니티 게시글에서 작성 - ${comment.contentTitle}";
    }

    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: GestureDetector(
            onTap: (() {
              if(comment.contentType == CommonCode.CONTENT_TYPE_LIQUOR) {
                goToLiquorDetailPage(context, comment.contentId);
              } else if(comment.contentType == CommonCode.CONTENT_TYPE_POST) {

              }
            }),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    contentTitle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 12,
                      color: getPrimaryColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(13),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child:Image.network(
                    comment.userProfileUrl,
                    height: MediaQuery.of(context).size.height * 0.05,
                    errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                      return Image.asset(
                        'assets/images/default_profile.png',
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                )
              ),
              Expanded(
                flex: 13,
                child: Text(
                  comment.userNickname,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Icon(Icons.more_horiz),
            ]
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          alignment: Alignment.topLeft,
          child: Text(
            comment.comment,
            //overflow: TextOverflow.ellipsis,
            //maxLines: 100,
            style: TextStyle(
                fontSize: 13,
                color: Colors.black87
            ),
          ),
        ),
      ]
    );
  }

  Future<void> _refreshData() async {
    log("Refresh my comments.");
    setState(() {
      fetchData();
    });
  }

  Future<void> fetchData() async {
    List<MyComment> newData = await requestMyComment(1);
    _myCommentScrollController.setData(newData);
  }

  @override
  void initState() {
    super.initState();
    log("My comments page initState()");
    fetchData();
  }

}

class MyCommentScrollController extends GetxController {
  var scrollController = ScrollController().obs;
  var data = <MyComment>[].obs;
  var nowPage = 2;
  var perPage = 5;
  var isLoading = false.obs;
  var hasMore = true.obs;

  void setData(List<MyComment> data) {
    //this.scrollController = ScrollController().obs;
    this.data.clear();
    this.data = data.obs;
    this.nowPage = 2;
    this.isLoading = false.obs;
    this.hasMore = true.obs;
  }

  @override
  void onInit() {
    // set listener
    scrollController.value.addListener(() async {
      //log("${scrollController.value.position.pixels}/${scrollController.value.position.maxScrollExtent}");
      // more load data
      if(scrollController.value.position.pixels >=
          scrollController.value.position.maxScrollExtent && hasMore.value && !isLoading.value) {

        isLoading = true.obs;

        // load Comments
        List<MyComment> comments = (await requestMyComment(nowPage)).cast<MyComment>();

        if(comments.length > 0) {
          data.addAll(comments);
          if(comments.length >= perPage) {
            hasMore = true.obs;
            nowPage++;
          } else {
            hasMore = false.obs;
          }
        } else {
          hasMore = false.obs;
        }
        isLoading = false.obs;
      }
    });
    super.onInit();
  }
}


