import 'package:book_lo/widgets/post_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../apis/book.dart';
import '../utility/color_palette.dart';

class SearchPost extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
          color: ColorPlatte.primaryColor,
        ),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: ColorPlatte.primaryColor,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return query.isNotEmpty
        ? StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('general').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final docs = snapshot.data?.docs
                  .where((doc) =>
                      doc['title'].toString().contains(query) ||
                      doc['status'].toString().contains(query) ||
                      doc['category'].toString().contains(query))
                  .toList();
              return docs?.length == 0
                  ? Center(
                      child: Text("Value Not Found"),
                    )
                  : ListView.builder(
                      itemCount: docs?.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> data =
                            docs?[index].data() as Map<String, dynamic>;
                        final post = Book.fromMap(data);
                        return BuildPostCard(
                            post: post,
                            isRequested: post.status == 'request' ||
                                post.status == 'offer');
                      },
                    );
            },
          )
        : SizedBox();
  }
}
