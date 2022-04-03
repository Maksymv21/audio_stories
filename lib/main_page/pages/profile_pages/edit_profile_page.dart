import 'dart:io';

import 'package:audio_stories/main_page/pages/profile_pages/profile_page.dart';
import 'package:audio_stories/resources/app_icons.dart';
import 'package:audio_stories/resources/app_images.dart';
import 'package:audio_stories/utils/local_db.dart';
import 'package:audio_stories/widgets/background.dart';
import 'package:audio_stories/widgets/dialog_profile.dart';
import 'package:audio_stories/widgets/number_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../main.dart';
import '../../../pages/auth_pages/auth_page.dart';
import '../../../pages/auth_pages/registration_page.dart';
import '../../main_page.dart';
import 'blocs/bloc_profile.dart';
import 'blocs/bloc_profile_event.dart';
import 'blocs/bloc_profile_state.dart';
import 'repository/profile_repository.dart';

class EditProfilePage extends StatelessWidget {
  static const routName = '/editProfile';

  EditProfilePage({Key? key}) : super(key: key);

  final TextEditingController _editNumberController = TextEditingController();
  final TextEditingController _editNameController = TextEditingController();

  void _save(BuildContext context, File? avatar) {
    if (_editNumberController.text != '') {
      _dialog(context);
    } else {
      context.read<ProfileBloc>().add(
            ProfileSaveChanges(
              avatar: avatar,
              name: _editNameController.text,
            ),
          );
      MainPage.globalKey.currentState!.pushReplacementNamed(
        ProfilePage.routName,
      );
    }
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
                image: AppImages.up,
                child: Align(
                  alignment: const AlignmentDirectional(
                    -1.1,
                    -0.9,
                  ),
                  child: IconButton(
                    onPressed: () {
                      MainPage.globalKey.currentState!
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
                  final String? _url = snapshot.data?.data()['imageURL'];
                  final String? _nameData = snapshot.data?.data()['name'];
                  ImageProvider _image = Image.asset(AppImages.photo).image;
                  File? _currentImage;
                  String _name = 'Ваше имя';

                  if (state is ProfileInitial) {
                    if (snapshot.hasData) {
                      if (_url != null) {
                        _image = Image.network(_url).image;
                      }
                      if (_nameData != null) {
                        _name = _nameData;
                        _editNameController.text = _nameData;
                      }
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
                            padding: const EdgeInsets.fromLTRB(
                              70.0,
                              0.0,
                              70.0,
                              0.0,
                            ),
                            child: TextFormField(
                              controller: _editNameController,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 24.0,
                              ),
                              decoration: InputDecoration(
                                hintText: _name == '' ? 'Ваше имя' : _name,
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
                            onPressed: () => _save(
                              context,
                              _currentImage,
                            ),
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

  Future<String?> _dialog(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => DialogProfile(
        title: 'Для замены номера нужно пройти пару шагов',
        onPressedNo: () {
          _editNumberController.text = '';
          Navigator.pop(context, 'Cancel');
        },
        onPressedYes: () {
          MyApp.firstKey.currentState!.pushNamedAndRemoveUntil(
            AuthPage.routName,
            (Route<dynamic> route) => false,
          );
          RegistrationPageText.header = 'Замена номера';
          IsChange.isChange = true;
        },
      ),
    );
  }
}
