import 'dart:developer';
import 'package:flutter/material.dart';

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

