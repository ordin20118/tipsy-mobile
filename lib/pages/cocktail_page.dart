import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tipsy_mobile/classes/liquor.dart';
import 'package:tipsy_mobile/classes/util.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CocktailDetail extends StatefulWidget {
  const CocktailDetail({Key? key, required this.liquorId}) : super(key: key);

  final int liquorId;

  @override
  _CocktailDetailState createState() => _CocktailDetailState();
}

class _CocktailDetailState extends State<CocktailDetail> {

  late Future<Liquor> liquor;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 3,
        title: Text(''),
        backgroundColor: Colors.white,
        actions: [],
        leading: GestureDetector(
          child: Icon( Icons.arrow_back_ios, color: Colors.black, ),
          onTap: () {
            Navigator.pop(context);
          } ,
        ),
        leadingWidth: MediaQuery.of(context).size.width * 0.1,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: FutureBuilder<Liquor>(
            future: liquor,
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Row(
                          children: [
                            Image.network(
                              makeImgUrl(snapshot.data!.repImg, 300),
                              height: MediaQuery.of(context).size.height * 0.17,
                            ),
                          ],
                        )

                      ],
                    )
                  ],
                );
              } else if(snapshot.hasError) {
                return Text('데이터를 불러오지 못했습니다.${snapshot.error}');
              }
              return const CircularProgressIndicator();
            }
          ),
        ),
      ),
      bottomNavigationBar: Container(height: 0.0),
    );
  }

  // request liquor get API
  Future<Liquor> loadLiquorInfo(int liquorId) async {
    print("#### [getLiquorInfo] ####");
    String reqUrl = getApiUrl() + "/liquor.tipsy?liquorId=" + liquorId.toString();
    final Uri url = Uri.parse(reqUrl);

    final response = await http.get(url);
    if(response.statusCode == 200) {
      String resString = response.body.toString();
      var resJson = json.decode(resString);
      var liquorJson = resJson['data']['item'];
      Liquor tmp = Liquor.fromJson(liquorJson);
      return tmp;
    } else {
      throw Exception('Failed to load liquor data.');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    print("주류 상세 페이지" + widget.liquorId.toString());
    liquor = loadLiquorInfo(widget.liquorId);
  }


}