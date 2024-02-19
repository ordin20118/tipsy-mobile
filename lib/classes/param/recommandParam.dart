import 'dart:developer';

import 'package:flutter/cupertino.dart';

class RecommandParam {
  double _priceMin = 0.0, _priceMax = 0.0;
  double _abvMin = 0.0, _abvMax = 0.0;
  String _tastingNotes = "";

  double get priceMin => _priceMin;

  set priceMin(double value) {
    _priceMin = value;
  }

  get priceMax => _priceMax;

  set priceMax(value) {
    _priceMax = value;
  }

  String get tastingNotes => _tastingNotes;

  set tastingNotes(String value) {
    _tastingNotes = value;
  }

  get abvMax => _abvMax;

  set abvMax(value) {
    _abvMax = value;
  }

  double get abvMin => _abvMin;

  set abvMin(double value) {
    _abvMin = value;
  }
}