import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class TestPage extends StatefulWidget {
  static const routName = '/test';

  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  var  selectedfile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:Text("Share Text, URL, Image or File"),
          backgroundColor: Colors.redAccent,
        ),
        body: Column(

          children: [
            Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                  onPressed: (){
                    Share.share('Hello Welcome to FlutterCampus', subject: 'Welcome Message');
                    //subject is optional, and it is required for Email App.
                  },
                  child: Text("Share Plain Text")),
            ),

            Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                  onPressed: (){
                    Share.share('Visit FlutterCampus at https://www.fluttercampus.com');
                  },
                  child: Text("Share text with URL")),
            ),

            Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                  onPressed: () async {


                    setState((){});
                  },
                  child: Text("Pick File to Share")),
            ),

            Container(
              alignment: Alignment.center,
              child: Text(selectedfile == null?"No File Selected":selectedfile.path),
            ),


            Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                  onPressed: () async {
                    if(selectedfile == null){
                      print("No any file is selected.");
                    }else{
                      Share.shareFiles([selectedfile.path], text: "View File");
                    }

                    setState((){});
                  },
                  child: Text("Share Picked File")),
            ),


          ],
        )
    );
  }
}
