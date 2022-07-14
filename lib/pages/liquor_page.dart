import 'package:flutter/material.dart';

class LiquorDetail extends StatefulWidget {
  const LiquorDetail({Key? key, required int liquorId}) : super(key: key);

  final int liquorId = 0;

  @override
  _LiquorDetailState createState() => _LiquorDetailState();
}

// request liquor get API


class _LiquorDetailState extends State<LiquorDetail> {

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
          child: Column(
            children: [

            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(height: 0.0),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    print("주류 상세 페이지" + widget.liquorId.toString());
  }
}