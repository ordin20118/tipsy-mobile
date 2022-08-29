import 'dart:developer';
import 'package:flutter/material.dart';

import '../main.dart';
import '../pages/login_page.dart';
import '../pages/cocktail_regist_page.dart';

List<Widget> makeStarUi(int count) {
  List<Widget> res = <Widget>[];
  for(int i=0; i<count; i++) {
    res.add(
        Icon(
          Icons.star,
          size: 18,
          color: Colors.yellow
        )
    );
  }
  return res;
}

void goToLoginPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => LoginPage()),
  );
}

void goToMainPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => MainPage()),
  );
}

void goToCocktailRegistPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => CocktailRegistPage()),
  );
}

