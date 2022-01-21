import 'dart:io';

import 'package:audio_stories/pages/auth_pages/auth_page/auth_page.dart';
import 'package:audio_stories/pages/main_pages/main_widgets/button_menu.dart';
import 'package:audio_stories/pages/main_pages/models/model_user.dart';
import 'package:audio_stories/pages/profile_pages/profile_page/edit_profile_page.dart';
import 'package:audio_stories/pages/profile_pages/profile_page/test_rieastore_page.dart';
import 'package:audio_stories/pages/welcome_pages/welcome_page/welcome_page.dart';
import 'package:audio_stories/resources/app_icons.dart';
import 'package:audio_stories/resources/utils.dart';
import 'package:audio_stories/widgets/background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  static const routName = '/profile';

  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? image;

  Future pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final imageTemporary = File(image.path);
    setState(() => this.image = imageTemporary);
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: const [
            Background(
              height: 375.0,
              image: AppIcons.up,
              child: Align(
                alignment: AlignmentDirectional(-1.1, -0.7),
                child: ButtonMenu(),
              ),
            ),
          ],
        ),
        Center(
          child: Column(
            children: [
              const SizedBox(
                height: 60.0,
              ),
              const Text(
                'Профиль',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 36.0,
                  letterSpacing: 3.0,
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              const Text(
                'Твоя частичка',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Container(
                width: 228.0,
                height: 228.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.0),
                  image: DecorationImage(
                    image: image != null
                        ? Image
                        .file(image!)
                        .image
                        : Image
                        .asset(AppIcons.owl)
                        .image,
                    fit: BoxFit.cover,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                ModelUser.name != null
                ? ModelUser.name!
                : 'Name',
                style: const TextStyle(
                  fontSize: 24.0,
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              PhysicalModel(
                color: Colors.white,
                elevation: 6.0,
                borderRadius: BorderRadius.circular(45.0),
                child: SizedBox(
                  width: 319.0,
                  height: 62.0,
                  child: Center(
                    child: Text(
                      ModelUser.profilePhoneNumber,
                      style: const TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              TextButton(
                onPressed: () {
                  Utils.globalKey.currentState!
                      .pushReplacementNamed(EditProfilePage.routName);
                },
                child: const Text(
                  'Редактировать',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextButton(
                onPressed: () {
                  Utils.globalKey.currentState!.pushReplacementNamed(
                      TestPage.routName);
                },
                child: const Text(
                  'Подписка',
                  style: TextStyle(
                    fontSize: 14.0,
                    decoration: TextDecoration.underline,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                width: 300.0,
                height: 24.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              const Text(
                '0/500 мб',
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      Utils.firstKey.currentState!
                          .pushReplacementNamed(AuthPage.routName);
                    },
                    child: const Text('authorization'),
                  ),
                  TextButton(
                    onPressed: () async {
                      User? user = FirebaseAuth.instance.currentUser;
                      print(user);
                      await user?.delete();
                      Utils.firstKey.currentState!
                          .pushReplacementNamed(WelcomePage.routName);
                    },
                    child: const Text(
                      'Удалить аккаунт',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Future<void> imageSetup(File image) async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  users.add({
    'image': image,
  });
}
