import 'package:flutter/material.dart';
import 'package:tipsy_mobile/classes/equipment.dart';
import 'package:tipsy_mobile/classes/util.dart';

//class
class EquipListView extends StatefulWidget {
  EquipListView({Key? key, required this.equipList}) : super(key: key);

  List<Equipment> equipList;

  @override
  _EquipListViewState createState() => _EquipListViewState();
}

class _EquipListViewState extends State<EquipListView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget equipItemBuilder(context, index) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height * 0.15,
      child: Row(
        //alignment: Alignment.center,
        children: [
          Image.network(
            makeImgUrl(widget.equipList[index].repImg, 300),
            height: MediaQuery.of(context).size.height * 0.13,
          ),
          Text(
            widget.equipList[index].nameEn,
            style: TextStyle(
                fontSize: 12,
                color: Colors.grey
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
            itemCount: widget.equipList.length,
            itemBuilder: (BuildContext context, index) {
              return equipItemBuilder(context, index);
            },
          separatorBuilder: (BuildContext context, int index) => const Divider(
            height: 2,
            color: Colors.grey
          ),
        ),
      ),
    );
  }
}