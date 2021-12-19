import 'package:book_lo/models/Post/post_model.dart';
import 'package:book_lo/utility/color_palette.dart';
import 'package:book_lo/widgets/sample_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class AddBook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Add Book"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<PostProvider>(builder: (_, book, __) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(),
              _buildDesc(),
              Text(
                "Status",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ListTile(
                title: const Text('Request'),
                leading: Radio<Status>(
                  value: Status.request,
                  groupValue: book.status,
                  onChanged: book.setStatus,
                ),
              ),
              ListTile(
                title: const Text('Offer'),
                leading: Radio<Status>(
                  value: Status.offer,
                  groupValue: book.status,
                  onChanged: book.setStatus,
                ),
              ),
              Text(
                "Category",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Wrap(
                children: book.catList
                    .map(
                      (b) => GestureDetector(
                        onTap: () {
                          book.setCategory(b);
                          print(book.category);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: b == book.category
                                  ? ColorPlatte.primaryColor
                                  : Colors.transparent,
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(25.0)),
                          padding: EdgeInsets.all(10.0),
                          margin: EdgeInsets.all(5.0),
                          child: Text(
                            b,
                            style: TextStyle(
                              color: b == book.category
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              Text(
                "Upload Image",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("img00001.jpg"),
                  IconButton(
                    icon: Icon(
                      Icons.camera_alt,
                      color: ColorPlatte.primaryColor,
                      size: 30.0,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              Spacer(),
              Container(
                width: double.infinity,
                child: SampleButton(
                  text: 'Upload',
                  onPressed: () {
                    //TODO: implement add book Logic here
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  _buildTitle() => TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (value) {},
        decoration: InputDecoration(
          filled: true,
          errorBorder: ColorPlatte.inputBorder,
          focusedErrorBorder: ColorPlatte.inputBorder,
          hintText: 'title',
        ),
      );
  _buildDesc() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: (value) {},
          decoration: InputDecoration(
            filled: true,
            errorBorder: ColorPlatte.inputBorder,
            focusedErrorBorder: ColorPlatte.inputBorder,
            hintText: 'Description',
          ),
        ),
      );
}
