import 'dart:io';

import 'package:audio_stories/pages/main_pages/models/model_user.dart';
import 'package:audio_stories/pages/profile_pages/profile_page/profile_page.dart';
import 'package:audio_stories/resources/app_icons.dart';
import 'package:audio_stories/utils/utils.dart';
import 'package:audio_stories/widgets/background.dart';
import 'package:audio_stories/widgets/number_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  static const routName = '/editProfile';

  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _editNumberController = TextEditingController();
  final TextEditingController _editNameController = TextEditingController();

  File? _image;
  String? url;

  Future pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() => _image = File(image.path));
  }

  Future uploadImage(File _image) async {
    Reference reference = FirebaseStorage.instance.ref().child(
          ModelUser.uid.toString(),
        );

    await reference.putFile(_image);
    String downloadUrl = await reference.getDownloadURL();

    await ModelUser.createData('photo', downloadUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: Background(
                height: 375.0,
                image: AppIcons.up,
                child: Align(
                  alignment: const AlignmentDirectional(-1.1, -0.9),
                  child: IconButton(
                    onPressed: () {
                      Utils.globalKey.currentState!
                          .pushReplacementNamed(ProfilePage.routName);
                    },
                    icon: Image.asset(AppIcons.back),
                    iconSize: 60.0,
                  ),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
        StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(ModelUser.uid)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                String? url = snapshot.data.data()['photo'];
                String? name = snapshot.data.data()['name'];
                return Center(
                  child: Column(
                    children: [
                      const Spacer(
                        flex: 3,
                      ),
                      const Expanded(
                        flex: 4,
                        child: Text(
                          'Профиль',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 36.0,
                            letterSpacing: 3.0,
                          ),
                        ),
                      ),
                      const Expanded(
                        flex: 2,
                        child: Text(
                          'Твоя частичка',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                      const Spacer(
                        flex: 4,
                      ),
                      Container(
                        width: 228.0,
                        height: 228.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.0),
                          image: DecorationImage(
                            colorFilter: const ColorFilter.srgbToLinearGamma(),
                            image: (() {
                              if (url == null) {
                                return Image.asset(AppIcons.photo).image;
                              } else if (_image == null) {
                                return Image.network(url).image;
                              } else {
                                return Image.file(_image!).image;
                              }
                            }()),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 5.0,
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Image.asset(AppIcons.camera),
                          onPressed: () {
                            pickImage();
                          },
                        ),
                      ),
                      const Spacer(
                        flex: 3,
                      ),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(70.0, 0.0, 70.0, 0.0),
                          child: TextFormField(
                            controller: _editNameController,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24.0,
                            ),
                            decoration: InputDecoration(
                              hintText: name == null
                                  ? 'Ваше имя'
                                  : snapshot.data.data()['name'],
                            ),
                          ),
                        ),
                      ),
                      const Spacer(
                        flex: 4,
                      ),
                      Expanded(
                        flex: 6,
                        child: NumberForm(
                          controller: _editNumberController,
                          hintText: ModelUser.profilePhoneNumber,
                        ),
                      ),
                      const Spacer(
                        flex: 2,
                      ),
                      Expanded(
                        flex: 3,
                        child: TextButton(
                          onPressed: () {
                            if (_editNameController.text != '') {
                              ModelUser.createData(
                                  'name', _editNameController.text);
                            }
                            Utils.globalKey.currentState!
                                .pushReplacementNamed(ProfilePage.routName);
                            if (_image != null) {
                              uploadImage(_image!);
                            }
                          },
                          child: const Text(
                            'Сохранить',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(
                        flex: 5,
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ],
    );
  }
}



