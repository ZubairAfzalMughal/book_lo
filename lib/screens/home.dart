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
  String query = "offer";
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
              preferredSize: Size(double.infinity, 100.0),
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
                                query = _search[index];
                              },
                            ),
                          );
                        },
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

              final posts = snapshot.data!.docs;
              final filtered = posts
                  .where(
                    (search) =>
                        search['category'].toString().contains(query) &&
                        search['userId'] !=
                            FirebaseAuth.instance.currentUser!.uid,
                  )
                  .toList();
              return filtered.length == 0
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: Text("No Posts Found"),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          Map<String, dynamic> data =
                              filtered[index].data()! as Map<String, dynamic>;
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

//body: Column(
//   crossAxisAlignment: CrossAxisAlignment.start,
//   children: [
//     Container(
//       height: 55.0,
//       decoration: BoxDecoration(
//         color: ColorPlatte.primaryColor,
//       ),
//       child: _buildSearchbar(context),
//     ),
//     Container(
//       height: 53.0,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: _search.length,
//         itemBuilder: (ctx, index) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(vertical: 8.0),
//             child: BuildCategory(
//               text: _search[index],
//               isSelected: selectedIndex == index,
//               onTap: () {
//                 setState(() {
//                   selectedIndex = index;
//                 });
//                 query = _search[index];
//               },
//             ),
//           );
//         },
//       ),
//     ),
//     StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('general')
//           .orderBy('createdAt', descending: true)
//           .snapshots(),
//       builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return HomeShimmer();
//         }
//         final posts = snapshot.data!.docs;
//         final filtered = posts
//             .where(
//               (search) =>
//                   search['category'].toString().contains(query) &&
//                   search['userId'] !=
//                       FirebaseAuth.instance.currentUser!.uid,
//             )
//             .toList();
//         return Expanded(
//           //Logic to show the header in ListView
//           child: filtered.length == 0
//               ? Center(
//                   child: Text("No Posts Found"),
//                 )
//               : ListView.builder(
//                   itemCount: filtered.length,
//                   scrollDirection: Axis.vertical,
//                   itemBuilder: (context, index) {
//                     Map<String, dynamic> data =
//                         filtered[index].data()! as Map<String, dynamic>;
//                     final post = Book.fromMap(data);
//                     return BuildPostCard(
//                         post: post,
//                         isRequested: post.userId !=
//                             FirebaseAuth.instance.currentUser!.uid);
//                   },
//                 ),
//         );
//       },
//     ),
//   ],
// ),
