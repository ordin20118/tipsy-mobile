import 'dart:developer';
import 'package:flutter/cupertino.dart';

class MyBookmark {
  int _bookmarkId;
  int _userId;
  int _contentId;
  int _contentType;
  DateTime _regDate;

  String _contentThumb;
  String _contentTitle;
  String _contentContent;

  MyBookmark.set({
    required int bookmarkId,
    required int userId,
    required int contentId,
    required int contentType,
    required String contentThumb,
    required String contentTitle,
    required String contentContent,
    required DateTime regDate,
  }) : this._bookmarkId = bookmarkId, this._userId = userId, this._contentId = contentId,
        this._contentThumb = contentThumb, this._contentTitle = contentTitle, this._contentContent = contentContent,
        this._contentType = contentType, this._regDate = regDate;

  factory MyBookmark.fromJson(Map<String, dynamic> json) {
    MyBookmark tmp = MyBookmark.set(
        bookmarkId: json['bookmark_id'],
        userId: json['user_id'],
        contentId: json['content_id'],
        contentType: json['content_type'],
        contentThumb: json['content_thumb'],
        contentTitle: json['content_title'],
        contentContent: json['content_content'],
        regDate: DateTime.fromMillisecondsSinceEpoch(json['reg_date'])
    );

    // set late variable
    // update_date


    return tmp;
  }

  DateTime get regDate => _regDate;

  set regDate(DateTime value) {
    _regDate = value;
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

  int get bookmarkId => _bookmarkId;

  set bookmarkId(int value) {
    _bookmarkId = value;
  }

  String get contentContent => _contentContent;

  set contentContent(String value) {
    _contentContent = value;
  }

  String get contentTitle => _contentTitle;

  set contentTitle(String value) {
    _contentTitle = value;
  }

  String get contentThumb => _contentThumb;

  set contentThumb(String value) {
    _contentThumb = value;
  }
}

class MyBookmarkList {
  List<MyBookmark> bookmarks = List<MyBookmark>.empty();

  MyBookmarkList() {}
  MyBookmarkList.set(List<MyBookmark> bookmarkList) {
    List<MyBookmark> emptyList = [];
    bookmarkList.forEach((element) {
      emptyList.add(element);
    });
    bookmarks = bookmarkList;
  }

  factory MyBookmarkList.fromJson(List<dynamic> parsedJson) {
    List<MyBookmark> bookmarks = List<MyBookmark>.empty(growable: true); // []와 같다.
    bookmarks = parsedJson.map((i)=>MyBookmark.fromJson(i)).toList();
    return new MyBookmarkList.set(
      bookmarks,
    );
  }
}