import 'package:audio_stories/pages/main_pages/models/model_user.dart';
import 'package:audio_stories/pages/profile_pages/profile_page/profile_page.dart';
import 'package:audio_stories/resources/app_icons.dart';
import 'package:audio_stories/resources/utils.dart';
import 'package:audio_stories/widgets/background.dart';
import 'package:audio_stories/widgets/number_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatelessWidget {
  static const routName = '/editProfile';

  EditProfilePage({Key? key}) : super(key: key);
  final TextEditingController _editNumberController = TextEditingController();
  final TextEditingController _editNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Background(
              height: 375.0,
              image: AppIcons.up,
              child: Align(
                alignment: const AlignmentDirectional(-1.1, -0.7),
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
          ],
        ),
        StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(ModelUser.uid)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return Center(
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
                        height: 45.0,
                      ),
                      Container(
                        width: 228.0,
                        height: 228.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.0),
                          image: DecorationImage(
                            image: Image.asset(AppIcons.owl).image,
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
                        height: 20.0,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(70.0, 0.0, 70.0, 0.0),
                        child: TextFormField(
                          controller: _editNameController,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24.0,
                          ),
                          decoration: InputDecoration(
                            hintText: snapshot.data.data()['name'],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50.0,
                      ),
                      NumberForm(
                        controller: _editNumberController,
                        hintText: ModelUser.profilePhoneNumber,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextButton(
                        onPressed: () {
                          if (_editNameController.text != '') {
                            ModelUser.setName(_editNameController.text);
                          }
                          Utils.globalKey.currentState!
                              .pushReplacementNamed(ProfilePage.routName);
                        },
                        child: const Text(
                          'Сохранить',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                        ),
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
