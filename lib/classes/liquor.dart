import 'dart:developer';

import 'package:flutter/cupertino.dart';

class Liquor {
  int _liquorId;
  String _nameKr;
  String _nameEn;
  int _category1Id;
  int _category2Id;
  late int _category3Id;
  late int _category4Id;
  String _category1Name;
  String _category2Name;
  late String _category3Name;
  late String _category4Name;
  late String _description;
  late String _history;
  late int _vintage;
  double _abv;
  late int _countryId;
  late String _countryName;

  int _ratingCnt;
  double _ratingAvg;

  String _repImg;
  String _repImgUrl;
  DateTime _regDate;
  late DateTime _updateDate;

  Liquor.set({
    required int liquorId,
    required String nameKr,
    required String nameEn,
    required int category1Id,
    required int category2Id,
    required String category1Name,
    required String category2Name,
    required double abv,
    required int countryId,
    required int ratingCnt,
    required double ratingAvg,
    required String repImg,
    required String repImgUrl,
    required DateTime regDate,
  }) : this._liquorId = liquorId, this._nameKr = nameKr,
        this._nameEn = nameEn, this._category1Id = category1Id,
        this._category2Id = category2Id, this._category1Name = category1Name,
        this._category2Name = category2Name, this._abv = abv, this._countryId = countryId,
        this._ratingCnt = ratingCnt, this._ratingAvg = ratingAvg,
        this._repImg = repImg, this._repImgUrl = repImgUrl, this._regDate = regDate;


  factory Liquor.fromJson(Map<String, dynamic> json) {
    Liquor tmp = Liquor.set(
        liquorId: json['liquor_id'],
        nameKr: json['name_kr'],
        nameEn: json['name_en'],
        category1Id: json['category1_id'],
        category2Id: json['category2_id'],
        category1Name: json['category1_name'],
        category2Name: json['category2_name'],
        abv: json['abv'],
        countryId: json['country_id'],
        ratingCnt: json['rating_cnt'],
        ratingAvg: json['rating_avg'],
        repImg: json['rep_img'],
        repImgUrl: json['rep_img_url'],
        regDate: DateTime.fromMillisecondsSinceEpoch(json['reg_date'] * 1000)
    );

    // set late variable
    // category3_id
    // category4_id
    // category3_name
    tmp._category3Name = json['category3_name'] ?? "";
    // category4_name
    tmp._category4Name = json['category4_name'] ?? "";

    // vintage
    tmp._vintage = json['vintage'] ?? 0;

    // country_id
    tmp._countryId = json['country_id'] ?? 0;
    tmp._countryName = json['country_name'] ?? "";

    // description
    tmp._description = json['description'] ?? "";

    // history
    tmp._history = json['history'] ?? "";

    // update_date

    return tmp;
  }

  String getLastCategoryName() {
    String res = '';
    if(_category4Name != "") {
      res = _category4Name;
    } else if(_category3Name != "") {
      res = _category3Name;
    } else if(_category2Name != "") {
      res = _category2Name;
    } else if(_category1Name != "") {
      res = _category1Name;
    }
    return res;
  }

  // auto created setter & getter
  int get liquorId => _liquorId;

  set liquorId(int value) {
    _liquorId = value;
  }

  String get nameKr => _nameKr;

  set nameKr(String value) {
    _nameKr = value;
  }

  String get nameEn => _nameEn;

  set nameEn(String value) {
    _nameEn = value;
  }

  int get category1Id => _category1Id;

  set category1Id(int value) {
    _category1Id = value;
  }

  int get category2Id => _category2Id;

  set category2Id(int value) {
    _category2Id = value;
  }

  int get category3Id => _category3Id;

  set category3Id(int value) {
    _category3Id = value;
  }

  int get category4Id => _category4Id;

  set category4Id(int value) {
    _category4Id = value;
  }

  String get category1Name => _category1Name;

  set category1Name(String value) {
    _category1Name = value;
  }

  String get category2Name => _category2Name;

  set category2Name(String value) {
    _category2Name = value;
  }

  String get category3Name => _category3Name;

  set category3Name(String value) {
    _category3Name = value;
  }

  String get category4Name => _category4Name;

  set category4Name(String value) {
    _category4Name = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get history => _history;

  set history(String value) {
    _history = value;
  }

  int get vintage => _vintage;

  set vintage(int value) {
    _vintage = value;
  }

  double get abv => _abv;

  set abv(double value) {
    _abv = value;
  }

  String get repImg => _repImg;

  set repImg(String value) {
    _repImg = value;
  }

  String get repImgUrl => _repImgUrl;

  set repImgUrl(String value) {
    _repImgUrl = value;
  }

  int get countryId => _countryId;

  set countryId(int value) {
    _countryId = value;
  }

  DateTime get regDate => _regDate;

  set regDate(DateTime value) {
    _regDate = value;
  }

  DateTime get updateDate => _updateDate;

  set updateDate(DateTime value) {
    _updateDate = value;
  }

  String get countryName => _countryName;

  set countryName(String value) {
    _countryName = value;
  }

  double get ratingAvg => _ratingAvg;

  set ratingAvg(double value) {
    _ratingAvg = value;
  }

  int get ratingCnt => _ratingCnt;

  set ratingCnt(int value) {
    _ratingCnt = value;
  }
}

class LiquorList {
  List<Liquor> liquors = List<Liquor>.empty();

  LiquorList() {}
  LiquorList.set(List<Liquor> liquorList) {
    List<Liquor> emptyList = [];
    liquorList.forEach((element) {
      emptyList.add(element);
    });
    liquors = emptyList;
  }

  factory LiquorList.fromJson(List<dynamic> parsedJson) {
    List<Liquor> liquors = List<Liquor>.empty(growable: true); // []와 같다.
    liquors = parsedJson.map((i)=>Liquor.fromJson(i)).toList();
    return new LiquorList.set(
      liquors,
    );
  }
}