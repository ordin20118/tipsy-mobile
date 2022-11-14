import 'dart:developer';

import 'package:flutter/cupertino.dart';

class Comment {
  int _commentId;
  int _userId;
  int _contentId;
  int _contentType;
  int _like;
  int _dislike;
  int _state;
  String _userNickname;
  String _comment;
  DateTime _regDate;
  late DateTime _updateDate;

  Comment.set({
    required int commentId,
    required int userId,
    required int contentId,
    required int contentType,
    required int like,
    required int dislike,
    required int state,
    required String userNickname,
    required String comment,
    required DateTime regDate,
  }) : this._commentId = commentId, this._userId = userId, this._contentId = contentId, this._contentType = contentType,
        this._like = like, this._dislike = dislike, this._state = state, this._userNickname = userNickname, this._comment = comment, this._regDate = regDate;


  factory Comment.fromJson(Map<String, dynamic> json) {
    Comment tmp = Comment.set(
        commentId: json['comment_id'],
        userId: json['user_id'],
        contentId: json['content_id'],
        contentType: json['content_type'],
        like: json['like'],
        dislike: json['dislike'],
        state: json['state'],
        userNickname: json['user_nickname'],
        comment: json['comment'],
        regDate: DateTime.fromMillisecondsSinceEpoch(json['reg_date'] * 1000)
    );

    // set late variable
    // update_date


    return tmp;
  }


  String get userNickname => _userNickname;

  set userNickname(String value) {
    _userNickname = value;
  }

  DateTime get updateDate => _updateDate;

  set updateDate(DateTime value) {
    _updateDate = value;
  }

  DateTime get regDate => _regDate;

  set regDate(DateTime value) {
    _regDate = value;
  }

  String get comment => _comment;

  set comment(String value) {
    _comment = value;
  }

  int get state => _state;

  set state(int value) {
    _state = value;
  }

  int get dislike => _dislike;

  set dislike(int value) {
    _dislike = value;
  }

  int get like => _like;

  set like(int value) {
    _like = value;
  }

  int get contentType => _contentType;

  set contentType(int value) {
    _contentType = value;
  }

  int get contentId => _contentId;

  set contentId(int value) {
    _contentId = value;
  }

  int get userId => _userId;

  set userId(int value) {
    _userId = value;
  }

  int get commentId => _commentId;

  set commentId(int value) {
    _commentId = value;
  }
}

class CommentList {
  List<Comment> comments = List<Comment>.empty();

  CommentList() {}
  CommentList.set(List<Comment> commentList) {
    List<Comment> emptyList = [];
    commentList.forEach((element) {
      emptyList.add(element);
    });
    comments = commentList;
  }

  factory CommentList.fromJson(List<dynamic> parsedJson) {
    List<Comment> comments = List<Comment>.empty(growable: true); // []와 같다.
    comments = parsedJson.map((i)=>Comment.fromJson(i)).toList();
    return new CommentList.set(
      comments,
    );
  }
}