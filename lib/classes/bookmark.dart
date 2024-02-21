import 'dart:developer';

import 'package:flutter/cupertino.dart';

class Bookmark {
  int _bookmarkId;
  int _userId;
  int _contentId;
  int _contentType;
  DateTime _regDate;

  Bookmark.set({
    required int bookmarkId,
    required int userId,
    required int contentId,
    required int contentType,
    required DateTime regDate,
  }) : this._bookmarkId = bookmarkId, this._userId = userId, this._contentId = contentId,
        this._contentType = contentType, this._regDate = regDate;

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    Bookmark tmp = Bookmark.set(
        bookmarkId: json['bookmark_id'],
        userId: json['user_id'],
        contentId: json['content_id'],
        contentType: json['content_type'],
        regDate: DateTime.fromMillisecondsSinceEpoch(json['reg_date'] * 1000)
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
}

class BookmarkList {
  List<Bookmark> bookmarks = List<Bookmark>.empty();

  BookmarkList() {}
  BookmarkList.set(List<Bookmark> bookmarkList) {
    List<Bookmark> emptyList = [];
    bookmarkList.forEach((element) {
      emptyList.add(element);
    });
    bookmarks = bookmarkList;
  }

  factory BookmarkList.fromJson(List<dynamic> parsedJson) {
    List<Bookmark> bookmarks = List<Bookmark>.empty(growable: true); // []와 같다.
    bookmarks = parsedJson.map((i)=>Bookmark.fromJson(i)).toList();
    return new BookmarkList.set(
      bookmarks,
    );
  }
}