import 'package:book_lo/utility/color_palette.dart';
import 'package:book_lo/widgets/Profile_header.dart';
import 'package:book_lo/widgets/profile_stat.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  int selectdTab = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Book Lo"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ProfileHeader(
              name: "Noman Ahmad",
              cityName: "Lahore, Pakistan",
              imgUrl: "assets/images/empty_profile.png",
            ),
          ),
          SliverToBoxAdapter(
            child: ProfileStat(
              offer: 10,
              request: 10,
              likes: 100,
            ),
          ),
          SliverToBoxAdapter(
            child: TabBar(
              controller: _tabController,
              unselectedLabelColor: Colors.black,
              labelColor: ColorPlatte.primaryColor,
              indicatorColor: ColorPlatte.primaryColor,
              onTap: (index) {
                setState(() {
                  selectdTab = index;
                });
              },
              tabs: [
                Tab(
                  text: "Offer",
                ),
                Tab(
                  text: "Request",
                ),
              ],
            ),
          ),
          _buildTabBody(),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildTabBody() {
    return SliverToBoxAdapter(
      child: selectdTab == 0 ? Text("Offer") : Text("Request"),
    );
  }
}
