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
    "all",
    "science",
    "history",
    "arts",
    "biology",
    "physics",
    "mathematics",
    "fiction",
    "computer",
    "school",
    "college",
    "university"
  ];
  int selectedIndex = 0;
  String query = "all";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text("Book Lo"),
            elevation: 0.0,
            floating: true,
            bottom: PreferredSize(
              preferredSize: Size(double.infinity, 200.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  children: [
                    Container(
                      height: 55.0,
                      decoration: BoxDecoration(
                        color: ColorPlatte.primaryColor,
                      ),
                      child: _buildSearchbar(context),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("General"),
                          Container(
                            height: 53.0,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _search.length - 3,
                              itemBuilder: (ctx, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: BuildCategory(
                                    text: _search[index],
                                    isSelected: selectedIndex == index,
                                    onTap: () {
                                      setState(() {
                                        selectedIndex = index;
                                      });
                                      query = _search[index];
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                          Text("Subject Wise"),
                          Container(
                            height: 53.0,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _search.length,
                              itemBuilder: (ctx, index) {
                                if (index > 8)
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: BuildCategory(
                                      text: _search[index],
                                      isSelected: selectedIndex == index,
                                      onTap: () {
                                        setState(() {
                                          selectedIndex = index;
                                        });
                                        query = _search[index];
                                      },
                                    ),
                                  );
                                return SizedBox();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('general')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverToBoxAdapter(
                  child: HomeShimmer(),
                );
              } else if (snapshot.connectionState == ConnectionState.none) {
                return SliverToBoxAdapter(
                  child: Text("Error"),
                );
              }

              final posts = snapshot.data!.docs
                  .where((q) =>
                      q['userId'] != FirebaseAuth.instance.currentUser!.uid &&
                      q['status'] != 'pending' &&
                      q['status'] != 'delivered')
                  .toList();
              final filtered = posts
                  .where((search) => search['category']
                      .toString()
                      .toLowerCase()
                      .contains(query.toLowerCase()))
                  .toList();
              return filtered.length == 0 && posts.length == 0
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: Text("No Posts Found"),
                      ),
                    )
                  : query == 'all'
                      ? SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              Map<String, dynamic> data =
                                  posts[index].data()! as Map<String, dynamic>;
                              final post = Book.fromMap(data);
                              return BuildPostCard(
                                  post: post,
                                  isRequested: post.userId !=
                                      FirebaseAuth.instance.currentUser!.uid);
                            },
                            childCount: posts.length,
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              Map<String, dynamic> data = filtered[index]
                                  .data()! as Map<String, dynamic>;
                              final post = Book.fromMap(data);
                              return BuildPostCard(
                                  post: post,
                                  isRequested: post.userId !=
                                      FirebaseAuth.instance.currentUser!.uid);
                            },
                            childCount: filtered.length,
                          ),
                        );
            },
          ),
        ],
      ),
      //
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
