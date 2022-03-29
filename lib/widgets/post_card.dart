import 'package:book_lo/apis/book.dart';
import 'package:book_lo/screens/chat_screen.dart';
import 'package:book_lo/utility/color_palette.dart';
import 'package:book_lo/widgets/animated_routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class BuildPostCard extends StatefulWidget {
  final Book post;
  bool isRequested = false;

  BuildPostCard({Key? key, required this.post, required this.isRequested});

  @override
  State<BuildPostCard> createState() => _BuildPostCardState();
}

class _BuildPostCardState extends State<BuildPostCard> {
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
        .doc(widget.post.userId)
        .get();
  }

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
                imageUrl: widget.post.imgUrl,
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
                            text: widget.post.title,
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
                        widget.post.description,
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
                            widget.post.status,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        if (widget.isRequested)
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                AnimatedRoutes(
                                  routeWidget: ChatScreen(
                                    receiverId: widget.post.userId,
                                  ),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.chat,
                            ),
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
                          widget.post.category,
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
}
