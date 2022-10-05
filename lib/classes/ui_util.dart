import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../main.dart';
import '../classes/util.dart';
import '../pages/camera_page.dart';
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

void showToast(String message) {
  Fluttertoast.showToast(
    fontSize: 13,
    msg: '   $message   ',
    backgroundColor: Colors.black,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
  );
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

// TODO
void goToCameraPage(BuildContext context) async {
  final cameras = await availableCameras();
  final firstCamer = cameras.first;
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => CameraPage(camera: firstCamer,)),
  );
}


Image makeImgWidget(context, String filePath, int size, height) {

  List<String> pathArr = filePath.split("/");

  if(filePath.length == 0) {
    return Image.asset(
      'assets/images/default_image.png',
      height: MediaQuery.of(context).size.height * 0.17,
    );
  } else {
    return Image.network(
      makeImgUrl(filePath, size),
      height: height,
    );
  }

}
