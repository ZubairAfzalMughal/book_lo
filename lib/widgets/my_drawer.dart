import 'package:book_lo/apis/user.dart';
import 'package:book_lo/app_shimmers/drawer_shimmer.dart';
import 'package:book_lo/models/user/user_model.dart';
import 'package:book_lo/screens/login.dart';
import 'package:book_lo/utility/color_palette.dart';
import 'package:book_lo/widgets/profile_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final provider = Provider.of<UserProvider>(context, listen: false);
    return Container(
      width: size.width * 0.6,
      child: Drawer(
        child: FutureBuilder<DocumentSnapshot>(
          future: provider.getUser(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return DrawerShimmer();
            }
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            final user = AppUser.fromDocument(data);
            return Column(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: ColorPlatte.primaryColor,
                  ),
                  child: UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      color: ColorPlatte.primaryColor,
                    ),
                    accountEmail: Text(user.email),
                    accountName: Text(user.name),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: user.imgUrl.isNotEmpty
                          ? ProfileImage(
                              imageProvider: Image.network(
                                user.imgUrl,
                                height: 100.0,
                                width: 100.0,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.asset(
                              'assets/images/empty_profile.png',
                              height: 100.0,
                              width: 100.0,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                Divider(
                  color: ColorPlatte.primaryColor,
                ),
                ListTile(
                  trailing: Icon(
                    Icons.phone,
                    color: ColorPlatte.primaryColor,
                  ),
                  title: Text(user.phoneNumber),
                ),
                Divider(
                  color: ColorPlatte.primaryColor,
                ),
                ListTile(
                  title: Text("verification"),
                  trailing: user.isVerified
                      ? Icon(
                          Icons.verified,
                          color: Colors.green,
                        )
                      : Tooltip(
                          message: 'please verify',
                          child: Icon(
                            Icons.cancel_outlined,
                            color: Colors.red,
                          ),
                        ),
                ),
                Divider(
                  color: ColorPlatte.primaryColor,
                ),
                ListTile(
                  trailing: Icon(
                    Icons.info,
                    color: ColorPlatte.primaryColor,
                  ),
                  title: Text("About Us"),
                ),
                Divider(
                  color: ColorPlatte.primaryColor,
                ),
                ListTile(
                  onTap: () {
                    provider.signOut().then((_) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Login(),
                          ),
                          (route) => false);
                    });
                  },
                  trailing: Icon(
                    Icons.logout,
                    color: ColorPlatte.primaryColor,
                  ),
                  title: Text("Logout"),
                ),
                Expanded(
                  child: Container(),
                ),
                ListTile(
                  trailing: Icon(
                    Icons.mobile_friendly,
                    color: ColorPlatte.primaryColor,
                  ),
                  title: Text("version 1.0"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
