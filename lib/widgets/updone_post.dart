import 'package:book_lo/screens/map_screen.dart';
import 'package:book_lo/utility/color_palette.dart';
import 'package:book_lo/widgets/animated_routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class UpDonePost extends StatefulWidget {
  final Map<String, dynamic> post;
  bool isRequested = false;

  UpDonePost({Key? key, required this.post, required this.isRequested});

  @override
  State<UpDonePost> createState() => _UpDonePostState();
}

class _UpDonePostState extends State<UpDonePost> {
  @override
  void initState() {
    if (this.mounted) {
      getUserInfo().then((user) {
        setState(() {
          name = user['name'];
        });
      });
    }
    super.initState();
  }

  String name = "Loading...";

  Future<DocumentSnapshot> getUserInfo() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.post['userId'])
        .get();
  }

  final fireStore = FirebaseFirestore.instance;
  final fireAuth = FirebaseAuth.instance;
  double rating = 0.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180.0,
      padding: EdgeInsets.all(8.0),
      child: Card(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: CachedNetworkImage(
                imageUrl: widget.post['imgUrl'],
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 200.0,
                    color: Colors.grey,
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Colors.black,
                          fontFamily: GoogleFonts.montserrat().fontFamily,
                        ),
                        children: [
                          TextSpan(
                            text: widget.post['title'],
                          ),
                          TextSpan(
                            text: ' by ',
                            style: TextStyle(
                              color: ColorPlatte.primaryColor,
                            ),
                          ),
                          TextSpan(
                              text: name,
                              style: TextStyle(color: Colors.green)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.post['desc'],
                        maxLines: 2,
                        style: TextStyle(overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: ColorPlatte.primaryColor,
                            borderRadius: BorderRadius.circular(22.0),
                          ),
                          child: Text(
                            widget.post['bookStatus'],
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        widget.post['bookStatus'] == 'delivered'
                            ? Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                              )
                            : Text(""),
                        if (widget.post['bookStatus'] == 'pending')
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    AnimatedRoutes(
                                      routeWidget: MapScreen(
                                        senderId: widget.post['senderId'],
                                        receiverId: widget.post['receiverId'],
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.location_on,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  buildRatings(context);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius:
                                          BorderRadius.circular(12.0)),
                                  child: Text(
                                    "deliver",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      children: [
                        Text(
                          "Category ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.post['category'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ColorPlatte.primaryColor,
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
      ),
    );
  }

  buildRatings(context) {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.spaceBetween,
            title: Text(
              "Rate this User",
              textAlign: TextAlign.center,
            ),
            content: SizedBox(
              child: RatingBar.builder(
                minRating: 1,
                itemSize: 30.0,
                initialRating: 1,
                direction: Axis.horizontal,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (double rating) {
                  setState(() {
                    this.rating = rating;
                  });
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  //giving ratings
                  fireStore
                      .collection("ratings/${widget.post['receiverId']}/user")
                      .add(
                    {"ratings": this.rating.toInt()},
                  );
                  //approving post status for current user
                  fireStore
                      .collection(fireAuth.currentUser!.uid)
                      .doc(widget.post['postId'])
                      .update(
                          {"status": "delivered", "bookStatus": "delivered"});
                  //approving post status for receiver user
                  fireStore
                      .collection(widget.post['receiverId'])
                      .doc(widget.post['postId'])
                      .update(
                          {"status": "delivered", "bookStatus": "delivered"});
                  //approve general post status
                  fireStore
                      .collection('general')
                      .doc(widget.post['postId'])
                      .update({"status": "delivered"});
                  Navigator.pop(context);
                },
                child: Text("Not Now"),
              ),
              TextButton(
                onPressed: () {
                  //giving ratings
                  fireStore
                      .collection("ratings/${widget.post['receiverId']}/user")
                      .add(
                    {"ratings": this.rating.toInt()},
                  );
                  //approving post status for current user
                  fireStore
                      .collection(fireAuth.currentUser!.uid)
                      .doc(widget.post['postId'])
                      .update(
                          {"status": "delivered", "bookStatus": "delivered"});
                  //approving post status for receiver user
                  fireStore
                      .collection(widget.post['receiverId'])
                      .doc(widget.post['postId'])
                      .update(
                          {"status": "delivered", "bookStatus": "delivered"});
                  //approve general post status
                  fireStore
                      .collection('general')
                      .doc(widget.post['postId'])
                      .update({"status": "delivered"});
                  Navigator.pop(context);
                },
                child: Text("Submit"),
              ),
            ],
          );
        });
  }
}
