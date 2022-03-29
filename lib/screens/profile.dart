import 'package:book_lo/apis/user.dart';
import 'package:book_lo/app_shimmers/profile_header_shimmer.dart';
import 'package:book_lo/app_shimmers/profile_stat_shimmer.dart';
import 'package:book_lo/models/user/user_model.dart';
import 'package:book_lo/screens/edit_Profile.dart';
import 'package:book_lo/utility/color_palette.dart';
import 'package:book_lo/widgets/Profile_header.dart';
import 'package:book_lo/widgets/post_card.dart';
import 'package:book_lo/widgets/profile_stat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../apis/book.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  int selectdTab = 0;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: FutureBuilder<DocumentSnapshot>(
                future:
                    Provider.of<UserProvider>(context, listen: false).getUser(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ProfileHeaderShimmer();
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;
                  //Using User model
                  final user = AppUser.fromDocument(data);
                  return ProfileHeader(
                    icon: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditProfile(
                                name: user.name,
                              ),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.edit,
                          color: ColorPlatte.primaryColor,
                        )),
                    name: user.name,
                    cityName: user.location,
                    imgProvider: user.imgUrl.isEmpty
                        ? Image.asset(
                            'assets/images/empty_profile.png',
                            height: 100.0,
                            width: 100.0,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            user.imgUrl,
                            height: 100.0,
                            width: 100.0,
                            fit: BoxFit.cover,
                          ),
                  );
                }),
          ),
          SliverToBoxAdapter(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('general')
                  .where('userId',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                final offer = snapshot.data?.docs
                    .where((doc) => doc['status'] == 'offer')
                    .toList();
                final request = snapshot.data?.docs
                    .where((doc) => doc['status'] == 'request')
                    .toList();
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ProfileStatShimmer();
                }
                return ProfileStat(
                    ratings: 4,
                    offer: offer?.length ?? 0,
                    request: request?.length ?? 0);
              },
            ),
          ),
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            toolbarHeight: 0.0,
            expandedHeight: 0.0,
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: ColorPlatte.primaryColor,
              labelColor: ColorPlatte.primaryColor,
              tabs: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Offer"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Request"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("InProgress"),
                ),
              ],
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('general')
                  .where('userId',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                final offer = snapshot.data?.docs
                    .where((doc) => doc['status'] == 'offer')
                    .toList();
                final request = snapshot.data?.docs
                    .where((doc) => doc['status'] == 'request')
                    .toList();
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (snapshot.connectionState == ConnectionState.none) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Container(
                        height: 1000.0,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            //offer
                            Column(
                              children: offer!.map((o) {
                                final post = Book.fromMap(
                                    o.data() as Map<String, dynamic>);
                                return SizedBox(
                                  child: BuildPostCard(
                                    post: post,
                                    isRequested: post.userId !=
                                        FirebaseAuth.instance.currentUser!.uid,
                                  ),
                                );
                              }).toList(),
                            ),

                            //request
                            Column(
                              children: request!.map((r) {
                                final post = Book.fromMap(
                                    r.data() as Map<String, dynamic>);
                                return SizedBox(
                                  child: BuildPostCard(
                                    post: post,
                                    isRequested: post.userId !=
                                        FirebaseAuth.instance.currentUser!.uid,
                                  ),
                                );
                              }).toList(),
                            ),
                            //Improve
                            Text("hi"),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}
