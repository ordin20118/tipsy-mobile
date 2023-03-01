import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../main.dart';
import '../classes/util.dart';
import '../pages/camera_page.dart';
import '../pages/cocktail/cocktail_regist_page.dart';
import '../pages/login_page.dart';
import '../pages/join_page.dart';

const List<String> cocktailColors = [
  "#FFFAED7D",
  "#FF584B00",
  "#FFFF0000",
  "#FFFF5E00",
  "#FF662500",
  "#FFF6F6F8",
  "#FF86E57F",
  "#FF2F9D27",
  "#FFFFE400",
  "#FF1E0000",
  "#FF008299",
  "#FFFFB2D9",
  "#FFFAF4C0",
  "#FF80F2CA",
  "#FFDFE182",
];

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}


TextStyle boxMenuWhite = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold
);

TextStyle boxMenuPupple = TextStyle(
    color: Color(0xff8748E1),
    fontWeight: FontWeight.bold
);

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

// TODO: For Test
void goToJoinPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => JoinPage(platform: 0, email: '', nickname: ''
                                                    ,accessToken: '', refreshToken: '',)),
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

class BlankView extends StatefulWidget {
  const BlankView({Key? key, required Color this.color, required this.heightRatio}) : super(key: key);

  final Color color;
  final heightRatio;

  @override
  _BlankViewState createState() => _BlankViewState();
}

class _BlankViewState extends State<BlankView> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * widget.heightRatio,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: widget.color,
        ),
      ),
    );
  }
}

