import 'package:book_lo/widgets/post_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../apis/book.dart';
import '../utility/color_palette.dart';

class SearchPost extends SearchDelegate {
  @override
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
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('general')
          .orderBy('createdAt')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        final filtered = snapshot.data?.docs
            .where(
              (doc) =>
          doc['title'].toString().contains(query) ||
              doc['status'].toString().contains(query) ||
              doc['category'].toString().contains(query),
        )
            .toList();
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return filtered?.length == 0
            ? Center(
          child: Text("Value Not Foubd"),
        )
            : ListView.builder(
          itemCount: filtered?.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> data =
            filtered?[index].data() as Map<String, dynamic>;
            final post = Book.fromMap(data);
            return BuildPostCard(
                post: post,
                isRequested:
                post.status == 'request' || post.status == 'offer');
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}