import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  static const String routName = '/test';

  TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  Map? data;

  addData() {
    Map<String, dynamic> demoData = {
      'name': '0',
      'phone': '123',
    };

    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('users');
    collectionReference.add(demoData);
  }

  readData() {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('users');
    collectionReference.snapshots().listen((snapshot) {
      setState(() {
        data = snapshot.docs[4].data() as Map?;
      });
    });
  }

  updateData() async{
    CollectionReference collectionReference =
    FirebaseFirestore.instance.collection('users');
    QuerySnapshot querySnapshot = await collectionReference.get();
    querySnapshot.docs[4].reference.update({'id' : '!!!'});
  }

  deleteData() async {
    CollectionReference collectionReference =
    FirebaseFirestore.instance.collection('users');
    QuerySnapshot querySnapshot = await collectionReference.get();
    querySnapshot.docs[4].reference.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () {
                addData();
              },
              child: Text('create'),
            ),
            TextButton(
              onPressed: () {
                readData();
              },
              child: Text('read'),
            ),
            TextButton(
              onPressed: () {
                updateData();
              },
              child: Text('update'),
            ),
            TextButton(
              onPressed: () {
                deleteData();
              },
              child: Text('delete'),
            ),
            Text(data!['name'].toString()),
          ],
        ),
      ),
    );
  }
}
