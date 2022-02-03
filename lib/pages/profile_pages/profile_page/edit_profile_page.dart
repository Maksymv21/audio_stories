import 'dart:io';

import 'package:audio_stories/pages/profile_pages/blocs/bloc_profile.dart';
import 'package:audio_stories/pages/profile_pages/blocs/bloc_profile_event.dart';
import 'package:audio_stories/pages/profile_pages/blocs/bloc_profile_state.dart';
import 'package:audio_stories/pages/profile_pages/profile_page/profile_page.dart';
import 'package:audio_stories/pages/profile_pages/repository/profile_repository.dart';
import 'package:audio_stories/resources/app_icons.dart';
import 'package:audio_stories/utils/local_db.dart';
import 'package:audio_stories/utils/utils.dart';
import 'package:audio_stories/widgets/background.dart';
import 'package:audio_stories/widgets/number_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfilePage extends StatelessWidget {
  static const routName = '/editProfile';

  EditProfilePage({Key? key}) : super(key: key);

  final TextEditingController _editNumberController = TextEditingController();
  final TextEditingController _editNameController = TextEditingController();

  // File? _image;
  // String? url;
  //
  // Future pickImage() async {
  //   final image = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (image == null) return;
  //
  //   setState(() => _image = File(image.path));
  // }
  //
  // Future uploadImage(File _image) async {
  //   Reference reference = FirebaseStorage.instance.ref().child(
  //         ModelUser.uid.toString(),
  //       );
  //
  //   await reference.putFile(_image);
  //   String downloadUrl = await reference.getDownloadURL();
  //
  //   await ModelUser.createData('photo', downloadUrl);
  // }

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
        BlocProvider(
          create: (context) => ProfileBloc(
            profileRepository: ProfileRepository(
              firebaseStorage: FirebaseStorage.instance,
            ),
          ),
          child: StreamBuilder<Object>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(LocalDB.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                return BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, state) {
                  ImageProvider _image = Image.asset(AppIcons.photo).image;
                  File? _currentImage;
                  String? _name;

                  if (state is ProfileInitial) {
                    if (snapshot.hasData) {
                      String url = snapshot.data.data()['imageURL'];
                      _image = Image.network(url).image;

                      _name = snapshot.data.data()['name'];
                      _editNameController.text = _name ?? 'Ваше имя';
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }
                  if (state is ProfileChangeAvatar) {
                    _image = Image.file(state.avatar).image;
                    _currentImage = state.avatar;
                  }
                  if (state is ProfileLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
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
                              colorFilter:
                                  const ColorFilter.srgbToLinearGamma(),
                              image: _image,
                              // (() {
                              //   if (url == null && _image == null) {
                              //     return Image.asset(AppIcons.photo).image;
                              //   }
                              //   if (_image == null) {
                              //     return Image.network(url!).image;
                              //   } else {
                              //     return Image.file(_image!).image;
                              //   }
                              // }()),
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
                              context.read<ProfileBloc>().add(
                                    ProfileOpenImagePicker(),
                                  );
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
                                hintText: _name ?? 'Ваше имя',
                              ),
                            ),
                          ),
                        ),
                        const Spacer(
                          flex: 4,
                        ),
                        Expanded(
                          flex: 5,
                          child: NumberForm(
                            controller: _editNumberController,
                            hintText: LocalDB.profileNumber,
                          ),
                        ),
                        const Spacer(
                          flex: 3,
                        ),
                        Expanded(
                          flex: 3,
                          child: TextButton(
                            onPressed: () {
                              context.read<ProfileBloc>().add(
                                    ProfileSaveChanges(
                                        avatar: _currentImage,
                                        name: _editNameController.text),
                                  );
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
                });
              }),
        ),
      ],
    );
  }
}
