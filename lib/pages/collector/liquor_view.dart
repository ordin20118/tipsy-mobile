import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';
import 'package:tipsy_mobile/classes/Liquor.dart';
import 'package:tipsy_mobile/classes/util.dart';
import 'package:tipsy_mobile/classes/ui_util.dart';

import '../../requests/liquor.dart';

class LiquorListView extends StatefulWidget {
  LiquorListView(BuildContext context, {Key? key, required this.liquorScrollController}) : super(key: key);

  LiquorScrollController? liquorScrollController;

  @override
  _LiquorListViewState createState() => _LiquorListViewState();
}

class _LiquorListViewState extends State<LiquorListView> {

  LiquorScrollController _liquorScrollController = LiquorScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 0.0),
      child: Obx(() =>
        ListView.separated(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          controller: _liquorScrollController.scrollController.value,
          itemCount: _liquorScrollController.data.length,
          itemBuilder: (BuildContext context, index) {
            return liquorItemBuilder(context, index);
          },
          separatorBuilder: (BuildContext context, int index) => const VerticalDivider(
            thickness: 0.3,
            width: 1,
            indent: 10,
            endIndent: 30,
            color: Colors.grey
          ),
        )
      ),
    );
  }

  // 댓글 리스트의 하나의 요소 디자인
  Widget liquorItemBuilder(context, index) {
    return GestureDetector(
      onTap: (() {
        goToLiquorDetailPage(context, _liquorScrollController.data[index].liquorId);
      }),
      child: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.2,
        child: makeLiquorListItem(_liquorScrollController.data[index], context),
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    log("[LiquorListView initState]");
    if(widget.liquorScrollController != null) {
      _liquorScrollController = widget.liquorScrollController!;
    }
    log("[LiquorListView initState]-liquorList size:" + _liquorScrollController.data.length.toString());
  }

  @override
  void dispose() {
    super.dispose();
  }
}

Widget makeLiquorListItem(liquor, context) {
  return Container(
    child: Column(
      children: [
        Flexible(
          flex: 6,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(0.0),
            child:Image.network(
              liquor.repImgUrl,
              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                return Image.asset(
                  'assets/images/default_image.png',
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
        ),
        Flexible(
          flex: 3,
          child: Container(
            //color: Colors.red,
            padding: const EdgeInsets.fromLTRB(10.0, 5.0, 5.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        liquor.nameKr,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        liquor.nameEn,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class LiquorScrollController extends GetxController {
  var scrollController = ScrollController().obs;
  var data = <Liquor>[].obs;
  var nowPage = 2;
  var perPage = 5;
  var isLoading = false.obs;
  var hasMore = true.obs;
  var contentType;
  var contentId;

  void setData(List<Liquor> data, int contentType, int contentId) {
    this.data.clear();
    this.data = data.obs;
    this.contentType = contentType;
    this.contentId = contentId;
    this.nowPage = 2;
    this.isLoading = false.obs;
    this.hasMore = true.obs;
  }

  @override
  void onInit() {
    // set listener
    scrollController.value.addListener(() async {
      // more load data
      //log("[${scrollController.value.position.pixels}][${scrollController.value.position.maxScrollExtent}]");
      if(scrollController.value.position.pixels == scrollController.value.position.maxScrollExtent
          && hasMore.value && !isLoading.value) {

        isLoading = true.obs;

        // load comments
        List<Liquor> liquors = await requestLastViewLiquors(nowPage);

        if(liquors.length > 0) {
          data.addAll(liquors);
          if(liquors.length >= perPage) {
            hasMore = true.obs;
            nowPage++;
          } else {
            hasMore = false.obs;
          }
        } else {
          hasMore = false.obs;
        }
        isLoading = false.obs;
      }
    });
    super.onInit();
  }
}