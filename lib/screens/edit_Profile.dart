import 'package:book_lo/apis/user.dart';
import 'package:book_lo/models/profile/edit_profile_model.dart';
import 'package:book_lo/models/user/user_model.dart';
import 'package:book_lo/utility/color_palette.dart';
import 'package:book_lo/widgets/edit_profile_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  final String name;

  const EditProfile({Key? key, required this.name}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController ageController = TextEditingController(text: "20");
  TextEditingController? nameController;
  List<String> interest = [
    "Science",
    "History",
    "Novel",
    "Arts",
    "Notes",
    "Poetry"
  ];
  List<String> selectedInterest = [];
  @override
  void initState() {
    nameController = TextEditingController(text: widget.name);
    super.initState();
  }

  @override
  void dispose() {
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Edit Profile"),
        actions: [
          IconButton(
            onPressed: () {
              final provider = context.read<UserProvider>();
              final edit = context.read<ProfileProvider>();
              provider.userStore
                  .doc(provider.auth.currentUser!.uid)
                  .update({'name': edit.name});
              Navigator.pop(context);
            },
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return Container(
          height: constraints.maxHeight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<DocumentSnapshot>(
                    future: Provider.of<UserProvider>(context, listen: false)
                        .getUser(),
                    builder:
                        (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Text("Loading....");
                      }
                      Map<String, dynamic> doc =
                          snapshot.data!.data() as Map<String, dynamic>;
                      final user = AppUser.fromDocument(doc);
                      return Consumer<ProfileProvider>(
                          builder: (_, profile, __) {
                        return EditProfileImage(
                          size: size,
                          imgProivder: user.imgUrl.isEmpty
                              ? Image.asset(
                                  'assets/images/empty_profile.png',
                                  height: 100.0,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  user.imgUrl,
                                  height: 100.0,
                                  width: 100.0,
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                ),
                          onTap: () {
                            profile.showHud();
                            profile.uploadToFirebase();
                            profile.offHud();
                          },
                        );
                      });
                    }),
                buildEditName(),
                buildEditAge(),
                Divider(
                  thickness: 1,
                  color: ColorPlatte.primaryColor,
                ),
                Text(
                  "Select interst",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
                ),
                Consumer<ProfileProvider>(builder: (_, edit, __) {
                  return Wrap(
                    children: edit.interest
                        .map(
                          (i) => ChoiceChip(
                            avatar: i.isSelected
                                ? Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  )
                                : Icon(
                                    Icons.cancel,
                                    color: Colors.black,
                                  ),
                            selectedColor: i.isSelected
                                ? ColorPlatte.primaryColor
                                : ColorPlatte.secondaryColor,
                            onSelected: (bool value) {
                              print("Choice Chip $value");
                              print("Array Value ${i.isSelected}");
                              if (value) {
                                edit.setInterest(i, value);
                              }
                            },
                            label: Text(
                              i.name,
                              style: TextStyle(
                                color:
                                    i.isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                            selected: i.isSelected,
                          ),
                        )
                        .toList(),
                  );
                }),
                Spacer(),
              ],
            ),
          ),
        );
      }),
    );
  }

  buildEditName() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Consumer<ProfileProvider>(builder: (_, edit, __) {
          return TextFormField(
            controller: nameController,
            onChanged: edit.editName,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              label: Text('Name'),
              labelStyle: TextStyle(color: Colors.black),
              errorBorder: ColorPlatte.inputBorder,
              focusedErrorBorder: ColorPlatte.inputBorder,
              enabledBorder: ColorPlatte.inputBorder,
              focusedBorder: ColorPlatte.inputBorder,
            ),
          );
        }));
  }

  buildEditAge() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Consumer<ProfileProvider>(
        builder: (_, edit, __) {
          return TextFormField(
            onChanged: edit.editAge,
            keyboardType: TextInputType.number,
            controller: ageController,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              errorText: ageController.text.length > 2 ? "Invalid Age" : null,
              label: Text('Age'),
              labelStyle: TextStyle(color: Colors.black),
              errorBorder: ColorPlatte.inputBorder,
              focusedErrorBorder: ColorPlatte.inputBorder,
              enabledBorder: ColorPlatte.inputBorder,
              focusedBorder: ColorPlatte.inputBorder,
            ),
          );
        },
      ),
    );
  }
}
