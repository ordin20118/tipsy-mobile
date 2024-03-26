import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:tipsy_mobile/classes/common_code.dart';
import '../../classes/my_bookmark.dart';
import '../../classes/param/bookmark_param.dart';
import '../../classes/ui_util.dart';
import '../../requests/bookmark.dart';
import '../collector/comment_view.dart';

class MyBookmarkPage extends StatefulWidget {
  const MyBookmarkPage({Key? key}) : super(key: key);

  @override
  _MyBookmarkPageState createState() => _MyBookmarkPageState();
}

class _MyBookmarkPageState extends State<MyBookmarkPage> {

  MyBookmarkScrollController _myBookmarkScrollController = Get.put<MyBookmarkScrollController>(MyBookmarkScrollController(), tag: "MyBookmarkList",);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: _refreshData,
        child: buildMyBookmarkPage(context),
    );
  }

  Widget buildMyBookmarkPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('스크랩 북', style: TextStyle(color: Color(0xff005766), fontFamily: 'NanumBarunGothicBold')),
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
                controller: _myBookmarkScrollController.scrollController.value,
                itemCount: _myBookmarkScrollController.data.length,
                itemBuilder: (BuildContext context, index) {
                  return MyBookmarkItemBuilder(context, index);
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

  Widget MyBookmarkItemBuilder(context, index) {
    return Container(
      color: Colors.white,
      child: makeBookmarkListItem(context, _myBookmarkScrollController.data[index], index),
    );
  }

  Widget makeBookmarkListItem(BuildContext context, MyBookmark bookmark, int index) {

    String contentTitle = "";
    if(bookmark.contentType == CommonCode.CONTENT_TYPE_LIQUOR) {
      contentTitle += "주류 정보";
    } else if(bookmark.contentType == CommonCode.CONTENT_TYPE_POST) {
      contentTitle += "커뮤니티 게시글";
    }

    return GestureDetector(
      onTap: (() {
        if(bookmark.contentType == CommonCode.CONTENT_TYPE_LIQUOR) {
          goToLiquorDetailPage(context, bookmark.contentId);
        } else if(bookmark.contentType == CommonCode.CONTENT_TYPE_POST) {

        }
      }),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                      bookmark.contentThumb,
                      height: MediaQuery.of(context).size.height * 0.05,
                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                        return Image.asset(
                          'assets/images/default_image.png',
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  )
                ),
                Expanded(
                  flex: 13,
                  child: Text(
                    bookmark.contentTitle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (() async {
                    // bookmark 제거 요청
                    // 해당 데이터 요소 제거 setState
                    log("salkdfjasl;dkfjas;dlkfjas;dlkfjasd;lkfjasdlkf ${index}");
                    BookmarkParam bParam = BookmarkParam();
                    bParam.contentType = bookmark.contentType;
                    bParam.contentId = bookmark.contentId;
                    bool state = await deleteBookmark(bParam);
                    setState(() {
                      if(state!= null && state) {
                        _myBookmarkScrollController.data.removeAt(index);
                      }
                    });
                  }),
                  child: Icon(
                    Icons.bookmark,
                    color: getPrimaryColor(),
                    size: 30,
                  ),
                )
              ]
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
            //alignment: Alignment.topLeft,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    bookmark.contentContent,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.black87
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]
      ),
    );
  }

  Future<void> _refreshData() async {
    log("Refresh my bookmarks.");
    setState(() {
      fetchData();
    });
  }

  Future<void> fetchData() async {
    List<MyBookmark> newData = await requestMyBookmark(1);
    _myBookmarkScrollController.setData(newData);
  }

  @override
  void initState() {
    super.initState();
    log("My bookmarks page initState()");
    fetchData();
  }

}

class MyBookmarkScrollController extends GetxController {
  var scrollController = ScrollController().obs;
  var data = <MyBookmark>[].obs;
  var nowPage = 2;
  var perPage = 5;
  var isLoading = false.obs;
  var hasMore = true.obs;

  void setData(List<MyBookmark> data) {
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
      if(scrollController.value.position.pixels >= scrollController.value.position.maxScrollExtent
          && hasMore.value && !isLoading.value) {

        isLoading = true.obs;

        // load Comments
        List<MyBookmark> bookmarks = await requestMyBookmark(nowPage);

        if(bookmarks.length > 0) {
          data.addAll(bookmarks);
          if(bookmarks.length >= perPage) {
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


