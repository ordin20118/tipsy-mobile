import 'package:flutter/cupertino.dart';

class Word {
  int _wordId;
  String _nameKr;
  String _nameEn;
  String _description;
  String _repImg;
  DateTime _regDate;
  late DateTime _updateDate;

  Word.set({
    required int wordId,
    required String nameKr,
    required String nameEn,
    required String description,
    required String repImg,
    required DateTime regDate,
  }) : this._wordId = wordId, this._nameKr = nameKr,
        this._nameEn = nameEn, this._description = description, this._repImg = repImg, this._regDate = regDate;


  factory Word.fromJson(Map<String, dynamic> json) {
    Word tmp = Word.set(
        wordId: json['word_id'],
        nameKr: json['name_kr'],
        nameEn: json['name_en'],
        description: json['description'],
        repImg: json['rep_img'],
        regDate: DateTime.fromMillisecondsSinceEpoch(json['reg_date'] * 1000)
    );

    // set late variable
    // description
    // update_date

    return tmp;
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

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get nameEn => _nameEn;

  set nameEn(String value) {
    _nameEn = value;
  }

  String get nameKr => _nameKr;

  set nameKr(String value) {
    _nameKr = value;
  }

  int get wordId => _wordId;

  set wordId(int value) {
    _wordId = value;
  }
}

class WordList {
  List<Word> words = List<Word>.empty();

  WordList() {}
  WordList.set(List<Word> wordList) {
    List<Word> emptyList = [];
    wordList.forEach((element) {
      emptyList.add(element);
    });
    words = wordList;
  }

  factory WordList.fromJson(List<dynamic> parsedJson) {
    List<Word> words = List<Word>.empty(growable: true); // []와 같다.
    words = parsedJson.map((i)=>Word.fromJson(i)).toList();
    return new WordList.set(
      words,
    );
  }
}