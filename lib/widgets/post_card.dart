import 'package:book_lo/apis/book.dart';
import 'package:book_lo/screens/chat_screen.dart';
import 'package:book_lo/utility/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class BuildPostCard extends StatelessWidget {
  final Book post;
  bool isRequested = false;

  BuildPostCard({Key? key, required this.post, required this.isRequested});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: 180.0,
      padding: EdgeInsets.all(8.0),
      child: Card(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: CachedNetworkImage(
                imageUrl: post.imgUrl,
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
                    Text(
                      post.title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                    Expanded(
                      child: Text(
                        post.description,
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
                            post.status,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        if (isRequested)
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChatScreen(
                                    receiverId: post.userId,
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
                          post.category,
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
