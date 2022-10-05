import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:tipsy_mobile/classes/liquor.dart';
import 'package:tipsy_mobile/classes/util.dart';
import 'package:tipsy_mobile/classes/ui_util.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LiquorDetail extends StatefulWidget {
  const LiquorDetail({Key? key, required this.liquorId}) : super(key: key);

  final int liquorId;

  @override
  _LiquorDetailState createState() => _LiquorDetailState();
}

class _LiquorDetailState extends State<LiquorDetail> {

  late Future<Liquor> liquor;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),
          onPressed: () { Navigator.pop(context);},
          color: Colors.black,
          iconSize: 25,
        ),
        titleSpacing: 3,
        title: Text(''),
        backgroundColor: Colors.white,
        actions: [
          IconButton(icon: Icon(Icons.ios_share),
            onPressed: () { Navigator.pop(context);},
            color: Colors.black,
            iconSize: 25,
          )
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: FutureBuilder<Liquor>(
            future: liquor,
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                return Column(
                  children: [
                    Container(  // image
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          makeImgWidget(context, snapshot.data!.repImg, 300, MediaQuery.of(context).size.height * 0.3),
                          // Image.network(
                          //   makeImgUrl(snapshot.data!.repImg, 300),
                          //   height: MediaQuery.of(context).size.height * 0.3,
                          // ),
                        ],
                      ),
                    ),
                    Container( // title, rating, abv ...
                      padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                  snapshot.data!.nameKr,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontFamily: 'NanumBarunGothicLight',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(6, 0, 6, 8),
                                child: Text(
                                  snapshot.data!.nameEn,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                    fontFamily: 'NanumBarunGothicLight',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(  // description
                      padding: EdgeInsets.all(15),
                      color: Colors.white,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Description",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              snapshot.data!.description,
                              style: TextStyle(
                                color: Colors.black54
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "History",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              snapshot.data!.history,
                              style: TextStyle(
                                color: Colors.black54
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              } else if(snapshot.hasError) {
                return Text('데이터를 불러오지 못했습니다.${snapshot.error}');
              }
              return Container(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Center(
                    child: CircularProgressIndicator()
                ),
              );
            }
          ),
        ),
      ),
      bottomNavigationBar: Container(height: 0.0),
    );
  }

  // request liquor get API
  Future<Liquor> loadLiquorInfo(int liquorId) async {
    print("#### [getLiquorInfo] ####" + liquorId.toString());
    String reqUrl = "/liquor.tipsy?liquorId=" + liquorId.toString();
    final response = await requestGET(reqUrl);

    if(response.statusCode == 200) {
      String resString = response.body.toString();
      var resJson = json.decode(resString);
      var liquorJson = resJson['data']['item'];

      Liquor tmp = Liquor.fromJson(liquorJson);

      print("[getLiquorInfo] desc:" + tmp.description);
      print("[getLiquorInfo] history:" + tmp.history);
      // TODO: null check
      if(tmp.description != null) {
        tmp.description = makeText(tmp.description);
      }

      if(tmp.history != null) {
        tmp.history = makeText(tmp.history);
      }


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