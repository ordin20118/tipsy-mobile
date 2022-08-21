import 'package:tipsy_mobile/classes/liquor.dart';
import 'package:tipsy_mobile/classes/ingredient.dart';
import 'package:tipsy_mobile/classes/equipment.dart';
import 'package:tipsy_mobile/classes/word.dart';

class SearchResult {
  List<Liquor> _liquorList =[];
  List<Ingredient> _ingredientList =[];
  List<Equipment> _equipmentList =[];
  List<Word> _wordList =[];

  SearchResult() {}

  List<Word> get wordList => _wordList;

  set wordList(List<Word> value) {
    _wordList = value;
  }

  List<Equipment> get equipmentList => _equipmentList;

  set equipmentList(List<Equipment> value) {
    _equipmentList = value;
  }

  List<Ingredient> get ingredientList => _ingredientList;

  set ingredientList(List<Ingredient> value) {
    _ingredientList = value;
  }

  List<Liquor> get liquorList => _liquorList;

  set liquorList(List<Liquor> value) {
    _liquorList = value;
  }
}