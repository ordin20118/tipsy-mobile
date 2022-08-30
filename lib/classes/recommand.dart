import 'dart:developer';

import 'package:flutter/cupertino.dart';

import 'equipment.dart';
import 'ingredient.dart';
import 'liquor.dart';

class Recommand {

  late List<Liquor> liquorList;
  //late List<Cocktail> cocktailList;
  late List<Ingredient> ingredientList;
  late List<Equipment> equipmentList;

  Recommand(){}

  factory Recommand.fromJson(Map<String, dynamic> json) {
    Recommand tmp = new Recommand();
    LiquorList liquorList = LiquorList.fromJson(json['liquor_list']);
    tmp.liquorList = liquorList.liquors;
    return tmp;
  }

}