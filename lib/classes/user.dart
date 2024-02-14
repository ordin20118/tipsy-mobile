import 'package:flutter/cupertino.dart';

const int USER_PLATFORM_INTERNAL = 0;
const int USER_PLATFORM_KAKAO = 1;
const int USER_PLATFORM_NAVER = 2;
const int USER_PLATFORM_APPLE = 3;

enum Gender {
  male, female
}

class AccessToken {
  int       _userId;
  String    _tokenHash;
  String    _email;
  int       _platform;
  DateTime  _expireDate;

  AccessToken.set({
    required int userId,
    required String tokenHash,
    required String email,
    required int platform,
    required DateTime expireDate,
  }) : this._userId = userId, this._tokenHash = tokenHash,
        this._email = email, this._platform = platform, this._expireDate = expireDate;


  factory AccessToken.fromJson(Map<String, dynamic> json) {
    AccessToken tmp = AccessToken.set(
        userId: json['user_id'],
        tokenHash: json['token_hash'],
        email: json['email'],
        platform: json['platform'],
        expireDate: DateTime.fromMillisecondsSinceEpoch(json['expire_date'] * 1000)
    );
    return tmp;
  }

  DateTime get expireDate => _expireDate;

  set expireDate(DateTime value) {
    _expireDate = value;
  }

  int get platform => _platform;

  set platform(int value) {
    _platform = value;
  }

  String get tokenHash => _tokenHash;

  set tokenHash(String value) {
    _tokenHash = value;
  }

  int get userId => _userId;

  set userId(int value) {
    _userId = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }
}