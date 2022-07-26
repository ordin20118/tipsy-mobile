import 'package:flutter/material.dart';
import 'package:tipsy_mobile/main.dart';
import 'package:tipsy_mobile/pages/login_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

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
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/login_background.jpg'),
              fit: BoxFit.cover
          ),
        ),
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
    print("Splash Page initState()");
    checkAutoLogin();
  }

  void checkAutoLogin() async {
    final storage = new FlutterSecureStorage();

    await storage.deleteAll();
    //await storage.write(key:'is_auto_login', value:'true');

    String isAutoLogin = await storage.read(key: 'is_auto_login');
    if(isAutoLogin == 'true') {
      print("메인 페이지로 이동");
      // 메인 페이지로
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    } else {
      print("로그인 페이지로 이동");
      // 로그인 페이지로
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }
}