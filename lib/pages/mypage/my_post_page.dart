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
import '../collector/comment_view.dart';


class MyPostPage extends StatefulWidget {
  const MyPostPage({Key? key}) : super(key: key);

  @override
  _MyPostPageState createState() => _MyPostPageState();
}

class _MyPostPageState extends State<MyPostPage> {

  FocusNode _focusNode = FocusNode();
  MyPostScrollController _myPostScrollController = Get.put<MyPostScrollController>(MyPostScrollController(), tag: "myPostList",);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: _refreshData,
        child: buildMyPostPage(context),
    );
  }

  Widget buildMyPostPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('나의 피드', style: TextStyle(color: Color(0xff005766), fontFamily: 'NanumBarunGothicBold')),
        //backgroundColor: Color(0xff005766),
        backgroundColor: Color(0xffffffff),
        actions: [],
      ),
      body: Container(
        color: getCommonBackColor(),
        height: MediaQuery.of(context).size.height * 0.875,
        child: Obx(() =>
            Padding(
              padding: EdgeInsets.all(0.0),
              child: ListView.separated(
                shrinkWrap: true,
                controller: _myPostScrollController.scrollController.value,
                itemCount: _myPostScrollController.data.length,
                itemBuilder: (BuildContext context, index) {
                  return myPostItemBuilder(context, index);
                },
                separatorBuilder: (BuildContext context, int index) => const Divider(
                    height: 10,
                    color: Colors.transparent
                ),
              ),
            )
        ),
      ),
      bottomNavigationBar: Container(height: 0,),
    );
  }

  Widget myPostItemBuilder(context, index) {
    return Container(
      color: Colors.white,
      child: makePostListItem(context, _myPostScrollController.data[index]),
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
                    errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                      return Image.asset(
                        'assets/images/default_profile.png',
                        fit: BoxFit.cover,
                      );
                    },
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
          padding: EdgeInsets.all(10),
          alignment: Alignment.topLeft,
          child: Text(
            post.content,
            //overflow: TextOverflow.ellipsis,
            //maxLines: 100,
            style: TextStyle(
                fontSize: 13,
                color: Colors.black87
            ),
          ),
        ),
        makePostToolView(context, post),
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
                        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                          return Image.asset(
                            'assets/images/default_image.png',
                            fit: BoxFit.cover,
                          );
                        },
                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Center(
                            child: TipsyLoadingIndicator(),
                          );
                        }
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

  Widget makePostToolView(BuildContext context, Post post) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if(post.like)
                  Icon(Icons.favorite, size: 25, color: Colors.red),
                if(!post.like)
                  Icon(Icons.favorite_border, size: 25, color: Colors.black54),
                SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                Text(post.likeCnt.toString()),
                SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                GestureDetector(
                  onTap: () {
                    TextEditingController _commentInputController = TextEditingController();
                    CommentScrollController _commentScrollController = Get.put<CommentScrollController>(CommentScrollController(), tag: "commentPreview_602_${post.id}",);
                    showCommentModal(context, _focusNode, _commentInputController, _commentScrollController, post.id, 602);
                  },
                  child: Icon(Icons.chat_bubble_outline, size: 22),
                ),

                SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                Text(post.commentCnt.toString()),
              ]
            ),
            Row(
              children: [

              ]
            )
          ]
        ),
      )
    );
  }

  Future<void> _refreshData() async {
    log("Refresh my posts.");
    setState(() {
      fetchData();
    });
  }

  Future<void> fetchData() async {
    List<Post> newData = await requestMyPost(1);
    _myPostScrollController.setData(newData);
  }

  @override
  void initState() {
    super.initState();
    log("My posts page initState()");
    fetchData();
  }

}

class MyPostScrollController extends GetxController {
  var scrollController = ScrollController().obs;
  var data = <Post>[].obs;
  var nowPage = 2;
  var perPage = 5;
  var isLoading = false.obs;
  var hasMore = true.obs;

  void setData(List<Post> data) {
    //this.scrollController = ScrollController().obs;
    this.data.clear();
    this.data = data.obs;
    this.nowPage = 2;
    this.isLoading = false.obs;
    this.hasMore = true.obs;
  }

  @override
  void onInit() {
    // set listener
    scrollController.value.addListener(() async {
      //log("${scrollController.value.position.pixels}/${scrollController.value.position.maxScrollExtent}");
      // more load data
      if(scrollController.value.position.pixels >=
          scrollController.value.position.maxScrollExtent && hasMore.value && !isLoading.value) {

        isLoading = true.obs;

        // load Posts
        List<Post> posts = (await requestMyPost(nowPage)).cast<Post>();

        if(posts.length > 0) {
          data.addAll(posts);
          if(posts.length >= perPage) {
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


