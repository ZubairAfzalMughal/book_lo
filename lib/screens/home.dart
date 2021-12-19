import 'package:book_lo/apis/book.dart';
import 'package:book_lo/models/Post/post_model.dart';
import 'package:book_lo/utility/color_palette.dart';
import 'package:book_lo/widgets/build_category.dart';
import 'package:book_lo/widgets/my_drawer.dart';
import 'package:book_lo/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:search_page/search_page.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  List<String> _search = [
    "Offered",
    "requested",
    "science",
    "history",
    "arts",
    "biology",
    "physics",
    "mathematics",
    "fiction",
    "computer",
  ];
  @override
  Widget build(BuildContext context) {
    final post = context.read<PostProvider>().post;
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text("Book Lo"),
        elevation: 0.0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 55.0,
            decoration: BoxDecoration(
              color: ColorPlatte.primaryColor,
            ),
            child: _buildSearchbar(context),
          ),
          Container(
            height: 55.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _search.length,
              itemBuilder: (ctx, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 17.0),
                  child: BuildCategory(
                    text: _search[index],
                    index: index,
                    onTap: () {},
                  ),
                );
              },
            ),
          ),
          Expanded(
            //Logic to show the header in ListView
            child: ListView.builder(
              itemCount: post.length + 1,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Request Books",
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 22.0),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            "See All",
                            style: TextStyle(color: ColorPlatte.primaryColor),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  index -= 1;
                  return BuildPostCard(
                    post: post[index],
                    isRequested: post[index].status == "requested",
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  _buildSearchbar(context) {
    final post = Provider.of<PostProvider>(context, listen: false).post;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => showSearch(
            context: context,
            delegate: SearchPage<Book>(
              failure: Center(
                child: Text('No Book found :('),
              ),
              builder: (post) {
                return BuildPostCard(
                  post: post,
                  isRequested: post.status == "requested",
                );
              },
              filter: (post) =>
                  [post.title, post.description, post.category, post.status],
              items: post,
            )),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 10.0,
              ),
              Icon(
                Icons.search,
                color: ColorPlatte.primaryColor,
              ),
              SizedBox(
                width: 5.0,
              ),
              Text("search.."),
            ],
          ),
        ),
      ),
    );
  }
}
