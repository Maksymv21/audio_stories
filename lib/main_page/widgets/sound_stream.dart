import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../utils/local_db.dart';

class SoundStream extends StatelessWidget {

  const SoundStream({
    Key? key,
    required this.child,
    this.create,
  }) : super(key: key);

  final void Function(AsyncSnapshot)? create;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(LocalDB.uid)
          .collection('sounds')
          .where('deleted', isEqualTo: false)
          .orderBy(
            'date',
            descending: true,
          )
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if(create != null) create!(snapshot);
          return child;
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
