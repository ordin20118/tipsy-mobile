import 'package:flutter/cupertino.dart';

class Equipment {
  int _equipId;
  String _nameKr;
  String _nameEn;
  int _category1Id;
  late int _category2Id;
  late int _category3Id;
  late int _category4Id;
  String _category1Name;
  late String _category2Name;
  late String _category3Name;
  late String _category4Name;
  late String _description;
  late String _history;
  String _repImg;
  DateTime _regDate;
  late DateTime _updateDate;

  Equipment.set({
    required int equipId,
    required String nameKr,
    required String nameEn,
    required int category1Id,
    required String category1Name,
    required String repImg,
    required DateTime regDate,
  }) : this._equipId = equipId, this._nameKr = nameKr,
        this._nameEn = nameEn, this._category1Id = category1Id,
        this._category1Name = category1Name, this._repImg = repImg, this._regDate = regDate;


  factory Equipment.fromJson(Map<String, dynamic> json) {
    Equipment tmp = Equipment.set(
        equipId: json['equip_id'],
        nameKr: json['name_kr'],
        nameEn: json['name_en'],
        category1Id: json['category1_id'],
        category1Name: json['category1_name'],
        repImg: json['rep_img'],
        regDate: DateTime.fromMillisecondsSinceEpoch(json['reg_date'] * 1000)
    );

    // set late variable
    // category3_id
    // category4_id
    // category3_ame
    // category4_ame
    // description
    // update_date

    return tmp;
  }


  int get equipId => _equipId;

  set equipId(int value) {
    _equipId = value;
  }

  DateTime get updateDate => _updateDate;

  set updateDate(DateTime value) {
    _updateDate = value;
  }

  DateTime get regDate => _regDate;

  set regDate(DateTime value) {
    _regDate = value;
  }

  String get repImg => _repImg;

  set repImg(String value) {
    _repImg = value;
  }

  String get history => _history;

  set history(String value) {
    _history = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get category4Name => _category4Name;

  set category4Name(String value) {
    _category4Name = value;
  }

  String get category3Name => _category3Name;

  set category3Name(String value) {
    _category3Name = value;
  }

  String get category2Name => _category2Name;

  set category2Name(String value) {
    _category2Name = value;
  }

  String get category1Name => _category1Name;

  set category1Name(String value) {
    _category1Name = value;
  }

  int get category4Id => _category4Id;

  set category4Id(int value) {
    _category4Id = value;
  }

  int get category3Id => _category3Id;

  set category3Id(int value) {
    _category3Id = value;
  }

  int get category2Id => _category2Id;

  set category2Id(int value) {
    _category2Id = value;
  }

  int get category1Id => _category1Id;

  set category1Id(int value) {
    _category1Id = value;
  }

  String get nameEn => _nameEn;

  set nameEn(String value) {
    _nameEn = value;
  }

  String get nameKr => _nameKr;

  set nameKr(String value) {
    _nameKr = value;
  }


}

class EquipList {
  List<Equipment> equips = List<Equipment>.empty();

  EquipList() {}
  EquipList.set(List<Equipment> equipList) {
    List<Equipment> emptyList = [];
    equipList.forEach((element) {
      emptyList.add(element);
    });
    equips = emptyList;
  }

  factory EquipList.fromJson(List<dynamic> parsedJson) {
    List<Equipment> equips = List<Equipment>.empty(growable: true); // []와 같다.
    equips = parsedJson.map((i)=>Equipment.fromJson(i)).toList();
    return new EquipList.set(
      equips,
    );
  }
}