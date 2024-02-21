import 'package:flutter/material.dart';

class TipsyLoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 원하면 다른 형태로도 구성 가능
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child:Image.asset(
                'assets/images/loading_icon.gif',
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.width * 0.2
            ),
          ),
          // SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
          // Text(
          //   'loading',
          //   style: TextStyle(
          //
          //   ),
          // )
        ],
      )
    );
  }
}