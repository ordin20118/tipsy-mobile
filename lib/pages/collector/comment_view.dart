import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:tipsy_mobile/classes/comment.dart';
import 'package:tipsy_mobile/classes/util.dart';
import 'package:tipsy_mobile/classes/ui_util.dart';

//class
class CommentListView extends StatefulWidget {
  CommentListView({Key? key, required this.commentList}) : super(key: key);

  List<Comment>? commentList;

  @override
  _CommentListViewState createState() => _CommentListViewState();
}

class _CommentListViewState extends State<CommentListView> {

  List<Comment> commentList = [];

  @override
  void initState() {
    super.initState();
    log("[CommentListView initState]");
    if(widget.commentList != null) {
      for(int i=0; i<widget.commentList!.length; i++) {
        commentList.add(widget.commentList![i]);
      }
    }

    log("[CommentListView initState]-commentList size:" + commentList.length.toString());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          BlankView(color: Colors.white, heightRatio: 0.01),
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: ListView.separated(
                shrinkWrap: true,
                itemCount: commentList.length,
                itemBuilder: (BuildContext context, index) {
                  return commentItemBuilder(context, index);
                },
              separatorBuilder: (BuildContext context, int index) => const Divider(
                height: 2,
                color: Colors.transparent
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 댓글 리스트의 하나의 요소 디자인
  Widget commentItemBuilder(context, index) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(0),
      height: MediaQuery.of(context).size.height * 0.08,  // TODO: 얘가 없어져야 할 거 같은데..
      child: Container(
        child: makeCommentListItem(commentList[index].userNickname, commentList[index].comment, commentList[index].regDate, context),
      ),
    );
  }

  Widget makeCommentListItem(userNickname, comment, regDate, context) {
    return Container(
      child: Row(
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
                  Expanded(
                    child: Text(
                      comment,
                      //"아주 긴 댓글 테스트아주 긴 댓글 테스트아주 긴 댓글 테스트아주 긴 댓글 테스트아주 긴 댓글 테스트아주 긴 댓글 테스트아주 긴 댓글 테스트아주 긴 댓글 테스트아주 긴 댓글 테스트아주 긴 댓글 테스트아주 긴 댓글 테스트",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}