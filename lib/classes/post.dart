import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:tipsy_mobile/classes/post.dart';

class Post {
  int _id;
  int _userId;
  String _title;
  String _content;
  int _state;
  String _userNickname;
  String _userProfileUrl;
  List<String> _imageUrls;
  DateTime _regDate;
  late DateTime _updateDate;
  late DateTime _deleteDate;

  Post.set({
    required int id,
    required int userId,
    required String title,
    required String content,
    required int state,
    required String userNickname,
    required String userProfileUrl,
    required List<String> imageUrls,
    required DateTime regDate,
  }) : this._id = id, this._userId = userId, this._title = title, this._content = content,
        this._state = state, this._userNickname = userNickname, this._userProfileUrl = userProfileUrl,
        this._imageUrls = imageUrls, this._regDate = regDate;


  factory Post.fromJson(Map<String, dynamic> json) {
    Post tmp = Post.set(
        id: json['id'],
        userId: json['user_id'],
        title: json['title'],
        content: json['content'],
        state: json['state'],
        userNickname: json['user_nickname'],
        userProfileUrl: json['user_profile_url'],
        imageUrls: List<String>.from(json['image_urls'].map((item) => item.toString())),
        regDate: DateTime.fromMillisecondsSinceEpoch(json['reg_date'] * 1000)
    );

    // set late variable
    // update_date
    // delete_date


    return tmp;
  }

  DateTime get deleteDate => _deleteDate;

  set deleteDate(DateTime value) {
    _deleteDate = value;
  }

  DateTime get updateDate => _updateDate;

  set updateDate(DateTime value) {
    _updateDate = value;
  }

  DateTime get regDate => _regDate;

  set regDate(DateTime value) {
    _regDate = value;
  }

  String get userNickname => _userNickname;

  set userNickname(String value) {
    _userNickname = value;
  }

  int get state => _state;

  set state(int value) {
    _state = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  int get userId => _userId;

  set userId(int value) {
    _userId = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get content => _content;

  set content(String value) {
    _content = value;
  }

  List<String> get imageUrls => _imageUrls;

  set imageUrls(List<String> value) {
    _imageUrls = value;
  }

  String get userProfileUrl => _userProfileUrl;

  set userProfileUrl(String value) {
    _userProfileUrl = value;
  }
}

class PostList {
  List<Post> posts = List<Post>.empty();

  PostList() {}
  PostList.set(List<Post> PostList) {
    List<Post> emptyList = [];
    PostList.forEach((element) {
      emptyList.add(element);
    });
    posts = PostList;
  }

  factory PostList.fromJson(List<dynamic> parsedJson) {
    List<Post> Posts = List<Post>.empty(growable: true); // []와 같다.
    Posts = parsedJson.map((i)=>Post.fromJson(i)).toList();
    return new PostList.set(
      Posts,
    );
  }
}