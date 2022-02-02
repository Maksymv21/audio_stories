import 'package:audio_stories/pages/auth_pages/auth_page/auth_page.dart';
import 'package:audio_stories/pages/auth_pages/registration_page/registration_page.dart';
import 'package:audio_stories/pages/main_pages/main_widgets/button_menu.dart';
import 'package:audio_stories/pages/main_pages/models/model_user.dart';
import 'package:audio_stories/pages/profile_pages/profile_page/edit_profile_page.dart';
import 'package:audio_stories/pages/profile_pages/widgets/delete_acc_button.dart';
import 'package:audio_stories/resources/app_icons.dart';
import 'package:audio_stories/utils/local_db.dart';
import 'package:audio_stories/utils/utils.dart';
import 'package:audio_stories/widgets/background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  static const routName = '/profile';

  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: const [
            Expanded(
              child: Background(
                height: 375.0,
                image: AppIcons.up,
                child: Align(
                  alignment: AlignmentDirectional(-1.1, -0.95),
                  child: ButtonMenu(),
                ),
              ),
            ),
            Spacer(),
          ],
        ),
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(LocalDB.uid)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              // String? url = snapshot.data.data()['photo'];
              // String? name = snapshot.data.data()['name'];
              return Center(
                child: Column(
                  children: [
                    const Spacer(
                      flex: 3,
                    ),
                    const Expanded(
                      flex: 5,
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
                      flex: 2,
                    ),
                    Container(
                      width: 230.0,
                      height: 230.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.0),
                        image: DecorationImage(
                          image: Image.asset(AppIcons.photo).image,
                              // url == null
                              // ? Image.asset(AppIcons.photo).image
                              // : Image.network(url).image,
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
                    const Spacer(),
                    const Expanded(
                      flex: 4,
                      child: Text('Ваше имя',
                            // name == null
                            // ? 'Ваше имя'
                            // : snapshot.data.data()['name'],
                        style: TextStyle(
                          fontSize: 24.0,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      flex: 6,
                      child: PhysicalModel(
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
                    ),
                    const Spacer(),
                    Expanded(
                      flex: 4,
                      child: TextButton(
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
                    ),
                    const Spacer(
                      flex: 2,
                    ),
                    Expanded(
                      flex: 4,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Подписка',
                          style: TextStyle(
                            fontSize: 14.0,
                            decoration: TextDecoration.underline,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      child: Container(
                        width: 300.0,
                        height: 24.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Expanded(
                      flex: 2,
                      child: Text(
                        '0/500 мб',
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      flex: 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            onPressed: () {
                              Utils.firstKey.currentState!
                                  .pushReplacementNamed(AuthPage.routName);
                              RegistrationOrAuthText.text = 'Авторизация';
                            },
                            child: const Text('authorization'),
                          ),
                          const DeleteAccButton(),
                        ],
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ],
    );
  }
}
