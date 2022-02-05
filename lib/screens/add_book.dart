import 'package:book_lo/models/Post/post_model.dart';
import 'package:book_lo/utility/color_palette.dart';
import 'package:book_lo/widgets/sample_button.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

class AddBook extends StatefulWidget {
  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  final _titleController = TextEditingController();

  final _desController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Add Book"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer<PostProvider>(builder: (_, book, __) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(context),
                  _buildDesc(context),
                  ExpansionTile(
                    tilePadding: EdgeInsets.only(right: 5.0),
                    textColor: ColorPlatte.primaryColor,
                    initiallyExpanded: true,
                    iconColor: ColorPlatte.primaryColor,
                    collapsedIconColor: Colors.black,
                    collapsedTextColor: Colors.black,
                    title: Text(
                      "Select status",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    children: [
                      ListTile(
                        onTap: () {
                          book.setStatus("offer");
                        },
                        title: Text("Offer"),
                        trailing: book.status == "offer"
                            ? Icon(
                                Icons.check_circle,
                                color: ColorPlatte.primaryColor,
                              )
                            : Icon(Icons.check_circle),
                      ),
                      ListTile(
                        onTap: () {
                          book.setStatus("request");
                        },
                        title: Text("Request"),
                        trailing: book.status == "request"
                            ? Icon(
                                Icons.check_circle,
                                color: ColorPlatte.primaryColor,
                              )
                            : Icon(Icons.check_circle),
                      )
                    ],
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
                      Expanded(
                        child: Text(book.file?.path ?? ""),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.camera_alt,
                          color: ColorPlatte.primaryColor,
                          size: 30.0,
                        ),
                        onPressed: () {
                          book.uploadImage();
                        },
                      ),
                    ],
                  ),
                  isLoading
                      ? Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                ColorPlatte.primaryColor),
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          child: SampleButton(
                            text: 'Upload',
                            onPressed: () {
                              if (book.title.isEmpty &&
                                  book.desc.isEmpty &&
                                  book.category.isEmpty &&
                                  book.imgPath.isEmpty) {
                                toast('Select all options');
                              } else {
                                setState(() {
                                  isLoading = true;
                                });
                                book.uploadPost().then((value) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  book.clearPostValues();
                                  _titleController.clear();
                                  _desController.clear();
                                  showSimpleNotification(
                                    Text(
                                        "${book.status} Uploaded Successfully"),
                                    background: Colors.green[800],
                                  );
                                });
                              }
                            },
                          ),
                        ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  _buildTitle(BuildContext context) => TextFormField(
        controller: _titleController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: context.watch<PostProvider>().setTitle,
        decoration: InputDecoration(
          filled: true,
          errorBorder: ColorPlatte.inputBorder,
          focusedErrorBorder: ColorPlatte.inputBorder,
          hintText: 'title',
        ),
      );

  _buildDesc(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: TextFormField(
          controller: _desController,
          maxLength: 100,
          maxLines: 3,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: context.watch<PostProvider>().setDesc,
          decoration: InputDecoration(
            filled: true,
            errorBorder: ColorPlatte.inputBorder,
            focusedErrorBorder: ColorPlatte.inputBorder,
            hintText: 'Description',
          ),
        ),
      );
}
