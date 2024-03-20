import 'dart:developer';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tipsy_mobile/classes/util.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../classes/post.dart';
import '../../classes/ui_util.dart';
import '../../classes/styles.dart';
import '../../classes/user.dart';
import '../../requests/post.dart';
import '../../requests/user.dart';
import '../../ui/tipsy_loading_indicator.dart';
import '../../ui/tipsy_refresh_indicator.dart';


class NewsFeedPage extends StatefulWidget {
  const NewsFeedPage({Key? key}) : super(key: key);

  @override
  _NewsFeedPageState createState() => _NewsFeedPageState();
}

class _NewsFeedPageState extends State<NewsFeedPage> {

  NewsFeedScrollController _newsFeedScrollController = NewsFeedScrollController();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: _refreshData,
        child: buildNewsFeedPage(context),
    );
  }

  Widget buildNewsFeedPage(BuildContext context) {
    return Container(
      color: getCommonBackColor(),
      height: MediaQuery.of(context).size.height * 0.77,
      child: Obx(() =>
        Padding(
          padding: EdgeInsets.all(0.0),
          child: ListView.separated(
            shrinkWrap: true,
            controller: _newsFeedScrollController.scrollController.value,
            itemCount: _newsFeedScrollController.data.length,
            itemBuilder: (BuildContext context, index) {
              return newsFeedItemBuilder(context, index);
            },
            separatorBuilder: (BuildContext context, int index) => const Divider(
                height: 10,
                color: Colors.transparent
            ),
          ),
        )
      ),
    );
  }

  Widget newsFeedItemBuilder(context, index) {
    return Container(
      color: Colors.white,
      child: makePostListItem(context, _newsFeedScrollController.data[index]),
    );
  }

  Widget makePostListItem(BuildContext context, Post post) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(13),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child:Image.network(
                    post.userProfileUrl,
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                )
              ),
              Expanded(
                flex: 13,
                child: Text(
                  post.userNickname,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Icon(Icons.more_horiz),
            ]
          ),
        ),
        makePostImageView(context, post),
        Container(
          padding: EdgeInsets.all(15),
          alignment: Alignment.topLeft,
          child: Text(
            post.content,
            //overflow: TextOverflow.ellipsis,
            //maxLines: 100,
            style: TextStyle(
                fontSize: 13,
                color: Colors.black54
            ),
          ),
        )
      ]
    );
  }

  Widget makePostImageView(BuildContext context, Post post) {
    PageController imagePageController = PageController(viewportFraction: 1.0, keepPage: true, initialPage: 0,);
    if(post.imageUrls != null && post.imageUrls.length > 0) {
      List<Widget> imageListWidget = [];
      for(var i=0; i<post.imageUrls.length; i++) {
        String imgUrl = post.imageUrls[i];
        var imageWidget = Container(
          child: Image.network(
            imgUrl,
            fit: BoxFit.cover,
          ),
        );
        imageListWidget.add(imageWidget);
      }
      return Column(
        children: [
          Container(
              child: AspectRatio(
                aspectRatio: 1,
                child: PageView.builder(
                  controller: imagePageController,
                  itemCount: post.imageUrls.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Image.network(
                        post.imageUrls[index],
                        fit: BoxFit.cover,
                      ),
                    );
                  }
                ),
              )
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          SmoothPageIndicator(
            controller: imagePageController,
            count: post.imageUrls.length,
            effect: ScrollingDotsEffect(
              activeStrokeWidth: 2.6,
              activeDotScale: 1.3,
              maxVisibleDots: 5,
              radius: 8,
              spacing: 10,
              dotHeight: 8,
              dotWidth: 8,
            ),
          )
        ],
      );
    } else {
      return Container();
    }
  }

  Future<void> _refreshData() async {
    log("refresh news feed");
    setState(() {
      fetchData();
    });
  }

  Future<void> fetchData() async {
    List<Post> newData = await requestNewsFeed(1);
    _newsFeedScrollController.setData(newData);
  }

  @override
  void initState() {
    super.initState();
    log("news feed page initState()");
    fetchData();
  }

}

class NewsFeedScrollController extends GetxController {
  var scrollController = ScrollController().obs;
  var data = <Post>[].obs;
  var nowPage = 2;
  var perPage = 5;
  var isLoading = false.obs;
  var hasMore = true.obs;

  void setData(List<Post> data) {
    this.data = data.obs;
  }

  @override
  void onInit() {
    // set listener
    scrollController.value.addListener(() async {
      // more load data
      //log("[${scrollController.value.position.pixels}][${scrollController.value.position.maxScrollExtent}]");
      if(scrollController.value.position.pixels ==
          scrollController.value.position.maxScrollExtent && hasMore.value) {

        // log("[리스트의 끝입니다.] - contentType:[" + contentType.toString() + "]/contentId:[" + contentId.toString() + "]");
        // log("[리스트의 끝입니다.] - nowPage:[" + nowPage.toString() + "]/perPage:[" + perPage.toString() + "]");

        // load Posts
        List<Post> posts = (await requestNewsFeed(nowPage)).cast<Post>();

        if(posts.length > 0) {
          data.addAll(posts);
          if(posts.length >= perPage) {
            hasMore = true.obs;
            nowPage++;
          } else {
            hasMore = false.obs;
          }
        }
      }
    });
    super.onInit();
  }
}


