import 'package:audio_stories/pages/recently_deleted_pages/recently_deleted_page/edit_deleted_page.dart';
import 'package:audio_stories/pages/recently_deleted_pages/recently_deleted_page/general_deleted_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../resources/app_icons.dart';
import '../../../utils/database.dart';
import '../../../utils/local_db.dart';
import '../../../widgets/background.dart';
import '../../main_pages/widgets/button_menu.dart';
import '../../main_pages/widgets/sound_container.dart';

class RecentlyDeletedPage extends StatelessWidget {
  static const routName = '/deleted';

  const RecentlyDeletedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GeneralDeletedPage(
      button: const Align(
        alignment: AlignmentDirectional(-1.1, -0.92),
        child: ButtonMenu(),
      ),
      edit: false,
    );
  }
}

// class RecentlyDeletedPage extends StatefulWidget {
//   static const routName = '/deleted';
//
//   const RecentlyDeletedPage({Key? key}) : super(key: key);
//
//   @override
//   State<RecentlyDeletedPage> createState() => _RecentlyDeletedPageState();
// }
//
// class _RecentlyDeletedPageState extends State<RecentlyDeletedPage> {
//   bool _value = false;
//   bool _edit = false;
//
//   final Widget _buttonMenu = const Align(
//     alignment: AlignmentDirectional(-1.1, -0.95),
//     child: ButtonMenu(),
//   );
//
//   Widget _buttonSave(void Function()? onPressed) {
//     return Align(
//       alignment: const AlignmentDirectional(1.0, 0.4),
//       child: TextButton(
//         onPressed: onPressed,
//         child: const Text(
//           'Отменить',
//           style: TextStyle(
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Column(
//           children: [
//             Expanded(
//               flex: 3,
//               child: Background(
//                 height: 375.0,
//                 image: AppIcons.upSearch,
//                 child: Stack(
//                   children: [
//                     _edit
//                         ? _buttonSave(() {
//                             setState(() {
//                               _edit = false;
//                             });
//                             // Navigator.pushNamed(
//                             //     context, MainEditDeletedPage.routName);
//                           })
//                         : _buttonMenu,
//                     Align(
//                       alignment: const AlignmentDirectional(1.0, -0.5),
//                       child: PopupMenuButton(
//                         shape: ShapeBorder.lerp(
//                           const RoundedRectangleBorder(),
//                           const CircleBorder(),
//                           0.2,
//                         ),
//                         onSelected: (value) {
//                           if(value == 0) {
//                             MyApp.firstKey.currentState!.pushNamed(MainEditDeletedPage.routName);
//                           }
//                         },
//                         itemBuilder: (_) => [
//                           const PopupMenuItem(
//                             value: 0,
//                             child: Text(
//                               'Выбрать несколько',
//                               style: TextStyle(
//                                 fontSize: 14.0,
//                               ),
//                             ),
//
//                           ),
//                           PopupMenuItem(
//                             child: const Text(
//                               'Удалить все',
//                               style: TextStyle(
//                                 fontSize: 14.0,
//                               ),
//                             ),
//                             onTap: () {},
//                           ),
//                           PopupMenuItem(
//                             child: const Text(
//                               'Восстановить все',
//                               style: TextStyle(
//                                 fontSize: 14.0,
//                               ),
//                             ),
//                             onTap: () {},
//                           ),
//                         ],
//                         child: const Text(
//                           '...',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 60.0,
//                             letterSpacing: 3.0,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const Spacer(
//               flex: 5,
//             ),
//           ],
//         ),
//         Center(
//           child: Column(
//             children: [
//               const Padding(
//                 padding: EdgeInsets.all(30.0),
//                 child: Text(
//                   'Недавно'
//                   '\nудаленные',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w700,
//                     fontSize: 36.0,
//                     letterSpacing: 3.0,
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: _soundList(),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _soundList() {
//     return StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('users')
//             .doc(LocalDB.uid)
//             .collection('sounds')
//             .where('deleted', isEqualTo: true)
//             .orderBy('date', descending: false)
//             .snapshots(),
//         builder: (BuildContext context, AsyncSnapshot snapshot) {
//           if (snapshot.data?.docs.length == 0) {
//             return const Padding(
//               padding: EdgeInsets.only(
//                 top: 200.0,
//               ),
//               child: Text(
//                 'Как только ты удалишь'
//                 '\nаудио, она появится здесь.',
//                 style: TextStyle(
//                   fontSize: 24.0,
//                   color: Colors.grey,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             );
//           }
//           if (snapshot.hasData) {
//             return Padding(
//               padding: const EdgeInsets.only(top: 100.0, bottom: 10.0),
//               child: ListView.builder(
//                 itemCount: snapshot.data.docs.length,
//                 itemBuilder: (context, index) {
//                   String path = snapshot.data.docs[index].id;
//                   String title = snapshot.data.docs[index]['title'];
//                   String date = snapshot.data.docs[index]['date'].toString();
//
//                   return StreamBuilder(
//                     stream: FirebaseFirestore.instance
//                         .collection('users')
//                         .doc(LocalDB.uid)
//                         .snapshots(),
//                     builder: (BuildContext context, AsyncSnapshot snap) {
//                       if (snap.hasData) {
//                         int memory = snapshot.data.docs[index]['memory'];
//                         autoDelete(
//                           snapshot.data.docs[index]['dateDeleted'],
//                           path,
//                           title,
//                           date,
//                           memory,
//                         );
//
//                         return Column(
//                           children: [
//                             SoundContainer(
//                               color: const Color(0xff678BD2),
//                               title: title,
//                               time: (snapshot.data.docs[index]['time'] / 60)
//                                   .toStringAsFixed(1),
//                               buttonRight: _edit
//                                   ? _editButton(
//                                       _value,
//                                       () {
//                                         setState(() {
//                                           _value = !_value;
//                                         });
//                                       },
//                                     )
//                                   : _deletedButton(
//                                       path,
//                                       title,
//                                       date,
//                                       memory,
//                                     ),
//                             ),
//                             const SizedBox(
//                               height: 7.0,
//                             ),
//                           ],
//                         );
//                       } else {
//                         return Container();
//                       }
//                     },
//                   );
//                 },
//               ),
//             );
//           } else {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//         });
//   }
//
//   Widget _popupMenu(void Function()? onTap) {
//     return Align(
//       alignment: const AlignmentDirectional(1.0, -1.2),
//       child: PopupMenuButton(
//         shape: ShapeBorder.lerp(
//           const RoundedRectangleBorder(),
//           const CircleBorder(),
//           0.2,
//         ),
//         itemBuilder: (_) => [
//           PopupMenuItem(
//             child: const Text(
//               'Выбрать несколько',
//               style: TextStyle(
//                 fontSize: 14.0,
//               ),
//             ),
//             onTap: onTap,
//           ),
//           PopupMenuItem(
//             child: const Text(
//               'Удалить все',
//               style: TextStyle(
//                 fontSize: 14.0,
//               ),
//             ),
//             onTap: () {},
//           ),
//           PopupMenuItem(
//             child: const Text(
//               'Восстановить все',
//               style: TextStyle(
//                 fontSize: 14.0,
//               ),
//             ),
//             onTap: () {},
//           ),
//         ],
//         child: const Text(
//           '...',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 60.0,
//             letterSpacing: 3.0,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _deletedButton(
//     String path,
//     String title,
//     String date,
//     int memory,
//   ) {
//     return Align(
//       alignment: const AlignmentDirectional(0.95, 0.0),
//       child: IconButton(
//         splashColor: Colors.transparent,
//         highlightColor: Colors.transparent,
//         onPressed: () {
//           Database.deleteSound(
//             path,
//             title,
//             date,
//             memory,
//           );
//         },
//         icon: Image.asset(
//           AppIcons.delete,
//           color: Colors.black,
//         ),
//         iconSize: 20.0,
//       ),
//     );
//   }
//
//   Widget _editButton(bool value, void Function()? onTap) {
//     return Align(
//       alignment: const AlignmentDirectional(0.95, 0.0),
//       child: Padding(
//         padding: const EdgeInsets.only(right: 3.0),
//         child: Transform.scale(
//           scale: 1.4,
//           child: InkWell(
//             highlightColor: Colors.transparent,
//             splashColor: Colors.transparent,
//             onTap: onTap,
//             child: Container(
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   width: 1.5,
//                   color: Colors.black87,
//                 ),
//               ),
//               child: Transform.scale(
//                 scale: 0.5,
//                 child: Icon(
//                   Icons.check,
//                   size: 30.0,
//                   color: value ? Colors.black87 : Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void autoDelete(
//     Timestamp timestamp,
//     String path,
//     String title,
//     String date,
//     int memory,
//   ) {
//     final DateTime now = DateTime.now();
//     final DateTime timeDeleted = timestamp.toDate();
//
//     if (now.difference(timeDeleted).inDays >= 15) {
//       Database.deleteSound(path, title, date, memory);
//     }
//   }
// }
