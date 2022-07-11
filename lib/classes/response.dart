import 'package:tipsy_mobile/classes/liquor.dart';
import 'package:tipsy_mobile/classes/ingredient.dart';

class SearchResult {
  List<Liquor> _liquorList =[];
  List<Ingredient> _ingredientList =[];
  List<Liquor> _equipmentList =[];
  List<Liquor> _wordList =[];

  SearchResult() {}

  List<Liquor> get wordList => _wordList;

  set wordList(List<Liquor> value) {
    _wordList = value;
  }

  List<Liquor> get equipmentList => _equipmentList;

  set equipmentList(List<Liquor> value) {
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