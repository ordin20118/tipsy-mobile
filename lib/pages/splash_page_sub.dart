import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tipsy_mobile/classes/util.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CocktailRegistPage extends StatefulWidget {
  const CocktailRegistPage({Key? key}) : super(key: key);

  @override
  _CocktailRegistPageState createState() => _CocktailRegistPageState();
}

class _CocktailRegistPageState extends State<CocktailRegistPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(100),
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(1.0), BlendMode.dstATop
          ),
          image: AssetImage('assets/images/login_background.jpg'),
          fit: BoxFit.cover
        )
      ),
    );
  }
}
