import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:tipsy_mobile/classes/comment.dart';
import 'package:tipsy_mobile/classes/util.dart';

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
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: ListView.separated(
            shrinkWrap: true,
            itemCount: commentList.length,
            itemBuilder: (BuildContext context, index) {
              return commentItemBuilder(context, index);
            },
          separatorBuilder: (BuildContext context, int index) => const Divider(
            height: 2,
            color: Colors.grey
          ),
        ),
      ),
    );
  }

  Widget commentItemBuilder(context, index) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height * 0.08,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(0x77CFA636),
            width:1,
          ),
          borderRadius: BorderRadius.circular(20),
          color: Color(0x77CFA636),
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: makeCommentListItem(commentList[index].userNickname, commentList[index].comment,
                commentList[index].regDate, context)
        ),
      ),
    );
  }

  List<Widget> makeCommentListItem(userNickname, comment, regDate, context) {

    List<Widget> list = [];

    var nameTextWidget =
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.17,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                userNickname+" ",
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xff005766),
                ),
              ),
            ],
          ),
        );
    list.add(nameTextWidget);

    list.add(SizedBox(width: 10));

    var commentTextWidget = Expanded(
      child: Text(
        comment,
        //overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontSize: 10,
            color: Colors.black54
        ),
      ),
    );
    list.add(commentTextWidget);
    return list;
  }
}