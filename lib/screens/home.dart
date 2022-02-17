import 'package:book_lo/apis/book.dart';
import 'package:book_lo/app_shimmers/home_shimmer.dart';
import 'package:book_lo/utility/color_palette.dart';
import 'package:book_lo/widgets/build_category.dart';
import 'package:book_lo/widgets/my_drawer.dart';
import 'package:book_lo/widgets/post_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/search_post.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
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
            height: 53.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _search.length,
              itemBuilder: (ctx, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: BuildCategory(
                    text: _search[index],
                    isSelected: selectedIndex == index,
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('general')
                  .orderBy('createdAt')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return HomeShimmer();
                }
                final posts = snapshot.data!.docs;
                return Expanded(
                  //Logic to show the header in ListView
                  child: posts.length == 0
                      ? Center(
                          child: Text("No Posts Found"),
                        )
                      : ListView.builder(
                          itemCount: posts.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> data =
                                posts[index].data()! as Map<String, dynamic>;
                            final post = Book.fromMap(data);
                            return BuildPostCard(
                                post: post,
                                isRequested: post.userId !=
                                    FirebaseAuth.instance.currentUser!.uid);
                          },
                        ),
                );
              }),
        ],
      ),
    );
  }

  _buildSearchbar(context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          showSearch(
            context: context,
            delegate: SearchPost(),
          );
        },
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
