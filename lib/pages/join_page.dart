import 'package:flutter/material.dart';

class JoinPage extends StatefulWidget {
  const JoinPage({Key? key}) : super(key: key);

  @override
  _JoinPageState createState() => _JoinPageState();
}


class _JoinPageState extends State<JoinPage> {

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
    print("회원가입 화면");
  }
}