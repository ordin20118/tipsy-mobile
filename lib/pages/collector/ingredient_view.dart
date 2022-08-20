import 'package:flutter/material.dart';
import 'package:tipsy_mobile/classes/ingredient.dart';
import 'package:tipsy_mobile/classes/util.dart';

//class
class IngdListView extends StatefulWidget {
  IngdListView({Key? key, required this.ingdList}) : super(key: key);

  List<Ingredient> ingdList;

  @override
  _IngdListViewState createState() => _IngdListViewState();
}

class _IngdListViewState extends State<IngdListView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget ingdItemBuilder(context, index) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height * 0.15,
      child: Row(
        //alignment: Alignment.center,
        children: [
          Image.network(
            makeImgUrl(widget.ingdList[index].repImg, 300),
            height: MediaQuery.of(context).size.height * 0.13,
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              widget.ingdList[index].nameEn,
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey
              ),
            ),
          ),
        ]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
            itemCount: widget.ingdList.length,
            itemBuilder: (BuildContext context, index) {
              return ingdItemBuilder(context, index);
            },
          separatorBuilder: (BuildContext context, int index) => const Divider(
            height: 0.5,
            color: Colors.grey
          ),
        ),
      ),
    );
  }
}