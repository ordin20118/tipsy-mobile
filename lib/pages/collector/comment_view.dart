import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:tipsy_mobile/classes/comment.dart';
import 'package:tipsy_mobile/classes/util.dart';
import 'package:tipsy_mobile/classes/ui_util.dart';
import 'package:tipsy_mobile/requests/comment.dart';

class CommentListView extends StatefulWidget {
  CommentListView({Key? key, required this.commentList, required this.commentScrollController}) : super(key: key);

  List<Comment>? commentList;
  CommentScrollController? commentScrollController;

  @override
  _CommentListViewState createState() => _CommentListViewState();
}

class _CommentListViewState extends State<CommentListView> {

  CommentScrollController _commentScrollController = CommentScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Obx(() =>
        Padding(
          padding: EdgeInsets.all(0.0),
          child: ListView.separated(
            shrinkWrap: true,
            controller: _commentScrollController.scrollController.value,
            itemCount: _commentScrollController.data.length,
            itemBuilder: (BuildContext context, index) {
              return commentItemBuilder(context, index);
            },
            separatorBuilder: (BuildContext context, int index) => const Divider(
                height: 10,
                color: Colors.transparent
            ),
          ),
        )
      ),
    );
  }

  // 댓글 리스트의 하나의 요소 디자인
  Widget commentItemBuilder(context, index) {
    return Container(
      color: Colors.white,
      //height: MediaQuery.of(context).size.height * 0.08,  // TODO: 얘가 없어져야 할 거 같은데..
      child: makeCommentListItem(_commentScrollController.data[index].userNickname, _commentScrollController.data[index].comment, _commentScrollController.data[index].regDate, context),
    );
  }


  @override
  void initState() {
    super.initState();
    log("[CommentListView initState]");
    if(widget.commentScrollController != null) {
      _commentScrollController = widget.commentScrollController!;
    }
    if(widget.commentList != null && _commentScrollController.data.length <= 0) {
      for(int i=0; i<widget.commentList!.length; i++) {
        _commentScrollController.data.add(widget.commentList![i]);
      }
    }

    log("[CommentListView initState]-commentList size:" + _commentScrollController.data.length.toString());
  }

  @override
  void dispose() {
    super.dispose();
  }
}

Widget makeCommentListItem(userNickname, comment, regDate, context) {
  return Row(
    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(
        flex: 6,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100.0),
          child:Image.asset(
            'assets/images/default_profile.jpeg',
            // width: MediaQuery.of(context).size.width * 0.01,
            // height: MediaQuery.of(context).size.width * 0.01
          ),
        ),
      ),
      Flexible(
        flex: 1,
        child: SizedBox(width: MediaQuery.of(context).size.width * 0.02),
      ),
      Flexible(
        flex: 40,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userNickname+" ",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              Text(
                comment,
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.black54
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

class CommentScrollController extends GetxController {
  var scrollController = ScrollController().obs;
  var data = <Comment>[].obs;
  var nowPage = 2;
  var perPage = 5;
  var isLoading = false.obs;
  var hasMore = true.obs;
  var contentType;
  var contentId;

  void setData(List<Comment> data, int contentType, int contentId) {
    this.data = data.obs;
    this.contentType = contentType;
    this.contentId = contentId;
  }

  @override
  void onInit() {
    // set listener
    scrollController.value.addListener(() async {
      // more load data
      //log("[${scrollController.value.position.pixels}][${scrollController.value.position.maxScrollExtent}]");
      if(scrollController.value.position.pixels ==
          scrollController.value.position.maxScrollExtent && hasMore.value) {

        // log("[리스트의 끝입니다.] - contentType:[" + contentType.toString() + "]/contentId:[" + contentId.toString() + "]");
        // log("[리스트의 끝입니다.] - nowPage:[" + nowPage.toString() + "]/perPage:[" + perPage.toString() + "]");

        // load comments
        List<Comment> comments = await loadCommentInfo(contentId, contentType, nowPage, perPage);

        if(comments.length > 0) {
          data.addAll(comments);
          if(comments.length >= perPage) {
            hasMore = true.obs;
            nowPage++;
          } else {
            hasMore = false.obs;
          }
        }
      }
    });
    super.onInit();
  }
}