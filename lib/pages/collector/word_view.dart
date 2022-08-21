import 'package:flutter/material.dart';
import 'package:tipsy_mobile/classes/word.dart';
import 'package:tipsy_mobile/classes/util.dart';

//class
class WordListView extends StatefulWidget {
  WordListView({Key? key, required this.wordList}) : super(key: key);

  List<Word> wordList;

  @override
  _WordListViewState createState() => _WordListViewState();
}

class _WordListViewState extends State<WordListView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget wordItemBuilder(context, index) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height * 0.15,
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: makeWordListItem(widget.wordList[index].repImg, widget.wordList[index].nameKr,
            widget.wordList[index].nameEn, widget.wordList[index].description, context)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
            itemCount: widget.wordList.length,
            itemBuilder: (BuildContext context, index) {
              return wordItemBuilder(context, index);
            },
          separatorBuilder: (BuildContext context, int index) => const Divider(
            height: 2,
            color: Colors.grey
          ),
        ),
      ),
    );
  }

  List<Widget> makeWordListItem(img, nameKr, nameEn, desc, context) {

    List<Widget> list = [];

    if(img != 'default') {
      var imageWidget = Image.network(
        makeImgUrl(img, 300),
        height: MediaQuery.of(context).size.height * 0.13,
      );
      list.add(imageWidget);
    }

    var nameTextWidget =
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              nameKr+" ",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black
              ),
            ),
            Text(
              nameEn,
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey
              ),
            )
          ],
        );
    list.add(nameTextWidget);

    var descTextWidget = Expanded(
      child: Text(
        "   " + desc,
        //overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontSize: 12,
            color: Colors.grey
        ),
      ),
    );
    list.add(descTextWidget);

    return list;
  }
}