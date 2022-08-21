import 'package:flutter/cupertino.dart';

const int USER_PLATFORM_INTERNAL = 0;
const int USER_PLATFORM_KAKAO = 1;

enum Gender {
  male, female
}

class AccessToken {
  int       _userId;
  String    _tokenHash;
  int       _platform;
  DateTime  _expireDate;

  AccessToken.set({
    required int userId,
    required String tokenHash,
    required int platform,
    required DateTime expireDate,
  }) : this._userId = userId, this._tokenHash = tokenHash,
        this._platform = platform, this._expireDate = expireDate;


  factory AccessToken.fromJson(Map<String, dynamic> json) {
    AccessToken tmp = AccessToken.set(
        userId: json['user_id'],
        tokenHash: json['token_hash'],
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
}