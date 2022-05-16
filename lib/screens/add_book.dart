import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:book_lo/models/Post/post_model.dart';
import 'package:book_lo/utility/color_palette.dart';
import 'package:book_lo/widgets/sample_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
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
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: SingleChildScrollView(
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
                          .sublist(0, 8)
                          .map(
                            (b) => GestureDetector(
                              onTap: () {
                                book.setCategory(b);
                              },
                              child: BuildCatSubWise(
                                  b: b, category: book.category),
                            ),
                          )
                          .toList(),
                    ),
                    Text(
                      "Subject Wise",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Wrap(
                      children: book.catList
                          .sublist(8, book.catList.length)
                          .map(
                            (b) => GestureDetector(
                              onTap: () {
                                book.setCategory(b);
                              },
                              child: BuildCatSubWise(
                                  b: b, category: book.category),
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
                            Icons.file_open,
                            color: ColorPlatte.primaryColor,
                            size: 30.0,
                          ),
                          onPressed: () {
                            //book.uploadImage();
                            _showOptionDialog();
                          },
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      child: SampleButton(
                        text: 'Upload',
                        onPressed: () {
                          if (book.title.isEmpty) {
                            toast('Select Title');
                            return;
                          }
                          if (book.desc.isEmpty) {
                            toast('Select Desc');
                            return;
                          }
                          if (book.status.isEmpty) {
                            toast('Select Status');
                            return;
                          }
                          if (book.category.isEmpty) {
                            toast('Select Category');
                            return;
                          }
                          if (book.file!.path.isEmpty) {
                            toast('Select Image');
                            return;
                          }

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
                              Text("${book.status} Uploaded Successfully"),
                              background: Colors.green[800],
                            );
                            // Adding Notification to show that A Post has been added
                            createBookNotification();
                          });
                        },
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  _showOptionDialog() {
    final img = context.read<PostProvider>();
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text("select options"),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ChooseCapture(
                  img: img,
                  icon: Icons.camera_alt,
                  text: "Open Camera",
                  context: context,
                  onPressed: () {
                    img.uploadImage(ImageSource.camera).then((_) {
                      Navigator.pop(context);
                    });
                  },
                ),
                SizedBox(
                  width: 10.0,
                ),
                ChooseCapture(
                  img: img,
                  context: context,
                  icon: Icons.collections,
                  text: "Open Gallery",
                  onPressed: () {
                    img.uploadImage(ImageSource.gallery).then((_) {
                      Navigator.pop(context);
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Back",
                  style: TextStyle(color: ColorPlatte.primaryColor),
                ),
              ),
            ],
          );
        });
  }

  createBookNotification() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().microsecond,
        channelKey: 'basic_channel',
        title: "Book Lo",
        body: "A new Book request/offer has been posted",
        displayOnBackground: true,
        displayOnForeground: true,
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

class BuildCatSubWise extends StatelessWidget {
  final String b;
  final String category;
  BuildCatSubWise({required this.b, required this.category});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: b == category ? ColorPlatte.primaryColor : Colors.transparent,
          border: Border.all(),
          borderRadius: BorderRadius.circular(25.0)),
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.all(5.0),
      child: Text(
        b,
        style: TextStyle(
          color: b == category ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}

class ChooseCapture extends StatelessWidget {
  const ChooseCapture(
      {Key? key,
      required this.img,
      required this.context,
      required this.onPressed,
      required this.text,
      required this.icon})
      : super(key: key);

  final PostProvider img;
  final BuildContext context;
  final VoidCallback onPressed;
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      leading: Icon(icon),
      title: Text(text),
    );
  }
}
