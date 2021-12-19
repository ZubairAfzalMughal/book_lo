import 'package:book_lo/apis/book.dart';
import 'package:book_lo/screens/chat_screen.dart';
import 'package:book_lo/utility/color_palette.dart';
import 'package:flutter/material.dart';

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
              child: Image.asset(
                post.imgUrl,
                fit: BoxFit.fill,
                alignment: Alignment.center,
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                  Container(
                    width: size.width * 0.8,
                    child: Text(
                      post.description,
                      maxLines: 3,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.only(top: 8.0),
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
                    Expanded(
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatScreen(),
                            ),
                          );
                        },
                        icon: Icon(Icons.message),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
